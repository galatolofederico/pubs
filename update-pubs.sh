#!/bin/bash

function show_help(){
    echo "Usage: $0 [-f <csv file>] [-s]"
    echo "  -f <csv file>  CSV file to read from"
    echo "  -h              Show this help message"
}

CSV_LIST="publications.csv"

while getopts f:sh flag
do
    case "${flag}" in
        f) CSV_LIST=${OPTARG};;
        h) show_help && exit;;
    esac
done


while IFS=, read -r title date file; do
    echo "Updating $file"
    if [ "$title" = "title" ]; then
        continue
    fi
    if [ -z "$title" ] || [ -z "$date" ]; then
        echo "Error: $pub is missing title or date"
        exiftool "$pub"
        exit 1
    fi
    exiftool -overwrite_original -Title="$title" -filemodifydate="$date" "$file"
done < $CSV_LIST