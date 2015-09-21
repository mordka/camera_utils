#!/bin/bash
if [ $# -le 1 ]; then
    echo "ERROR: Please provide folder to process";
    exit 1
fi
SRC_DIR=${1%/};
DEST_DIR=${2%/};
_CURRENT_DIR=`pwd`

function check_exit {
  if [ $? -eq 0 ]; then
    echo $1;
  else
    exit 1;
  fi
}

# STEP00 - Prepare destination directory
if [ ! -d "$DEST_DIR" ];  then
  mkdir  $DEST_DIR
  check_exit "Directory $DEST_DIR has been created"
else
  echo "Directory '$(basename ${DEST_DIR})' already exists. OK!"
fi

# STEP01 - Copy files with a progress bar
printf "Copying images for timelapse... \n from: $1 \n to: $2 \n";
cd ${DEST_DIR}
# see docs: http://www.theiling.de/projects/bar.html
export BAR_CMD='cat > $(basename ${bar_file})'
$_CURRENT_DIR/bar `find ${SRC_DIR} -type f -name "*.JPG"`


# STEP
exit 0
