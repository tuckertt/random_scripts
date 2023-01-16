#!/bin/bash

# source API token and cheat ID's
source /home/tuckertt/secured_items.txt

# Base URL for telegram API
base_notification_url="https://api.telegram.org"

# URL for checking messages "curl $base_notification_url/$api_token/getUpdates"

# URL's to monitor
working_test_url="https://store.nintendo.co.uk/en/nintendo-switch-usb-c-charging-cable-8ft-000000000010006767"
broken_test_url="https://store.nintendo.co.uk/en/b-c-charging-cable-8ft-000000000010006767"

nes_controller_url="https://store.nintendo.co.uk/en/nintendo-entertainment-system-controllers-for-nintendo-switch-000000000010000562"
snes_controller_url="https://store.nintendo.co.uk/en/super-nintendo-entertainment-system-controller-for-nintendo-switch-000000000010002877"
n64_controller_url="https://store.nintendo.co.uk/en/nintendo-64-controller-for-nintendo-switch-000000000010006981"

neon_mini_url="https://store.nintendo.co.uk/en/nintendo-switch-mini-controller-grey-neon-000000000010005756"
pikachu_grip_url="https://store.nintendo.co.uk/en/nintendo-switch-joy-con-comfort-grip-pikachu-000000000010005348"
zelda_joycon_url="https://store.nintendo.co.uk/en/nintendo-switch-joy-con-controller-set-the-legend-of-zelda-skyward-sword-hd-edition-000000000010007261"
red_grip_url="https://store.nintendo.co.uk/en/nintendo-switch-joy-con-comfort-grip-red-000000000003392966"

# Telegram chat group ID for notifications
general_group_id="-806329644"                  
nes_group_id="-1001800911862"
snes_group_id="-1001563232904"
n64_group_id="-1001875493062" 


# main function where all the checking and notifying happens
main () {

# set the first entry to "item", the second to "site_url" and the third to the group id to target
  item=$1
  site_url=$2
  group_id=$3

# curl the required URL and set the result to a variable
  url_curl=$( curl $site_url -s )

# capture the exit code to a seperate variable
  curl_exitcode=$?


# search the result of the curl for "NOTIFY ME" and record the output and exitcode  
  grep1=$(echo $url_curl | grep -o "NOTIFY ME")
  grep1_exitcode=$?

# search the result of the curl for the specific text and record the output and exitcode
  grep2=$(echo $url_curl | grep -o "Unfortunately this product is currently out of stock, please try again later.")
  grep2_exitcode=$?

# search the output of hte curl for ' "inventory":{"orderable":true ' then see how many lines there are that match
  grep3=$(echo $url_curl | grep -o '"inventory":{"orderable":true'| wc -l )
  grep3_exitcode=$?


# If the curl doesn't work for reasons then notify the admin and silence other alerts
  if [ "$curl_exitcode" != "0" ]; then
    message="$item curl not working - $site_url"
    url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
    curl "$url"

  elif [ "$grep1_exitcode" != "0" ] || [ "$grep2_exitcode" != "0" ] || [ "$grep3" != "1" ]; then 

# If the curl is a success then either checks to see if the required text was no longer present on the site
# OR looks to see if the number of lines associated with grep3 isn't equal to one - Nintendo has all the text
# available on the website under general function however adds extra instances of the required text if it's available
# ( realistically could probably remove the other greps... )
#  if [ "$grep1_exitcode" != "0" ] || [ "$grep2_exitcode" != "0" ] || [ "$grep3" != "1" ]; then
    message="$item possibly available  - $site_url"
    url="$base_notification_url/$api_token/sendMessage?chat_id=$group_id&text=$message"
    curl "$url"
    echo "-------------------- $item -------------------------------" >> notification_log.txt
    echo "$date_time" >> notification_log.txt
    echo "$url_curl" >> notification_log.txt
  fi


}

# test entry using an endpoint that's liable to never go out of stock
#   main "switch charging cable" $working_test_url $general_group_id
# pointless test as nintendo replies 200 on a 404
#   main "switch charging cable broken URL" $broken_test_url $general_group_id

# call the "main" function passing it the required variables
main "NES controller" $nes_controller_url $nes_group_id
main "SNES controller" $snes_controller_url $snes_group_id
main "N64 controller" $n64_controller_url $n64_group_id

main "neon mini controller" $neon_mini_url $general_group_id
main "pikachu joycon grip" $pikachu_grip_url $general_group_id
main "zelda joycon" $zelda_joycon_url $general_group_id
main "red joycon grip" $red_grip_url $general_group_id

# creates a timestamp variable for checking the current time
timestamp=$(date +%H%M)

# Belt and braces notification to the admin user to confirm the check is still running at known time intervals
if [ "$timestamp" = "0905" ] || [ "$timestamp" = "1630" ]; then
  message='cronjob trigger check'
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
fi
