#!/bin/bash
MAX_WIDTH=190
MAX_HEIGHT=44
IN_COL_GAP=10
COLUMN_WIDTH=2
declare -A arr
for((i=0; i<MAX_HEIGHT; i++)); do
    for((j=0; j<MAX_WIDTH; j++)); do
        arr[$i,$j]=' '
    done
done
mkfifo /tmp/game_pipe 2>/dev/null
exec 3<>/tmp/game_pipe
rm /tmp/game_pipe
(
    while IFS= read -r -n1 key; do
        echo "$key" >&3
    done
) &
INPUT_PID=$!
cleanup() {
    kill $INPUT_PID 2>/dev/null
    exec 3>&-
    tput cnorm
    exit 0
}
stty -icanon -echo
trap cleanup EXIT
print_board(){
    tput cup 0 0
    for((i=0; i<MAX_HEIGHT; i++)); do
        for((j=0; j<MAX_WIDTH; j++)); do
            echo -n "${arr[$i,$j]}"
        done
        echo
    done
}
tput civis
clear
GAP=0
column_counter=0
birdX=22
birdY=22
velocity=0
for((j=0; j<MAX_WIDTH; j++)); do
    arr[0,$j]='@'
    arr[$((MAX_HEIGHT-1)),$j]='@'
done
while true; do
    arr[$birdX,$birdY]=' '
    if read -t 0 key <&3; then
        echo "Key pressed: $key" > debug.log
        case $key in
            w|W) velocity=-2;;
        esac
    fi
    ((velocity++))
    if ((velocity > 2)); then
        velocity=2
    fi
    ((birdX += velocity))
    if ((birdX < 1)); then
        birdX=1
        velocity=0
    elif ((birdX >= MAX_HEIGHT-1)); then
        birdX=$((MAX_HEIGHT-2))
        velocity=0
    fi
    for((i=1; i<MAX_HEIGHT-1; i++)); do
        for((j=0; j<MAX_WIDTH-COLUMN_WIDTH; j++)); do
            arr[$i,$j]=${arr[$i,$((j+COLUMN_WIDTH))]}
        done
    done
    if((column_counter >= IN_COL_GAP)); then
        rand_height=$((5+RANDOM%25))
        for((i=1; i<MAX_HEIGHT-1; i++)); do
            if((i<rand_height || i>=rand_height+IN_COL_GAP)); then
                for((j=0; j<COLUMN_WIDTH; j++)); do
                    arr[$i,$((MAX_WIDTH-COLUMN_WIDTH+j))]='|'
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
            for((j=0; j<COLUMN_WIDTH; j++)); do
                arr[$i,$((MAX_WIDTH-COLUMN_WIDTH+j))]=' '
            done
        done
        ((column_counter++))
    fi
    for((j=0; j<MAX_WIDTH; j++)); do
        arr[0,$j]='@'
        arr[$((MAX_HEIGHT-1)),$j]='@'
    done
    arr[$birdX,$birdY]='&'
    print_board
    sleep 0.1
done
