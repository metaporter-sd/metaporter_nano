# SPDX-FileCopyrightText: Copyright (c) 2022 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.


# Parameters 
ARG REPO_NAME="metaporter_nano"
ARG MAINTAINER="Jehan Shah (jehan.shah8@gmail.com"
ARG DESCRIPTION="Uses an image with ROS 2 humble and adds dependencies for Arducam and other metaporter depndencies"


ARG BASE_IMAGE=nvcr.io/nvidia/l4t-jetpack:r35.1.0
FROM ${BASE_IMAGE} AS builder
# Get Jepack based on Ubuntu 20.04


FROM builder AS build1

# Build ROS 2 Humble from source 
# https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html
# https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_common/blob/main/docker/Dockerfile.humble
# https://github.com/dusty-nv/jetson-containers/blob/master/Dockerfile.ros.humble

ARG ROS_PKG=ros_base
ARG ROS_DISTRO=humble
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL /bin/bash
SHELL ["/bin/bash", "-c"]

WORKDIR /tmp

# Env setup
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV ROS_PYTHON_VERSION=3

# set Python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Basics
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		curl \
		wget \
		gnupg2 \
		lsb-release \
		ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository universe

# Add ROS2 apt repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null


# Common dev tools and ROS tools
# ROS fundamentals
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		build-essential \
		cmake \
		git \
		libbullet-dev \
		libpython3-dev \
		python3-colcon-common-extensions \
		python3-flake8 \
		python3-pip \
		python3-numpy \
		python3-pytest-cov \
		python3-rosdep \
		python3-setuptools \
		python3-vcstool \
		python3-rosinstall-generator \
		libasio-dev \
		libtinyxml2-dev \
		libcunit1-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# ROS Python fundamentals
RUN python3 -m pip install -U \
        flake8-blind-except \
        flake8-builtins \
        flake8-class-newline \
        flake8-comprehensions \
        flake8-deprecated \
        flake8-docstrings \
        flake8-import-order \
        flake8-quotes \
        pytest-repeat \
        pytest-rerunfailures \
        pytest 


# Upgrade cmake - https://stackoverflow.com/a/56690743
# This is needed to build some of the ROS2 packages

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  software-properties-common \
		  apt-transport-https \
		  ca-certificates \
		  gnupg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
		  	  
RUN wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y --no-install-recommends --only-upgrade \
            cmake \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
    
RUN cmake --version

# remove other versions of Python3
# workaround for 'Could NOT find Python3 (missing: Python3_NumPy_INCLUDE_DIRS Development)'

RUN apt purge -y python3.9 libpython3.9* || echo "python3.9 not found, skipping removal" && \
    ls -ll /usr/bin/python*

# Build ROS2 core from source
RUN mkdir -p ${ROS_ROOT}/src && \
	cd ${ROS_ROOT} && \
	# https://answers.ros.org/question/325245/minimal-ros2-installation/?answer=325249#post-id-325249
    	rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ${ROS_PKG} \
        	launch_xml \
		launch_yaml \
		launch_testing \
		launch_testing_ament_cmake \
		demo_nodes_cpp \
		demo_nodes_py \
		example_interfaces \
		camera_calibration_parsers \
		camera_info_manager \
		cv_bridge \
		v4l2_camera \
		vision_opencv \
		vision_msgs \
		image_geometry \
		image_pipeline \
		image_transport \
		compressed_image_transport \
		compressed_depth_image_transport \
		> ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
    cat ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
    vcs import src < ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
    # https://github.com/dusty-nv/jetson-containers/issues/181
    rm -r ${ROS_ROOT}/src/ament_cmake && \
    git -C ${ROS_ROOT}/src/ clone https://github.com/ament/ament_cmake -b ${ROS_DISTRO}

# install dependencies using rosdep
RUN apt-get update && \
    cd ${ROS_ROOT} && \
    rosdep init && \
    rosdep update && \
    rosdep install -y \
    	--ignore-src \
		--from-paths src \
	  	--rosdistro ${ROS_DISTRO} \
	  	--skip-keys "libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# build it!
RUN cd ${ROS_ROOT} && colcon build \
        --merge-install \
        --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    # remove build files
    rm -rf ${ROS_ROOT}/src && \
    rm -rf ${ROS_ROOT}/logs && \
    rm -rf ${ROS_ROOT}/build && \
    rm ${ROS_ROOT}/*.rosinstall
    	
# Set the default DDS middleware to cyclonedds
# https://github.com/ros2/rclcpp/issues/1335
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp


FROM build1 as build2

# Alias setup.bash for consistency with pre-built binary installations of ROS2
#RUN echo "source /opt/ros/${ROS_DISTRO}/install/local_setup.bash ; export ROS_DISTRO=${ROS_DISTRO}" > /opt/ros/${ROS_DISTRO}/setup.bash

# ROS environment 
ARG ROS_DOMAIN_ID=0
RUN . /opt/ros/humble/install/local_setup.bash 

# Source environment on every bash session
RUN echo "source /opt/ros/humble/install/local_setup.bash" >> ~/.bashrc

# Set domain ID
RUN export ROS_DOMAIN_ID=${ROS_DOMAIN_ID} 

# Get dependencies
RUN apt-get update && apt-get install -y \
	libcanberra-gtk-module \
	libpython3-dev \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /home

FROM build2 AS build3
# code environment
ENV SOURCE_DIR /home/workspaces
RUN mkdir -p "${SOURCE_DIR}"
WORKDIR "${SOURCE_DIR}"

ENV WS_DIR "${SOURCE_DIR}/metaporter_dev"
RUN mkdir -p "${WS_DIR}"

COPY . "${WS_DIR}" 
WORKDIR "${WS_DIR}"

# Build user packages
RUN . /opt/ros/${ROS_DISTRO}/setup.bash \
	&& colcon build

# Source the workspace and do it for all new terminals
RUN . install/local_setup.bash \
	&& echo "source install/local_setup.bash" >> ~/.bashrc

#RUN ros2 run examples_rclcpp_minimal_subscriber subscriber_member_function
# launch ros package
#CMD ["ros2", "launch", "examples", "hello_world_launch_test.py"]
