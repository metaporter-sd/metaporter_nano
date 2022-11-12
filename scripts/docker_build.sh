#!/bin/bash

CONTAINER_IMAGE=metaporter-nano-ros:1.0

#from the root of the workspace
docker build -t $CONTAINER_IMAGE -f src/metaporter_nano/docker/Dockerfile .
