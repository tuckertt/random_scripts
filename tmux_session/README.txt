Description
  A script to configure a tmux session based on command line arguments or specific file
  creates remote connections if wanted

usage:
  ./tmux_session.sh  -i ../inventory_file.yml -u <username> -g <ansible inventory group> -n <tmux session name>
  ./tmux_session.sh -n new_session -l rows -p 5 -r -c "user@server1, user@server2, user@server3"
  ./tmux_session.sh -n new_session2 -l rows -p 5 -r -c "$(cat test.txt)"

help file:
=======================================================================
| If no parameters entered the script will ask for them directly      |
| -h => this help file                                                |
| -p => The number of panes required                                  |
| -n => A name for the Tmux session                                   |
| -l => layout - columns / rows / tiled ( defaults to tiled )         |
|                                                                     |
| remote connections (will automatically set number of panes          |
| -k => psk file if not default                                       |
| -u => The user to connect with                                      |
|   manual                                                            |
|     -r => Whether you want to connect the panes to remote endpoints |
|     -c => A list of connections seperated by ',' ie                 |
|           '<user>@<device1>, <user>@<device2>, <user>@<device3>'    |
|   ansible inventory file                                            |
|     (requires jq and ansible to be installed)                       |
|     -i => The location of an ansible inventory file you with to use |
|     -g => The host grouping to connect to                           |
=======================================================================

