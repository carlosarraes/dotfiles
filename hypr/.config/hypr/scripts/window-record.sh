#!/bin/bash

RECORDING_DIR="$HOME/Videos/recordings"
PID_FILE="/tmp/window-record.pid"
RECORDING_FILE="$RECORDING_DIR/screen-$(date '+%Y-%m-%d_%H-%M-%S').mp4"

start_recording() {
    if [[ -f "$PID_FILE" ]]; then
        notify-send "Recording" "Already recording!"
        exit 1
    fi
    
    mkdir -p "$RECORDING_DIR"
    
    # Start recording the entire screen
    wf-recorder -f "$RECORDING_FILE" &
    RECORDING_PID=$!
    
    echo $RECORDING_PID > "$PID_FILE"
    notify-send "Recording Started" "Recording entire screen\nSaving to: $(basename "$RECORDING_FILE")"
}

stop_recording() {
    if [[ ! -f "$PID_FILE" ]]; then
        notify-send "Recording" "No active recording found!"
        exit 1
    fi
    
    RECORDING_PID=$(cat "$PID_FILE")
    kill $RECORDING_PID 2>/dev/null
    rm "$PID_FILE"
    
    notify-send "Recording Stopped" "Video saved to: $(basename "$RECORDING_FILE")"
}

case "$1" in
    start)
        start_recording
        ;;
    stop)
        stop_recording
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac