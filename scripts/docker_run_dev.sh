#!/bin/bash

CONTAINER_IMAGE=metaporter-nano-ros:1.0
# give docker root user X11 permissions
sudo xhost +si:localuser:root

# enable SSH X11 forwarding inside container (https://stackoverflow.com/q/48235040)
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
chmod 777 $XAUTH

docker run --runtime nvidia -it --rm --network host \
    --network host \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix/:/tmp/.X11-unix \
    -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH \
    -v /tmp/argus_socket:/tmp/argus_socket \
    -v /home/metaporter/workspaces/metaporter_dev:/home/workspaces/metaporter_dev \
    $USER_VOLUME $CONTAINER_IMAGE $USER_COMMAND





