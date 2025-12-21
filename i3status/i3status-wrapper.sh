#!/bin/bash

# Find the hwmon path for Intel CPU coretemp sensor
CORETEMP_PATH=$(for i in /sys/class/hwmon/*; do
    if [[ -f "$i/name" ]] && grep -q "coretemp" "$i/name"; then
        echo "$i"
        break
    fi
done)

# If not found, just set a default (prevents crash)
if [[ -z "$CORETEMP_PATH" ]]; then
    CORETEMP_PATH="/sys/class/hwmon/hwmon0"
fi

# Check which temp corresponds to the CPU package
PKG_TEMP_FILE=$(grep -l "Package id 0" "$CORETEMP_PATH"/temp*_label 2>/dev/null | head -n1)
if [[ -z "$PKG_TEMP_FILE" ]]; then
    # Fallback: first temp sensor
    PKG_TEMP_FILE="$CORETEMP_PATH/temp1_input"
else
    # Replace _label with _input
    PKG_TEMP_FILE="${PKG_TEMP_FILE/_label/_input}"
fi

# Create a temp i3status config with the correct path
TMP_CONFIG=$(mktemp /tmp/i3status-config-XXXXXX)

# Copy the base config (without the CPU temp section)
awk '
    BEGIN {skip=0}
    /^\s*cpu_temperature/ {skip=1}
    skip && /^\s*}/ {skip=0; next}
    !skip
' ~/.config/i3status/config > "$TMP_CONFIG"

# Append the CPU temperature block with the correct path
cat >> "$TMP_CONFIG" <<EOF

cpu_temperature 0 {
    path = "$PKG_TEMP_FILE"
    format = " CPU: %degrees °C"
}
EOF

# Run i3status using this temp config
exec i3status -c "$TMP_CONFIG"

