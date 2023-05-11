#!/bin/bash

volumes="$( gluster volume list )"

for volume in $volumes; do
  echo "Checking heal status for volume - $volume"
  gluster volume heal $volume statistics heal-count
done

