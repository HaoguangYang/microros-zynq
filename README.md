This repository provides extra config files for porting MicroROS to Zynq-7000 series SoC.

In general, the workspace follows steps described in: https://micro.ros.org/docs/tutorials/advanced/create_custom_static_library/

Build steps:
```sh
source /opt/ros/humble/setup.bash
mkdir src
cd src
git clone https://github.com/micro-ROS/micro_ros_setup.git
cd ..
colcon build
source ./install/setup.bash
ros2 run micro_ros_setup create_firmware_ws.sh generate_lib
ros2 run micro_ros_setup build_firmware.sh $(pwd)/xilinx_zynq_toolchain.cmake $(pwd)/xilinx_zynq_colcon.meta
```

To generate the project includes XML for Xilinx Vitis (based on Eclipse), run:
```sh
python ./generate_eclipse_include_paths_config.py
```
You can import the generated library and `eclipse_include_paths.xml` into a Vitis project:
- Right-click on the application project, then click the `Properties` item.
- Expand `C/C++ General` on the left, find `Paths and Symbols`, select `[All configurations]` under the `Configuration` drop-down.
- Under the `Includes` tab, click `Import Settings...`, and import this XML.
- Copy `firmware/build/include/` as `${workspace_loc}/${ProjName}/src/microros/` under your application project.
- Copy `firmware/build/libmicroros.a` as `${workspace_loc}/${ProjName}/src/microros/libmicroros.a`, and add it to your `Library Paths` tab under the same property page. You need to check the `is a workspace path` box, and add an entry:
    ```sh
    /${ProjName}/src/microros
    ```
- Add the library to the linking config under the `Libraries` tab: add an entry `microros`.

The agent needs to be started for the MicroROS client to run. To build the agent, perform:
```sh
ros2 run micro_ros_setup create_agent_ws.sh
ros2 run micro_ros_setup build_agent.sh
source install/local_setup.bash
```
To start the agent, perform:
```sh
ros2 run micro_ros_agent micro_ros_agent udp4 --port 8266
```

### NOTES:
1. For Xilinx board running FreeRTOS, to use hard-real-time task scheduling, a good practice is to create timers as periodic tasks, and implement an advanced scheduler (if the stock Round-Robin scheduler is not enough).

    Use of FreeRTOS plus TCP is not a must, unless you want to utilize its TCP for transport. In such case, you need to set:
    ```
    "-DUCLIENT_PLATFORM_FREERTOS_PLUS_TCP=ON"
    ```
    under the `colcon.meta` file for the board, under the `microxrcedds_client` section.

2. You may want to invoke parallel build under the `C/C++ Build` page and `Behavior` tab, however, the linker may have trouble syncing the library states, causing the linking step to fail. This is a known bug of Vitis (https://support.xilinx.com/s/article/000034054?language=en_US). To work around this, navigate to `C/C++ General`/`Paths and Symbols` page, and go to the `Libraries` tab. Remove all `-Wl,--start-group,...,--end-group` entries, and re-enter the libraries one-by-one:
    ```
    xil
    gcc
    c
    xilffs
    rsa
    ```
    If you are building with `math.h`, add an entry `m`.

3. You can add a second (Neon) FPU support with Cortex A9. The option is under `C/C++ Build`/`Settings` page. Navigate to `Tool Settings` tab and under `Arm v7 gcc compiler`/`Miscellaneous` page. Find `-mfpu=vfpv3` in the text box, and change it to `-mfpu=neon-vfpv3`.
