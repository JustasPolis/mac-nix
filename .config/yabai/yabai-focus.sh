#!/bin/bash

focus_app() {
    app_name=$1
    # Check if window for the given app exists
    if ! yabai -m query --windows | jq -e ".[] | select(.app == \"$app_name\")" >/dev/null; then
        # If not found, launch the app
        open -a "$app_name"
    fi

    # Focus on the window of the specified app
    yabai -m window --focus $(yabai -m query --windows | jq -r ".[] | select(.app == \"$app_name\") | .id")
}

focus_app "$1"
