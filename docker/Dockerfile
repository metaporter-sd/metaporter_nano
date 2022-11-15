# Parameters 
ARG REPO_NAME="metaporter_nano"
ARG MAINTAINER="Jehan Shah (jehan.shah8@gmail.com")
ARG DESCRIPTION="Uses an image with ROS 2 humble and adds dependencies for Arducam and other metaporter depndencies"
ARG ROS_DISTRO=humble
ARG BASE_IMAGE=ros:humble-ros-base-jammy
FROM ${BASE_IMAGE} AS builder


SHELL ["/bin/bash", "-c"]

# ROS environment 
ARG ROS_DOMAIN_ID=0
RUN . /opt/ros/${ROS_DISTRO}/setup.bash 

# Source environment on every bash session
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

# Set domain ID
RUN export ROS_DOMAIN_ID=${ROS_DOMAIN_ID} 

# Get dependencies
RUN sudo apt-get update && apt-get install -y \
	wget \
	python3-colcon-common-extensions \
	#~nros-humble-rqt* \
	libpython3-dev \
	&& rm -rf /var/lib/apt/lists/*

# Get Arducam specific dependencies
RUN wget https://bootstrap.pypa.io/get-pip.py \
	&& sudo python3 get-pip.py

RUN sudo pip3 install stereovision \ 
	matplotlib 

# get arducam driver 
WORKDIR "src/arducam_stereo_camera"
RUN wget https://github.com/ArduCAM/MIPI_Camera/releases/download/v0.0.3/install_full.sh \
	&& chmod +x install_full.sh \
	&& yes | ./install_full.sh -m imx477_stereo 

# Arducam driver check
RUN dmesg | grep imx477

# Arducam connection check
RUN i2cdetect -r -y 7


FROM builder AS build1
# code environment
ENV SOURCE_DIR /home/workspaces
RUN mkdir -p "${SOURCE_DIR}"
WORKDIR "${SOURCE_DIR}"

ENV WS_DIR "${SOURCE_DIR}/metaporter_dev"
RUN mkdir -p "${WS_DIR}"

COPY . "${WS_DIR}" 
WORKDIR "${WS_DIR}"

FROM build1 AS build2

# Build packages
RUN . /opt/ros/${ROS_DISTRO}/setup.bash \
	&& colcon build

# Source the workspace and do it for all new terminals
RUN . install/local_setup.bash \
	&& echo "source install/local_setup.bash" >> ~/.bashrc

#RUN ros2 run examples_rclcpp_minimal_subscriber subscriber_member_function
# launch ros package
#CMD ["ros2", "launch", "examples", "hello_world_launch_test.py"]