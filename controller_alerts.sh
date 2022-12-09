#!/bin/sh
# Setup base variables
# Telegrams base URL
base_notification_url="https://api.telegram.org"
# API token of the bot account used to authenticate
api_token="<bot API token goes here>"
# Direct chat ID between bot and user - used for debug / informational items
chatid="245468116"
# URL for NES controller
nes_url="https://store.nintendo.co.uk/en/nintendo-entertainment-system-controllers-for-nintendo-switch-000000000010000562"
# Telegram chat ID for the NES channel
nes_chat_id="-1001800911862"
# URL for SNES controller
snes_url="https://store.nintendo.co.uk/en/super-nintendo-entertainment-system-controller-for-nintendo-switch-000000000010002877"
# Telegram chat ID for the SNES channel
snes_chat_id="-1001563232904"
# URL for N64 controller
n64_url="https://store.nintendo.co.uk/en/nintendo-64-controller-for-nintendo-switch-000000000010006981"
# Telegram chat ID for the N64 channel
n64_chat_id="-1001875493062"


# NES controller check - curls the URL, makes note of the curl exit code, then greps for two phrase sets also taking note of the exit code
nes_controller_curl=$(curl $nes_url -s)
nes_curl_exit=$?
nes_controller_grep=$(echo $nes_controller_curl | grep -o "NOTIFY ME")
nes_controller_exit=$?
nes_controller_grep1=$(echo $nes_controller_curl | grep -o "Unfortunately this product is currently out of stock, please try again later.")
nes_controller_exit1=$?

# SNES controller check - curls the URL, makes note of the curl exit code, then greps for two phrase sets also taking note of the exit code
snes_controller_curl=$(curl $snes_url -s)
snes_curl_exit=$?
snes_controller_grep=$(echo $snes_controller_curl | grep -o "NOTIFY ME")
snes_controller_exit=$?
snes_controller_grep1=$(echo $snes_controller_curl | grep -o "Unfortunately this product is currently out of stock, please try again later.")
snes_controller_exit1=$?

# N64 controller check - curls the URL, makes note of the curl exit code, then greps for two phrase sets also taking note of the exit code
n64_controller_curl=$(curl $n64_url -s)
n64_curl_exit=$?
n64_controller_grep=$(echo $n64_controller_curl | grep -o "NOTIFY ME")
n64_controller_exit=$?
n64_controller_grep1=$(echo $n64_controller_curl | grep -o "Unfortunately this product is currently out of stock, please try again later.")
n64_controller_exit1=$?


# Checks to see if the NES website is available and notifies the admin user directly if there's an issue
if [ "$nes_curl_exit" != "0" ]; then
  message="NES curl not working - $nes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
fi

# Checks the exit code of the grep (text search) to see if the searched text is no longer there. 
# If no longer there will send a notification to the respective telegram channel.
# A debug style log added due to infriquent misfires of alerts
if [ "$nes_controller_exit" != "0" ] || [ "$nes_controller_exit1" != "0" ]; then
  message="NES controller possibly available  - $nes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$nes_chat_id&text=$message"
  curl "$url"
  echo "--------------------NES controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$nes_controller_curl" >> notification_log.txt
fi

# Checks to see if the SNES website is available and notifies the admin user directly if there's an issue
if [ "$snes_curl_exit" != "0" ]; then
  message="SNES curl not working - $snes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
fi

# Checks the exit code of the grep (text search) to see if the searched text is no longer there.
# If no longer there will send a notification to the respective telegram channel.
# A debug style log added due to infriquent misfires of alerts
if [ "$snes_controller_exit" != "0" ] || [ "$snes_controller_exit1" != "0" ]; then
  message="SNES controller possibly available - $snes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$snes_chat_id&text=$message"
  curl "$url"
  echo "--------------------SNES controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$snes_controller_curl" >> notification_log.txt
fi

# Checks to see if the N64 website is available and notifies the admin user directly if there's an issue
if [ "$n64_curl_exit" != "0" ]; then
  message="N64 curl not working - $n64_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
fi

# Checks the exit code of the grep (text search) to see if the searched text is no longer there.
# If no longer there will send a notification to the respective telegram channel.
# A debug style log added due to infriquent misfires of alerts
if [ "$n64_controller_exit" != "0" ] || [ "$n64_controller_exit1" != "0" ]; then
  message="N64 controller possibly available - $n64_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$n64_chat_id&text=$message"
  curl "$url"
  echo "--------------------N64 controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$n64_controller_curl" >> notification_log.txt
fi

# creates a timestamp variable for checking the current time
timestamp=$(date +%H%M)

# Belt and braces notification to the admin user to confirm the check is still running at known time intervals
if [ "$timestamp" = "0905" ] || [ "$timestamp" = "1630" ]; then
  message='cronjob trigger check'
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
fi
