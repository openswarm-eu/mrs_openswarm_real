#!/bin/bash

############## CONFIG #############
export UAV_NAME=uav6
export RUN_TYPE=realworld
export UAV_TYPE=x500
export UAV_MASS=5.367
export WORLD_NAME=ingeniarius_hq
export INITIAL_DISTURBANCE_X=0.0
export INITIAL_DISTURBANCE_Y=0.0
export SENSORS="pixhawk"
export OLD_PX4_FW=0
export GPS_PORT="/dev/serial/by-id/usb-Emlid_ReachM+_8243DBF507E2BB50-if02"
export IMU_PORT="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
export TOF_UP_PORT="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"

##############  ROS  ##############
# export ROS_MASTER_URI='http://192.168.8.170:11311'
# export ROS_IP='192.168.8.170'
export ROSCONSOLE_FORMAT='[${severity}] [${node}] [${function}] [${line}]: ${message}'

############ MRS FILES ############
export PLATFORM_CONFIG=./config/mrs_uav_system/$UAV_TYPE.yaml
export CUSTOM_CONFIG=./config/custom_config.yaml
export WORLD_CONFIG=./config/worlds/world_local.yaml
export NETWORK_CONFIG=./config/network_config.yaml

############## GENERAL ##############
# location of the running script
ROS_LAUNCH_PATH="$PWD/launch"
ROS_CONFIG_PATH="$PWD/config"

export ROS_LAUNCH_PATH=$ROS_LAUNCH_PATH
export ROS_CONFIG_PATH=$ROS_CONFIG_PATH

############## GPS DATA ##############
export DATUM_LATITUDE=41.22061958
export DATUM_LONGITUDE=-8.52732281
export DATUM_HEADING=0.0

############## ROS BAG ##############
export SYS_ROSBAG_ENABLED=0         # enable / disable bag recording (be careful to NOT run long term experiments without bags!)
export SYS_ROSBAG_SIZE='1024'       # max size before splitting in Mb (i.e. 0 = infinite, 1024 = 1024Mb = 1Gb)
export SYS_ROSBAG_DURATION='8h'
export SYS_ROSBAG_PATH="$HOME/bag_files/openswarm/latest/"

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
export USE_RVIZ=1           # enable / disable rviz

########## SWARM FORMATION #######
export SWARM_FORMATION=0 

############## UWB ###############
export SYS_UWB=0 