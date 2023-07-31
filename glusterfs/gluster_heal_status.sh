#!/bin/bash

volumes="$( gluster volume list )"
summary=""

for volume in $volumes; do
  echo "  Checking heal status for volume - $volume"
  volumes_healing="$( gluster volume heal $volume statistics heal-count | grep -E "Number of entries: [1-9]" -B1 )"
  if [ "$?" -eq "0" ]; then
    echo "$volumes_healing"
    summary="$summary\n$volume"
  else
    echo "  volume not showing anything required"
  fi
  echo ""
done

echo "====================================="
echo "Summary of volume heal check:"
echo "The followinmg volumes are healing:"
echo -e "$summary"
echo "====================================="
