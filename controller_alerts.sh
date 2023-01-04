#!/bin/sh

base_notification_url="https://api.telegram.org"
api_token"<bot API token goes here>"=
chatid="245468116"
default_message="test notification $date"
nes_url="https://store.nintendo.co.uk/en/nintendo-entertainment-system-controllers-for-nintendo-switch-000000000010000562"
nes_chat_id="-1001800911862"
snes_url="https://store.nintendo.co.uk/en/super-nintendo-entertainment-system-controller-for-nintendo-switch-000000000010002877"
snes_chat_id="-1001563232904"
n64_url="https://store.nintendo.co.uk/en/nintendo-64-controller-for-nintendo-switch-000000000010006981"
n64_chat_id="-1001875493062"

if [ -z "$message" ]; then
  message=$default_message
fi


url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"

nes_controller_curl=$(curl $nes_url -s)
nes_curl_exit=$?
nes_controller_grep=$(echo $nes_controller_curl | grep -o "NOTIFY ME")
nes_controller_exit=$?
nes_controller_grep1=$(echo $nes_controller_curl | grep -o "Unfortunately this product is currently out of stock, please try again later.")
nes_controller_exit1=$?
nes_controller_grep2=$(echo $nes_controller_curl | grep -o '"inventory":{"orderable":true'| wc -l )


snes_controller_curl=$(curl $snes_url -s)
snes_curl_exit=$?
snes_controller_grep=$(echo $snes_controller_curl | grep -o "NOTIFY ME")
snes_controller_exit=$?
snes_controller_grep1=$(echo $snes_controller_curl | grep -o "Unfortunately this product is currently out of stock, please try again later.")
snes_controller_exit1=$?
snes_controller_grep2=$(echo $snes_controller_curl | grep -o '"inventory":{"orderable":true'| wc -l )

n64_controller_curl=$(curl $n64_url -s)
n64_curl_exit=$?
n64_controller_grep=$(echo $n64_controller_curl | grep -o "NOTIFY ME")
n64_controller_exit=$?
n64_controller_grep1=$(echo $n64_controller_curl | grep -o "Unfortunately this product is currently out of stock, please try again later.")
n64_controller_exit1=$?
n64_controller_grep2=$(echo $n64_controller_curl | grep -o '"inventory":{"orderable":true'| wc -l )


if [ "$nes_curl_exit" != "0" ]; then
  message="NES curl not working - $nes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
  nes_controller_exit="0"
  nes_controller_exit1="0"
  nes_controller_grep2="0"
fi

if [ "$nes_controller_exit" != "0" ] || [ "$nes_controller_exit1" != "0" ]; then
  message="NES controller possibly available  - $nes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$nes_chat_id&text=$message"
  curl "$url"
  echo "--------------------NES controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$nes_controller_curl" >> notification_log.txt
fi

if [ "$nes_controller_grep2" != "1" ];  then
  message="NES controller possibly available  - $nes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$nes_chat_id&text=$message"
  curl "$url"
  echo "--------------------NES controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$nes_controller_curl" >> notification_log.txt
fi

if [ "$snes_curl_exit" != "0" ]; then
  message="SNES curl not working - $snes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
  snes_controller_exit="0"
  snes_controller_exit1="0"
  snes_controller_grep2="0"
fi

if [ "$snes_controller_exit" != "0" ] || [ "$snes_controller_exit1" != "0" ]; then
  message="SNES controller possibly available - $snes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$snes_chat_id&text=$message"
  curl "$url"
  echo "--------------------SNES controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$snes_controller_curl" >> notification_log.txt
fi

if [ "$snes_controller_grep2" != "1" ]; then
  message="SNES controller possibly available - $snes_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$snes_chat_id&text=$message"
  curl "$url"
  echo "--------------------SNES controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$snes_controller_curl" >> notification_log.txt
fi


if [ "$n64_curl_exit" != "0" ]; then
  message="N64 curl not working - $n64_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
  n64_controller_exit="0"
  n64_controller_exit1="0"
  n64_controller_grep2="0"
fi

if [ "$n64_controller_exit" != "0" ] || [ "$n64_controller_exit1" != "0" ]; then
  message="N64 controller possibly available - $n64_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$n64_chat_id&text=$message"
  curl "$url"
  echo "--------------------N64 controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$n64_controller_curl" >> notification_log.txt
fi

if [ "$n64_controller_grep2" != "1" ]; then
  message="N64 controller possibly available - $n64_url"
  url="$base_notification_url/$api_token/sendMessage?chat_id=$n64_chat_id&text=$message"
  curl "$url"
  echo "--------------------N64 controller-------------------------------" >> notification_log.txt
  echo "$date_time" >> notification_log.txt
  echo "$n64_controller_curl" >> notification_log.txt
fi


timestamp=$(date +%H%M)
if [ "$timestamp" = "0905" ] || [ "$timestamp" = "1630" ]; then
  message='cronjob trigger check'
  url="$base_notification_url/$api_token/sendMessage?chat_id=$chatid&text=$message"
  curl "$url"
fi
