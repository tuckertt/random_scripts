#!/bin/bash

connections=""

while getopts n:p:c:i:k:g:u:l:hrs flag
do
    case "${flag}" in
        n) session_name=${OPTARG};;
        r) remote="TRUE";;
        u) user=${OPTARG};;
        p) panes=${OPTARG};;
        c) connections=${OPTARG};;
        i) inventory_file=${OPTARG};;
        g) device_group=${OPTARG};;
        k) key_file_location=${OPTARG};;
        s) stylish="TRUE";;
        l) layout=${OPTARG};;
        h) help_requested="TRUE";;
    esac
done

help_file () {
  echo "======================================================================="
  echo "| If no parameters entered the script will ask for them directly      |"
  echo "| -h => this help file                                                |"
  echo "| -p => The number of panes required                                  |"
  echo "| -n => A name for the Tmux session                                   |"
  echo "| -l => layout - columns / rows / tiled ( defaults to tiled )         |"
  echo "|                                                                     |"
  echo "| remote connections (will automatically set number of panes          |"
  echo "| -k => psk file if not default                                       |"
  echo "| -u => The user to connect with                                      |"
  echo "|   manual                                                            |"
  echo "|     -r => Whether you want to connect the panes to remote endpoints |"
  echo "|     -c => A list of connections seperated by ',' ie                 |"
  echo "|           '<user>@<device1>, <user>@<device2>, <user>@<device3>'    |"
  echo "|   ansible inventory file                                            |" 
  echo "|     (requires jq and ansible to be installed)                       |"
  echo "|     -i => The location of an ansible inventory file you with to use |"
  echo "|     -g => The host grouping to connect to                           |"
  echo "======================================================================="
  exit 3
}

no_command_line_parameters () {
  read -p "What would you like to call the Tmux session? " session_name
  read -p "How many panes would you like to create? " panes
  read -p "Are you connecting to remote devices in these panes? [y/n]" remote
  case $remote in 
    y|yes|Yes|YES) 
      remote="TRUE"
      for pane in $(seq 1 $panes); do
        cmd_connection=""
        read -p "For pane $pane what are you connecting to ( user@device ) " cmd_connection
        connections="$connections $cmd_connection,"
echo $cmd_connection
      done;;
    *)
  esac
  echo $connections
}

ansible_inventory_file () {
  devices_list=""
  connections=""
  remote="TRUE"


  if [ -f "$inventory_file" ]; then
    if [ -z "$device_group" ]; then echo "No device group specified"; exit 1; fi
    if [ -z "$user" ]; then echo "No user specified"; exit 1; fi
    has_children="$(ansible-inventory -i $inventory_file --list | jq .$device_group.children)"
    device_groups=$device_group
    # check if hosts list variable is null
    if [[ "$has_children" != "null" ]]; then
      echo "Device group appears to be a parent <insert Scooby Doo reference here>"
      device_groups="$(ansible-inventory -i $inventory_file --list | jq .$device_group.children | sed 's/[][",]//g')"
    fi

    for groups in $device_groups; do
      devices=""
      devices="$(ansible-inventory -i $inventory_file --list | jq .$groups.hosts | sed 's/[][",]//g')"
      devices_list="$devices_list $devices"
    done

    device_list="$( echo "$devices_list" | tail -n +2 )"
    for device in $device_list; do
      connection=""
      connection="$( echo "$device" | sed "s/^[[:space:]]*/$user@/g")"
      connections="$connections$connection, "
    done

  else
    echo "Can't read file, quitting"
    exit 2
  fi

}

# shows help info
if [[ "$help_requested" == "TRUE" ]]; then help_file; fi
# If no command line parameters provided calls function to request them
if [ $# -eq 0 ]; then no_command_line_parameters; fi
# If ansible inventory file provided gets information for remote connections
if [ -n "$inventory_file" ]; then ansible_inventory_file; fi


# If the panes variable isn't present then will calculate number of panes required based on remote sessions
if [ -z "$panes" ]; then
  panes="$(echo "$connections" |sed 's/[^@]//g' | awk '{ print length }')"
fi

# Checks to see if the session is already in use and exits if it is
session_check="$(tmux ls | grep -e "^$session_name:" )"
if [ -n "$session_check" ]; then
  echo "session name is already in use"
  echo "$session_check"
  exit 1
fi

# Creates a new Tmux session called by the provided session name
tmux new -d -s $session_name

# If an SSH key is specified, sets up the text for the SSH session
if [ -n "$key_file_location" ]; then
  key_file="-i $key_file_location"
else
  key_file=""
fi

# Creates tmux panes. If remote option is set then will also send the command to SSH to them
for pane in $(seq 1 $panes); do
  commands=""

  if [[ "$remote" == "TRUE" ]]; then
    remote_server="$(echo $connections | cut -d "," -f $pane)"
    commands="ssh $key_file $remote_server"
  fi

  tmux send-keys -t $session_name "$commands" Enter

  if [ $pane != $panes ]; then
    tmux split-window -t $session_name
  fi

done

# Sets the tmux layout so the windows are evenly spaced
case $layout in
  columns)
    tiling="even-horizontal";;
  rows)
    tiling="even-vertical";;
  *)
    tiling="tiled";;
esac
tmux select-layout -t $session_name:0 $tiling


# Sets colours and things
if [ -n "$sylish"]; then
  tmux set-option -t $session_name status-bg cyan
  tmux set-option -t $session_name window-status-style bg=yellow
  tmux set-option -t $session_name window-status-current-style bg=red,fg=white
fi

echo "to re-attach to session type 'tmux attach -t $session_name' "
tmux -2 attach-session -t $session_name
