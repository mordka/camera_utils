#!/bin/bash
if [ $# -ne 1 ]
then
    echo "ERROR: Please provide folder to process";
    exit 1
fi
echo "Cleaning directory: $1";
find $1 -type f \( -name "*.LRV" -o -name "*.THM" \) -delete
if [ $? -eq 0 ]; then
  echo "Great success!";
else
    exit 1;
fi
exit 0
