# Parameters 
ARG REPO_NAME="metaporter_nano"
ARG MAINTAINER="Jehan Shah (jehan.shah8@gmail.com")
ARG DESCRIPTION="Uses an image with ROS 2 humble and adds dependencies for Arducam and other metaporter depndencies"
ARG ROS_DISTRO=humble
ARG BASE_IMAGE=ros:humble-ros-base-jammy
FROM ${BASE_IMAGE}

# code environment
ENV SOURCE_DIR /home
WORKDIR "${SOURCE_DIR}"

ENV WS_DIR "${SOURCE_DIR}/metaporter_dev"
RUN mkdir -p "${WS_DIR}"
#assumes running build from root of metaporter dev
COPY . "${WS_DIR}" 
WORKDIR "${WS_DIR}"

SHELL ["/bin/bash", "-c"]

# ROS environment 
ARG ROS_DOMAIN_ID=0
RUN . /opt/ros/${ROS_DISTRO}/setup.bash 

# source environment on every bash session
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

RUN export ROS_DOMAIN_ID=${ROS_DOMAIN_ID} 
	
# Colcon to build ROS packages
RUN sudo apt-get update && apt-get install -y \
	python3-colcon-common-extensions \
	#~nros-humble-rqt* \
	&& rm -rf /var/lib/apt/lists/*

# Build packages
RUN . /opt/ros/${ROS_DISTRO}/setup.bash \
	&& colcon build

RUN . install/local_setup.bash

#RUN ros2 run examples_rclcpp_minimal_subscriber subscriber_member_function
# launch ros package
#CMD ["ros2", "launch", "examples", "hello_world_launch_test.py"]