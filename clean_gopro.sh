#!/bin/bash
if [ $# -ne 1 ]
then
    echo "ERROR: Please provide folder to process";
    exit 1
fi
echo "Cleaning directory: $1";
find /media/mordka/BCAB-9076/DCIM/101GOPRO -maxdepth 1 -type f \( -name "*.LRV" -o -name "*.THM" \) -delete
if [ $? -eq 0 ]; then
  echo "Great success!";
else
    exit 1;
fi
exit 0
