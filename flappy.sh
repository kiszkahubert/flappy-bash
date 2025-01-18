#!/bin/bash
MAX_WIDTH=190
MAX_HEIGHT=44
IN_COL_GAP=10
COLUMN_WIDTH=2
declare -A arr
declare -A birdArr
for((i=0; i<MAX_HEIGHT; i++)); do
    for((j=0; j<MAX_WIDTH; j++)); do
        arr[$i,$j]=' '
        arr[0,$j]='@'
        arr[$((MAX_HEIGHT-1)),$j]='@'
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
column_counter=0

while true; do
    for((i=1; i<MAX_HEIGHT-1; i++)); do
        for((j=0; j<MAX_WIDTH-COLUMN_WIDTH; j++)); do
            arr[$i,$j]=${arr[$i,$((j+COLUMN_WIDTH))]}
        done
    done
    for((i=1; i<MAX_HEIGHT-1; i++)); do
        for((j=0; j<COLUMN_WIDTH; j++)); do
            unset arr[$i,$j]
        done
    done
    if((column_counter >= IN_COL_GAP)); then
        rand_height=$((5+RANDOM%25))
        for((i=1; i<MAX_HEIGHT-1; i++)); do
            if((i<rand_height || i>=rand_height+IN_COL_GAP)); then
                for((j=0; j<COLUMN_WIDTH; j++)); do
                    arr[$i,$((MAX_WIDTH-COLUMN_WIDTH+j))]='*'
                done
            else
                for((j=0; j<COLUMN_WIDTH; j++)); do
                    arr[$i,$((MAX_WIDTH-COLUMN_WIDTH+j))]=' '
                done
            fi
        done
        column_counter=0
    else
        for((i=1; i<MAX_HEIGHT-1; i++)); do
            for((w=0; w<COLUMN_WIDTH; w++)); do
                arr[$i,$((MAX_WIDTH-COLUMN_WIDTH+w))]=' '
            done
        done
        column_counter=$((column_counter+1))
    fi
    for((j=0; j<MAX_WIDTH; j++)); do
        arr[0,$j]='@'
        arr[$((MAX_HEIGHT-1)),$j]='@'
    done
    print_board
    sleep 0.1
done
