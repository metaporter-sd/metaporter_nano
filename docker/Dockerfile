
# Uses an image with ROS 2 humble and adds dependencies for Arducam and other metaporter depndencies
ARG BASE_IMAGE=ros:humble-ros-base-jammy
FROM ${BASE_IMAGE}

# ROS environment 
ARG ROS_DOMAIN_ID=0
RUN source /opt/ros/humble/setup.bash \
    && echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc \
    && export ROS_DOMAIN_ID=${ROS_DOMAIN_ID} \
    && echo "export ROS_DOMAIN_ID=${ROS_DOMAIN_ID}" >> ~/.bashrc

# Colcon to build ROS packages
RUN sudo apt install python3-colcon-common-extensions