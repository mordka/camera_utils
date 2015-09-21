#!/bin/bash

function check_exit {
  if [ $? -eq 0 ]; then
    echo $1;
  else
    echo "Something went wrong."
    exit 1;
  fi
}
function make_dir {
  if [ ! -d "$1" ];  then
    mkdir  $1
    check_exit "Directory $1 has been created"
  else
    echo "Directory '$(basename ${1})' already exists. OK!"
  fi
}

# STEP00 - Checking params
if [ $# -le 1 ]; then
    echo "ERROR: Please provide folder to process";
    exit 1
fi

##### PARAMETERS #######
SRC_DIR=${1%/};
DEST_DIR=${2%/};
_CURRENT_DIR=`pwd`
FRAMERATE='25'
export IMAGE_SIZE='1920x1080'

# STEP01 - Copy files with a progress bar
make_dir ${DEST_DIR}
printf "Copying images for timelapse... \n from: $1 \n to: $2 \n";
cd ${DEST_DIR}
# see docs: http://www.theiling.de/projects/bar.html
export BAR_CMD='cat > $(basename ${bar_file})'
# $_CURRENT_DIR/bar `find ${SRC_DIR} -type f -name "*.JPG"`
check_exit "Copied."

# STEP02 - Resizing images
make_dir resized
echo "Resizing images to ${IMAGE_SIZE}"
# export BAR_CMD=' mogrify -quality 100 -path resized -resize ${IMAGE_SIZE} ${bar_file}  '
# $_CURRENT_DIR/bar *.JPG
parallel --progress gm mogrify -quality 100 -output-directory resized -resize ${IMAGE_SIZE} ::: *.JPG
check_exit "OK"
echo "Image resizing done"
rm *.JPG

# STEP03 - Merge images into movie file
echo "Creating movie"
ffmpeg -loglevel panic -r $FRAMERATE -pattern_type glob -i 'resized/*.JPG' -c:v copy output.avi
# ffmpeg -r $FRAMERATE -pattern_type glob -i 'resized/*.JPG' -c:v mjpeg -q:v 30 output.avi
check_exit "OK"
_size=$(du -sm output.avi -h | cut -f1)
echo "Created output.avi (size: ${_size})"
rm -r resized/

# STEP04 - Compression
echo "Compressing..."
ffmpeg -i output.avi -c:v libx264 -preset slow -crf 15 output-final.mkv
check_exit "OK"
_new_size=$(du -sm output.avi -h | cut -f1)
printf "Compression done.\n Filename: output-final.mkv \n Size: ${_new_size}\n"


echo "GREAT SUCCESS! Enjoy your timelapse!"
exit 0
