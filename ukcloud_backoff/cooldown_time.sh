#!/bin/bash

source $PWD/secured_items.txt

cooldown_seconds=$( curl -i -H "Authorization: token $git_auth_token" https://api.github.com/user | grep x-ratelimit-remaining | rep -o '[[:num:]]')
current_seconds=$(date +%s)

cooldown_info=$( curl -i -H "Authorization: token $git_auth_token" https://api.github.com/user | grep ratelimit )

cooldown_expiry_seconds=$(( $cooldown_seconds + $current_seconds ))

cooldown_time=$( date -d @$cooldown_expiry_seconds "+%Y-%m-%d %H:%M")

echo "Github reports that continuation can occur at \"$cooldown_time\" "
echo "cooldown info"
echo "$cooldown_info"
