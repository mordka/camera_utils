#!/bin/bash

# STEP00 - Checking params
if [ $# -le 1 ]; then
    echo "ERROR: Please provide folder to process";
    exit 1
fi
if [ ! -d "$1" ];  then
    echo "Source directory doesn't exist";
    exit 1;
fi
##### PARAMETERS #######
SRC_DIR=${1%/};
IMAGE_SIZE='1920:1080'
FPS_VALUE=20
# FILE_LIST=`find ${SRC_DIR} -type f -name "*.JPG"`
# echo $FILE_LIST
cd $SRC_DIR
echo "Creating timelape from selected files."
echo "Photos will be scaled to $IMAGE_SIZE and played with $FPS_VALUE frames/second"
echo "Output file will be placed in: $SRC_DIR/timelapse.mp4"
mencoder -nosound -ovc lavc -lavcopts \
vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 \
-vf scale=$IMAGE_SIZE -mf type=jpeg:fps=$FPS_VALUE \
mf://*.JPG -o timelapse.mp4
