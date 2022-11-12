# Parameters 
ARG REPO_NAME="metaporter_nano"
ARG MAINTAINER="Jehan Shah (jehan.shah8@gmail.com")
ARG DESCRIPTION="Uses an image with ROS 2 humble and adds dependencies for Arducam and other metaporter depndencies"

ARG BASE_IMAGE=ros:humble-ros-base-jammy
FROM ${BASE_IMAGE}

# code environment
ENV SOURCE_DIR /home
WORKDIR "${SOURCE_DIR}"

ENV WS_DIR "${SOURCE_DIR}/metaporter_dev"
#assumes running build from root of metaporter dev
COPY . "${WS_DIR}" 

# ROS environment 
ARG ROS_DOMAIN_ID=0
RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
#    && echo ". /opt/ros/humble/setup.sh" >> ~/.bashrc \

RUN export ROS_DOMAIN_ID=${ROS_DOMAIN_ID} \
#    && echo "export ROS_DOMAIN_ID=${ROS_DOMAIN_ID}" >> ~/.bashrc

# Colcon to build ROS packages
RUN sudo apt install python3-colcon-common-extensions

RUN sudo apt update && sudo apt install ~nros-humble-rqt*

# Build packages
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
 	colcon build \
	--workspace ${WS_DIR}/

RUN . install/setup.sh
