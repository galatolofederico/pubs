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
    if [ "$title" = "title" ]; then
        continue
    fi
    echo "Checking $file"
    
    if [ -z "$title" ] || [ -z "$date" ]; then
        echo "Error: $pub is missing title or date"
        exiftool "$pub"
        exit 1
    fi
    pdf_title=$(exiftool -Title "$file" | cut -d ':' -f 2- | sed 's/^[[:space:]]*//')
    pdf_date=$(exiftool -modifydate "$file" | cut -d ':' -f 2- | sed 's/^[[:space:]]*//')
    
    if [ "$pdf_title" != "$title" ] || [ "$pdf_date" != "$date" ]; then
        echo "$file does not match CSV"
        echo "CSV: $title, $date"
        echo "PDF: $pdf_title, $pdf_date"
        exiftool -overwrite_original -Title="$title" -modifydate="$date" "$file"
        echo "Updated $file"
    fi

done < $CSV_LIST