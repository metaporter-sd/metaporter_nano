# metaporter

## Quickstart

1. Set up your development environment by following the instructions [here](https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_common/blob/main/docs/dev-env-setup.md).  

2. Clone this repository and its dependencies under `~/metaporter_dev/src`.

    ```bash
    cd ~/metaporter_dev
    ```

    ```bash
    git clone https://github.com/jehanshah8/metaporter_nano.git
    ```
3. Build the container using our convinience script
    ```bash
    bash src/metaporter_nano/scripts/docker_build.sh
    ```
4. Run the container 
    ```bash
    bash src/metaporter_nano/scripts/docker_run.sh
    ```
