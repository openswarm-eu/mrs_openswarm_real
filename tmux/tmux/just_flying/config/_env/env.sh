#!/bin/bash

############## GENERAL ##############
# location of the running script
ROS_LAUNCH_PATH="$PWD/launch"
ROS_CONFIG_PATH="$PWD/config"

export ROS_LAUNCH_PATH=$ROS_LAUNCH_PATH
export ROS_CONFIG_PATH=$ROS_CONFIG_PATH

############## GPS DATA ##############
export DATUM_LATITUDE=47.397743
export DATUM_LONGITUDE=8.545594
export DATUM_HEADING=0.0

############## ROS BAG ##############
export SYS_ROSBAG_ENABLED=0         # enable / disable bag recording (be careful to NOT run long term experiments without bags!)
export SYS_ROSBAG_SIZE='1024'       # max size before splitting in Mb (i.e. 0 = infinite, 1024 = 1024Mb = 1Gb)
export SYS_ROSBAG_DURATION='8h'
export SYS_ROSBAG_PATH="$HOME/bag_files/barnbot/latest/"

export SYS_ROSBAG_ARGS="
    --regex
    --split
    --size=$SYS_ROSBAG_SIZE
    --duration=$SYS_ROSBAG_DURATION
    --output-prefix=$SYS_ROSBAG_PATH
"
export SYS_ROSBAG_TOPICS="
    /imu_rion
    /lslidar_point_cloud
    /smart_bms_jbd_node/batt_smart_bms
"

############## RVIZ ##############
export USE_RVIZ=0           # enable / disable rviz