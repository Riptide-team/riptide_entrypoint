# Riptide Entrypoint

This repository is the entrypoint for the riptide. It gives all informations to compile and install repositories for riptide simulation or for an hardware mission.

## Repositories

Riptide repositories are split into sub-repositories, and according to their purpose can be used or not.

### Common repositories

| Repository            | Description                                    |
|----------------------:|:-----------------------------------------------|
| `riptide_controllers` | ROS2 control controllers                       |
| `riptide_msgs`        | ROS2 riptide's messages                        |
| `riptide_navigation`  | ROS2 high level controllers and state machines |

### Simulator specific repositories

| Repository                | Description                                       |
|--------------------------:|:--------------------------------------------------|
| `riptide_simulator`       | ROS2 riptide's simulator                          |
| `riptide_bringup_sim`     | ROS2 riptide's simulator launch files             |
| `riptide_description_sim` | ROS2 URDF riptide's description for the simulator |
| `riptide_hardware_sim`    | ROS2 control simulated hardware interfaces        |

### Hardware specific repositories

| Repository            | Description                      |
|----------------------:|:---------------------------------|
| `riptide_bringup`     | ROS2 riptide's launch files      |
| `riptide_description` | ROS2 URDF riptide's description  |
| `riptide_hardware`    | ROS2 control hardware interfaces |

## Docker compilation

### Local compilation

To build the docker image which have to compile the code, run the following command

```bash
docker build -t <image_name> .
```

`<image_name>` could be for instance `riptide_simulator` or `riptide_hardware` depending on which software stack is compiled.

### Hardware cross compilation

Docker containers let us cross-compile for the target (here `linux/arm64` for the riptide's Raspberry Pi 4). To cross-compile the code on another host and to send compiled program to the `riptide`, first ensure that you have docker buildx installed (This comes pre-packaged with Docker Engine 20+ in some distributions, but you may have to [install it manually](https://docs.docker.com/build/#manual-download)).

Then create a new `builder` for buildx that has the docker-container driver and supports the target arch (`linux/arm64`). For example, if you are building on an `x86` host, you would do the following:

```bash
docker buildx create --use --platform=linux/arm64,linux/amd64 --name emulated-multiarch --driver docker-container
```

Then setup QEMU in a docker to emulate the target architecture using the following command

```bash
docker run --privileged multiarch/qemu-user-static:latest --reset -p yes
```

And then launch the build, with required target specification and output compressed fs containing compiled executables

```bash
docker buildx build --output type=tar,dest=out.tar . --platform=linux/arm64
```
