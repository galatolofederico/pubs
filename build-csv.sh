#!/bin/sh

function show_help(){
    echo "Usage: $0 [-f <csv file>] [-s]"
    echo "  -f <csv file>  CSV file to read from"
    echo "  -s              Strict mode"
    echo "  -h              Show this help message"
}

CSV_LIST="publications.csv"
STRICT=0

while getopts f:sh flag
do
    case "${flag}" in
        f) CSV_LIST=${OPTARG};;
        s) STRICT=1;;
        h) show_help && exit;;
    esac
done

echo "Outputting to $CSV_LIST"
echo "Strict mode: $STRICT"
echo ""

rm -f $CSV_LIST
echo "title,date,file" >> $CSV_LIST
for pub in publications/*; do
    echo "Processing $pub"
    title=$(exiftool -Title "$pub" | cut -d: -f2 | sed 's/^\s*\|\s*$//g')
    date=$(exiftool -filemodifydate "$pub" | cut -d: -f2- | sed 's/^\s*\|\s*$//g')
    if [ $STRICT -eq 1 ]; then
        if [ -z "$title" ] || [ -z "$date" ]; then
            echo "Error: $pub is missing title or date"
            exiftool "$pub"
            exit 1
        fi
    fi
    echo "$title,$date,$pub" >> $CSV_LIST
done