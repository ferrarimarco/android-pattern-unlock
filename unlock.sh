#!/bin/bash
#
# Android pattern unlock
# Author: Matt Wilson
# Author: Marco Ferrari (minor changes)
# Licence: Free to use and share. If this helps you please buy me a beer :)
#
# This script sends simulated touch input over ADB for remotely swiping on Android's pattern lockscreen.
# This allows you to unlock the device even if the touch screen is broken.
#
# Note: You must have USB debugging enabled on your device for this script to work (in the developer options).
# This script will not work unless this option is enabled. I recommend turning it on to make life easier if you drop your phone.
# Note: The device does not need to be rooted for this method to work.
#
# You need to have adb on your PATH to run this script.
# E.g. on Mac add to ~/.bash_profile: export PATH="/Users/username/Library/Android/sdk/platform-tools:$PATH"
#
# Customise the variables in the top section of the script with your phone's unlock code and coordinates
#
# Usage:
# chmod +x unlock.sh
# ./unlock.sh

# =======================================================================================================================

# Variables
#
# Coordinates will vary depending on the screen resolution of your device (defaults are for Nexus 4 at 768x1280)
# The pattern should be set based on the following layout:
# 1 2 3
# 4 5 6
# 7 8 9

PATTERN="1 2 3 6 5 4 7 8 9" # The unlock pattern to draw, space seperated

COL_1=391                   # X coordinate of column 1 (in pixels)
COL_2=778                   # X coordinate of column 2 (in pixels)
COL_3=1165                   # X coordinate of column 3 (in pixels)

ROW_1=1155                   # Y coordinate of row 1 (in pixels)
ROW_2=1627                   # Y coordinate of row 2 (in pixels)
ROW_3=1969                   # Y coordinate of row 3 (in pixels)

WAKE_SCREEN_ENABLED=true    # If true, the script will start by sending the power button press event

SWIPE_UP_ENABLED=true       # If true, the script will swipe upwards before drawing the pattern (e.g. for lollipop lockscreen)
SWIPE_UP_X=450              # X coordinate for initial upward swipe. Only used if SWIPE_UP_ENABLED is true
SWIPE_UP_Y_FROM=1000        # Start Y coordinate for initial upward swipe. Only used if SWIPE_UP_ENABLED is true
SWIPE_UP_Y_TO=200           # End Y coordinate for initial upward swipe. Only used if SWIPE_UP_ENABLED is true

# =======================================================================================================================

# Define X&Y coordinates for each of the 9 positions.

X[1]=$(( ${COL_1} ))
X[2]=$(( ${COL_2} ))
X[3]=$(( ${COL_3} ))
X[4]=$(( ${COL_1} ))
X[5]=$(( ${COL_2} ))
X[6]=$(( ${COL_3} ))
X[7]=$(( ${COL_1} ))
X[8]=$(( ${COL_2} ))
X[9]=$(( ${COL_3} ))

Y[1]=$(( ${ROW_1} ))
Y[2]=$(( ${ROW_1} ))
Y[3]=$(( ${ROW_1} ))
Y[4]=$(( ${ROW_2} ))
Y[5]=$(( ${ROW_2} ))
Y[6]=$(( ${ROW_2} ))
Y[7]=$(( ${ROW_3} ))
Y[8]=$(( ${ROW_3} ))
Y[9]=$(( ${ROW_3} ))

# Function definitions

WakeScreen() {
	if [ "$WAKE_SCREEN_ENABLED" = true ]; then
		adb shell input keyevent 26
	fi
}

SwipeUp() {
	if [ "$SWIPE_UP_ENABLED" = true ]; then
		adb shell input swipe ${SWIPE_UP_X} ${SWIPE_UP_Y_FROM} ${SWIPE_UP_X} ${SWIPE_UP_Y_TO}
	fi
}

StartTouch() {
	adb shell sendevent /dev/input/event2 3 57 14
}

SendCoordinates () {
	adb shell sendevent /dev/input/event2 3 53 $1
	adb shell sendevent /dev/input/event2 3 54 $2
	adb shell sendevent /dev/input/event2 3 58 57
	adb shell sendevent /dev/input/event2 0 0 0
}

FinishTouch() {
	adb shell sendevent /dev/input/event2 3 57 4294967295
	adb shell sendevent /dev/input/event2 0 0 0
}

SwipePattern() {
	for NUM in $PATTERN
	do
	   echo "Sending $NUM: ${X[$NUM]}, ${Y[$NUM]}"
	   SendCoordinates ${X[$NUM]} ${Y[$NUM]}
	done
}

# Actions

WakeScreen
SwipeUp
StartTouch
SwipePattern
FinishTouch
