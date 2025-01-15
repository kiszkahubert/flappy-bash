#!/bin/bash
MAX_WIDTH=190
MAX_HEIGHT=44
IN_COL_GAP=10
declare -A arr

for((i=0; i<MAX_HEIGHT; i++)); do
    for((j=0; j<MAX_WIDTH; j++)); do
        arr[$i,$j]=' '
    done
done
print_board(){
    clear
    for((i=0; i<MAX_HEIGHT; i++)); do
        for((j=0; j<MAX_WIDTH; j++)); do
            echo -n "${arr[$i,$j]}"
        done
        echo
    done
}
print_board

GAP=0
while true; do
    for((i=0; i<MAX_HEIGHT; i++)); do
        arr[$i,$((MAX_WIDTH-1))]=' '
    done
    for((i=0; i<MAX_HEIGHT; i++));do
        for((j=0; j<MAX_WIDTH-1; j++));do
            arr[$i,$j]=${arr[$i,$((j+1))]}
        done
    done
    rand_height=$((5+RANDOM%25))
    for((i=0; i<MAX_HEIGHT; i++)); do
        if((i<rand_height || i>=rand_height+IN_COL_GAP)); then
            arr[$i,$((MAX_WIDTH-1))]='*'
        else
            arr[$i,$((MAX_WIDTH-1))]=' '
        fi
    done
    print_board
    sleep 1
done
