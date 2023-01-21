#!/bin/bash
# source API token and ID's
source /home/tuckertt/secured_items.txt

# Base URL for telegram API
base_notification_url="https://api.telegram.org"

# URL for checking messages "curl $base_notification_url/$api_token/getUpdates"

# URL's to monitor
working_test_url="https://store.nintendo.co.uk/en/nintendo-switch-usb-c-charging-cable-8ft-000000000010006767"
#broken_test_url="https://store.nintendo.co.uk/en/nintendo-true-wireless-sound-earphones-splatoon-2-000000000010010345"

nes_controller_url="https://store.nintendo.co.uk/en/nintendo-entertainment-system-controllers-for-nintendo-switch-000000000010000562"
snes_controller_url="https://store.nintendo.co.uk/en/super-nintendo-entertainment-system-controller-for-nintendo-switch-000000000010002877"
n64_controller_url="https://store.nintendo.co.uk/en/nintendo-64-controller-for-nintendo-switch-000000000010006981"

neon_mini_url="https://store.nintendo.co.uk/en/nintendo-switch-mini-controller-grey-neon-000000000010005756"
pikachu_grip_url="https://store.nintendo.co.uk/en/nintendo-switch-joy-con-comfort-grip-pikachu-000000000010005348"
zelda_joycon_url="https://store.nintendo.co.uk/en/nintendo-switch-joy-con-controller-set-the-legend-of-zelda-skyward-sword-hd-edition-000000000010007261"
red_grip_url="https://store.nintendo.co.uk/en/nintendo-switch-joy-con-comfort-grip-red-000000000003392966"

# Telegram chat group ID for notifications
general_group_id="-1001869897858"                  
nes_group_id="-1001800911862"
snes_group_id="-1001563232904"
n64_group_id="-1001875493062" 
other_group_id="-1001850708858"

# main function where all the checking and notifying happens
main () {
# set the first entry to "item", the second to "site_url" and the third to the group id to target added a fourth for extra text match on silence
  item=$1
  site_url=$2
  group_id=$3
  optional_text=$4

  echo "-------------------- $item -------------------------------" >> notification_log.txt
  echo "$( date -d @$EPOCHSECONDS "+%Y-%m-%d %H:%M") $item" >> notification_log.txt

# curl the required URL and set the result to a variable
  url_curl=$( curl -s -L $site_url )

# capture the exit code to a seperate variable
  curl_exitcode=$?

# search the result of the curl for "NOTIFY ME" and record the output and exitcode  
  grep1=$(echo $url_curl | grep -o "NOTIFY ME")
  grep1_exitcode=$?

# search the output of hte curl for ' "inventory":{"orderable":true ' then see how many lines there are that match
  grep2=$(echo $url_curl | grep -o '"inventory":{"orderable":true'| wc -l )
  grep2_exitcode=$?

  if [ "$url_curl" == *"https://store.nintendo.co.uk/en/404"* ]; then   
    echo "404 found" >> notification_logs.txt
    curl_exitcode=200
  fi


# If the curl doesn't work for reasons then notify the admin and silence other alerts
  if [ "$curl_exitcode" != "0" ]; then
    message="$item curl not working - $site_url"
    url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
    curl "$urli -s"

# If the curl is a success then either checks to see if the required text was no longer present on the site
# OR looks to see if the number of lines associated with grep3 isn't equal to one - Nintendo has all the text
# available on the website under general function however adds extra instances of the required text if it's available
# ( realistically could probably remove the other greps... )
  elif [ "$grep1_exitcode" != "0" ] || [ "$grep2" != "1" ]; then

# check to see if there are any posts on the bots telegram feed and find out how many posts there are by the numner of update ID's  
    curl_result=$( curl -s  https://api.telegram.org/$api_token/getUpdates )
    result_array=$(echo "$curl_result" | jq ".result[].update_id" | wc -l)

# set the variable in control of silencing alerts to false
    silenced=false

# for loop based on the number of update ID's
    for (( i=0; i<${result_array}; i++ )); do

# for each post extract the id number of hte chat, the time in epoch and the text posted
      id=$(echo "$curl_result" | jq .result[$i].channel_post.sender_chat.id)
      datestamp=$(echo "$curl_result" | jq .result[$i].channel_post.date)
      text=$(echo "$curl_result" | jq .result[$i].channel_post.text | tr -d "\"")

# if the id of the post matches the ID of the group chat and if the text starts with shush...
      if [ "$id" = "$group_id" ]; then
        if [ -n "$optional_text" ]; then
          if [[ $text == *"$optional_text"* ]]; then
            echo "optional text ($optional_text) present and matched ($text)"  >> notification_log.txt
          else
            echo "optional text ($optional_text) present and failed to match ($text)"  >> notification_log.txt
            continue
          fi
        fi
        if [[ $text == "shush"* ]]; then

# strip "shus" from shush to leave the trailing h's, make sure there are only h's and get the number of h's used
          requested_silence=${text#shus}
          focused_silence=$( echo "$requested_silence" | sed 's/[^h]//g' )
          silence_count="${#focused_silence}"
          hour="3600"

# multiply the number of h's used by an hour of epoch so that each h used is an extra hour of silenced alert, add to the time of the post
# then set silenced to true until that time has passed
          quiet_time=$(( $hour*$silence_count ))
          alerts_paused_until=$(( $quiet_time+$datestamp ))
          if [[ "$alerts_paused_until" -gt "$EPOCHSECONDS" ]]; then
            silenced=true
          fi
        fi
      fi
    done

# if hte alert hasn't been silenced post an alert and log the result, otherwise log the reason for not firing    
    if [ "$silenced" = false ]; then
      message="$item possibly available  - $site_url"
      url="$base_notification_url/$api_token/sendMessage?chat_id=$group_id&text=$message"
      curl -s "$url" 
      echo "$date_time" >> notification_log.txt
      echo "$grep3" >> notification_log.txt
    elif  [ "$silenced" = true ]; then
      echo "Alert would have fired however a pause is in place and time not reached " >> notification_log.txt
      echo "current time is $( date -d @$EPOCHSECONDS "+%Y-%m-%d %H:%M"), paused time is  $( date -d @$alerts_paused_until "+%Y-%m-%d %H:%M")" >> notification_log.txt
      echo "pausing text is - $text" >> notification_log.txt
    fi
  fi
}

# test entry using an endpoint that's liable to never go out of stock
 main "switch charging cable" $working_test_url $general_group_id "cable"

# call the "main" function passing it the required variables
main "NES controller" $nes_controller_url $nes_group_id
main "SNES controller" $snes_controller_url $snes_group_id
main "N64 controller" $n64_controller_url $n64_group_id

main "neon mini controller" $neon_mini_url $general_group_id
main "pikachu joycon grip" $pikachu_grip_url $general_group_id
main "zelda joycon" $zelda_joycon_url $general_group_id "zelda"
main "red joycon grip" $red_grip_url $general_group_id


echo "run complete" >> notification_log.txt
echo; echo; echo >> notification_log.txt

# creates a timestamp variable for checking the current time
timestamp=$(date +%H%M)

# Belt and braces notification to the admin user to confirm the check is still running at known time intervals
if [ "$timestamp" = "0905" ] || [ "$timestamp" = "1630" ]; then
  message='cronjob trigger check'
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
fi
