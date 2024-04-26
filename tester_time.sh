#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Use: $0 <protocol> <host> <port> <input file> <output file>"
    exit 1
fi

protocol=$1
host=$2
port=$3
in_file=$4
out_file=$5

run_ppcbc() {
    time_file=$(mktemp)
    err_file=$(mktemp)
    { time -p ../ppcbc "$protocol" "$host" "$port" <"$in_file" 2>"$err_file"; } 2>"$time_file"
    exec_time=$(cat "$time_file" | sed -n 's/real //p')
    [ -s "$err_file" ] || echo "$exec_time"
    rm "$err_file"
    rm "$time_file"
}

for ((i=1; i<=10; i++)) do
    ex_time=$(run_ppcbc)
    echo "$ex_time" >> "$out_file"
done
