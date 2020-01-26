#!/bin/bash

# Loud fan control script to lower speed of fan based on current
# max temperature of any cpu
#
# See README.md for details.

#set to false to suppress logs
DEBUG=false


TEMPERATURE_FILE="/sys/devices/virtual/thermal/thermal_zone0/temp"
FAN_MODE_FILE="/sys/devices/platform/pwm-fan/hwmon/hwmon0/automatic"
FAN_SPEED_FILE="/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1"
TEST_EVERY="3" #seconds
new_fan_speed_default="100"
LOGGER_NAME=odroid-xu4-fan-control

#make sure after quiting script fan goes to auto control
function cleanup {
  ${DEBUG} && logger -t $LOGGER_NAME "event: quit; temp: auto"
  echo 1 > ${FAN_MODE_FILE}
}
trap cleanup EXIT

function exit_xu4_only_supported {
  ${DEBUG} && logger -t $LOGGER_NAME "event: non-xu4 $1"
  exit 2
}
if [ ! -f $TEMPERATURE_FILE ]; then
  exit_xu4_only_supported "a"
elif [ ! -f $FAN_MODE_FILE ]; then
  exit_xu4_only_supported "b"
elif [ ! -f $FAN_SPEED_FILE ]; then
  exit_xu4_only_supported "c"
fi


current_max_temp=`cat ${TEMPERATURE_FILE} | cut -d: -f2 | sort -nr | head -1`
echo "fan control started. Current max temp: ${current_max_temp}"
echo "For more logs see:"
echo "sudo tail -f /var/log/syslog"

while [ true ];
do
  echo "0" > ${FAN_MODE_FILE} #to be sure we can manage fan

  current_max_temp=`cat ${TEMPERATURE_FILE} | cut -d: -f2 | sort -nr | head -1`
  ${DEBUG} && logger -t $LOGGER_NAME "event: read_max; temp: ${current_max_temp}"

  new_fan_speed="100"
  if [ $current_max_temp -gt "75000" ]; then
    new_fan_speed="255"
  elif [ $current_max_temp -gt "70000" ]; then
    new_fan_speed="240"
  elif [ $current_max_temp -gt "68000" ]; then
    new_fan_speed="100"
  elif [ $current_max_temp -gt "66000" ]; then
    new_fan_speed="100"
  elif [ $current_max_temp -gt "63000" ]; then
    new_fan_speed="100"
  elif [ $current_max_temp -gt "60000" ]; then
    new_fan_speed="100"
  elif [ $current_max_temp -gt "58000" ]; then
    new_fan_speed="100"
  elif [ $current_max_temp -gt "55000" ]; then
    new_fan_speed="100"
  else
    new_fan_speed="100"
  fi
  ${DEBUG} && logger -t $LOGGER_NAME "event: adjust; speed: ${new_fan_speed}"
  echo ${new_fan_speed} > ${FAN_SPEED_FILE}

  sleep ${TEST_EVERY}
done
