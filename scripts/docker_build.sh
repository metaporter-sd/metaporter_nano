#!/bin/bash

CONTAINER_IMAGE=metaporter-nano-ros:1.0

#from the root of the workspace stop at builder stage for dev
docker build --target build1 -t $CONTAINER_IMAGE -f src/metaporter_nano/docker/Dockerfile .

#from the root of the workspace, make entire for deploy
#docker build -t $CONTAINER_IMAGE -f src/metaporter_nano/docker/Dockerfile .
