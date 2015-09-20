#!/bin/bash
if [ $# -lt 2 ]
then
    echo "ERROR: Please provide source and destination directories";
    exit 1
fi
SRC_DIR=${1%/};
DEST_DIR=${2%/};

function clean_THM_and_LRV {
  ./clean_gopro.sh $1;
}
function copy_with_status {
  filename=$(basename $x)
  printf "Copying $filename to $1/$filename \n"
  ./bar -o "$1/$filename" $2
}
function aggregate {
    folder_name=$(date -r "$1" +%F-%A)
    mkdir -p "$DEST_DIR/$folder_name"
    copy_with_status "$DEST_DIR/$folder_name" $x
    # mv -- "$x" "/your/new/directory/$folder_name/"
}
function check_exit {
  if [ $? -eq 0 ]; then
    echo $1;
  else
    exit 1;
  fi
}

### STEP01 - clean from unnecessary *.LRV and *.THM files ###
clean_THM_and_LRV $SRC_DIR
check_exit "Cleaned from LRV and THM files"

### STEP02 - copy files based on date created ###
for x in $SRC_DIR/*; do
  aggregate $x
  check_exit "Copied $(du -sm "$x" | cut -f1)MB"
done

### STEP03 - cleanup
echo "Wiping old data from the source directory $SRC_DIR..."
rm -Ir $SRC_DIR/*

check_exit "Aggregation has finished successfully."
exit 0;
