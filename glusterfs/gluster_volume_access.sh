#!/bin/bash

volumes="$( gluster volume list )"
source ./gluster_servers.txt

for volume in $volumes; do
  echo "setting auth for volume - $volume"
  if [ -n "$auth_allow" ]; then
    echo "auth.allow exists, setting for $volume"
    gluster volume set $volume  auth.allow $auth_allow
  else
   echo "auth.allow variable not present, skipping"
  fi
  if [ -n "$auth_ssl_allow" ]; then
    echo "auth.ssl-allow exists, setting for $volume"
    gluster volume set $volume  auth.ssl-allow $auth_ssl_allow
  else
   echo "auth.ssl-allow variable not present, skipping"
  fi
  echo "-------"
done

