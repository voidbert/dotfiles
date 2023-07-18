#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Tiny script to increase (./backlight.sh +p) and decrease (./backlight.sh -p)
# backlight brightness, where p is in percent points.
#
# ------------------------------- CONFIGURATION -------------------------------

# Where the backlight files are located
BACKLIGHT_DIR=/sys/class/backlight/intel_backlight

# Minimum brightness in nits, to avoid getting a completely black screen
# The maximum brightness is determined automatically.
MIN_BRIGHTNESS=1

# Exponent for the perceived brightness (it follows Steven's power law)
EXPONENT=0.33

# ---------------------------------- SCRIPT ----------------------------------

# Existence verification is needed because not all systems have backlights.
if [ ! -d "$BACKLIGHT_DIR" ]; then
	echo "No backlight found!"
	exit 1
fi

# Verify argument.
first_char=$(echo "$1" | cut -c1)
if [ "$first_char" != "+" ] && [ "$first_char" != "-" ]; then
	echo "Wrong usage of backlight.sh!"
	echo ""
	echo "./backlight.sh +p : increase brightness by p%"
	echo "./backlight.sh -p : decrease brightness by p%"
	exit 1
fi

MAX_BRIGHTNESS=$(cat "$BACKLIGHT_DIR/max_brightness")
current_brightness=$(cat "$BACKLIGHT_DIR/brightness")

# maximum_intensity ------- 100
# actual_delta      ------- percent_delta
#
# maximum_intensity = MAX_BRIGHTNESS ^ exponent
# actual_delta      = (percent_delta * maximum_intensity) / 100
#                   = (percent_delta * (MAX_BRIGHTNESS ^ exponent)) / 100
delta=$(echo "$1" "$MAX_BRIGHTNESS" "$EXPONENT" | \
	awk '{ print ($1 * ($2 ^ $3)) / 100 }')

# current_intensity = current_brightness ^ exponent
# target_intensity  = current_intensity + delta
#                   = (current_brightness ^ exponent) + delta
# target_brightness = (target_intensity) ^ (1 / exponent)
#                   = ((current_brightness ^ exponent) + delta) ^ (1 / exponent)
target_brightness=$(echo "$current_brightness" "$EXPONENT" "$delta" | \
	awk '{ print (($1 ^ $2) + $3) ^ (1 / $2) }')

# Convert to integer
if [ "$target_brightness" = "-nan" ]; then
	target_brightness=0
else
	target_brightness=$(printf "%.0f" "$target_brightness")
fi

# Clamp brightness between MIN_BRIGHTNESS and MAX_BRIGHTNESS
if [ "$target_brightness" -lt "$MIN_BRIGHTNESS" ]; then
	final_brightness="$MIN_BRIGHTNESS"
elif [ "$target_brightness" -gt "$MAX_BRIGHTNESS" ]; then
	final_brightness="$MAX_BRIGHTNESS"
else
	final_brightness="$target_brightness"
fi

echo "$current_brightness nits -> $final_brightness nits"
echo "$final_brightness" | doas tee "$BACKLIGHT_DIR/brightness" > /dev/null

