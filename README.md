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
- Right-click on the application project --> `Properties`
- Expand `C/C++ General` on the left, find `Paths and Symbols`, select `[All configurations]` under the `Configuration` drop-down.
- under the `Includes` tab, click `Import Settings...`, and import this XML.
- Copy `firmware/build/include/` as `${workspace_loc}/${ProjName}/src/microros/` under your application project.
- Copy `firmware/build/libmicroros.a` as `${workspace_loc}/${ProjName}/src/microros/libmicroros.a`, and add it to your "Libraries" tab under the same property page.
