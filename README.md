# metaporter

## Quickstart

Set up your development environment by following the instructions [here](https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_common/blob/main/docs/dev-env-setup.md).  

Clone this repository and its dependencies under `~/workspaces/metaporter_dev/src`.

```bash
mkdir -p ~/workspaces/metaporter_dev
cd ~/workspaces/metaporter_dev
git clone https://github.com/jehanshah8/metaporter_nano.git
```

If you are on a memory-limited platform such as the Jetson Nano (4GB), increasing the swap size to 6GB is reccomended as it will be required to build ROS packages from source. You can do that by following the instructions [here](https://jetsonhacks.com/2019/04/14/jetson-nano-use-more-memory/).

Build the image using our convinience script

```bash
bash src/metaporter_nano/scripts/docker_build.sh
```

Run the container 

```bash
bash src/metaporter_nano/scripts/docker_run_dev.sh
```

The container will build all packages, source the setuup files, and source the workspace. You can directly run ROS nodes from the packages in your workspace. 
