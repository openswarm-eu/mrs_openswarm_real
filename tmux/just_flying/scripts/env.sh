#!/bin/bash

############## CHANGE #############
export UAV_NAME=uav12
export WORLD_NAME=ingeniarius	# forest, ingeniarius
export RESET_COMMAND_FLAG=0

############## CONFIG #############
export RUN_TYPE=realworld
export UAV_TYPE=x500
export UAV_MASS=5.367
export INITIAL_DISTURBANCE_X=0.0
export INITIAL_DISTURBANCE_Y=0.0
export SENSORS="pixhawk"
export OLD_PX4_FW=0
export GPS_PORT="/dev/serial/by-id/usb-Emlid_ReachM+_8243DBF507E2BB50-if02"
export IMU_PORT="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
export TOF_UP_PORT="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
export RESET_COMMAND="{broadcast: false, command: 246, confirmation: 0, param1: 1.0, param2: 0.0, param3: 0.0, param4: 0.0, param5: 0.0, param6: 0.0, param7: 0.0}"

##############  ROS  ##############
# export ROS_MASTER_URI='http://192.168.8.170:11311'
# export ROS_IP='192.168.8.170'
export ROSCONSOLE_FORMAT='[${severity}] [${node}] [${function}] [${line}]: ${message}'

############ MRS FILES ############
export PLATFORM_CONFIG=./config/mrs_uav_system/$UAV_TYPE.yaml
export CUSTOM_CONFIG=./config/custom_config.yaml
export NETWORK_CONFIG=./config/network_config.yaml

############## GENERAL ##############
# location of the running script
ROS_LAUNCH_PATH="$PWD/launch"
ROS_CONFIG_PATH="$PWD/config"

export ROS_LAUNCH_PATH=$ROS_LAUNCH_PATH
export ROS_CONFIG_PATH=$ROS_CONFIG_PATH

############## GPS DATA ##############
if [ "$WORLD_NAME" = "ingeniarius" ]; then
	export WORLD_CONFIG=./config/worlds/world_local_ingeniarius.yaml
    export DATUM_LATITUDE=41.22061958
    export DATUM_LONGITUDE=-8.52732281
    export DATUM_HEADING=0.0
elif [ "$WORLD_NAME" = "forest" ]; then
	export WORLD_CONFIG=./config/worlds/world_local_forest.yaml
    export DATUM_LATITUDE=41.21711155
    export DATUM_LONGITUDE=-8.52746193
    export DATUM_HEADING=0.0
else
    echo "Unknown WORLD_NAME: $WORLD_NAME"
    exit 1
fi

############## ROS BAG ##############
export SYS_ROSBAG_ENABLED=0         # enable / disable bag recording (be careful to NOT run long term experiments without bags!)
export SYS_ROSBAG_SIZE='1024'       # max size before splitting in Mb (i.e. 0 = infinite, 1024 = 1024Mb = 1Gb)
export SYS_ROSBAG_DURATION='8h'
export SYS_ROSBAG_PATH="$HOME/bag_files/openswarm/"

export SYS_ROSBAG_ARGS="
    --regex
    --split
    --size=$SYS_ROSBAG_SIZE
    --duration=$SYS_ROSBAG_DURATION
    --output-prefix=$SYS_ROSBAG_PATH
"
export SYS_ROSBAG_TOPICS="
	/$UAV_NAME/nlink_linktrack_nodeframe2		
	/$UAV_NAME/uwb(.*)
	/$UAV_NAME/mavros(.*)
	/$UAV_NAME/rtk(.*)
	/$UAV_NAME/hw_api/imu
	/$UAV_NAME/hw_api/gnss
	/$UAV_NAME/hw_api/altitude
	/$UAV_NAME/hw_api/odometry
	/$UAV_NAME/hw_api/velocity
	/$UAV_NAME/hw_api/angular_velocity
	/$UAV_NAME/hw_api/battery_state
	/$UAV_NAME/gnss_verifier/gnss_wstatus
	/$UAV_NAME/lslidar/pcl_filtered
	/$UAV_NAME/estimation_manager/odom_main
	/$UAV_NAME/odometry/gps
	/$UAV_NAME/distributedMapping/localPath
	/$UAV_NAME/distributedMapping/globalMap
	/$UAV_NAME/odom
"

############## RVIZ ##############
export USE_RVIZ=0           # enable / disable rviz
export COMPUTER_RVIZ=0      # enable / disable rviz on the computer

########## SWARM FORMATION #######
export SWARM_FORMATION=0 

############## UWB ###############
export SYS_UWB=0 