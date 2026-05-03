#! /bin/bash

exposure="$1"

if [ -z "$exposure" ]; then
  exposure=250
fi

echo "Setting exposure: $exposure"

v4l2-ctl -d /dev/video0 --set-ctrl=auto_exposure=1
v4l2-ctl -d /dev/video0 --set-ctrl=exposure_time_absolute="$exposure"
