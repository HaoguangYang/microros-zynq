set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_CROSSCOMPILING 1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# SET HERE THE PATH TO YOUR C99 AND C++ COMPILERS
set(CMAKE_C_COMPILER /opt/Xilinx/Vitis/2020.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin/arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER /opt/Xilinx/Vitis/2020.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin/arm-none-eabi-g++)

set(CMAKE_C_COMPILER_WORKS 1 CACHE INTERNAL "")
set(CMAKE_CXX_COMPILER_WORKS 1 CACHE INTERNAL "")

# SET HERE YOUR BUILDING FLAGS
set(FLAGS "-Wall -Wextra -Os -ffunction-sections -fdata-sections -nostdlib -flto -mthumb -mcpu=cortex-a9 -mfpu=neon-vfpv3 -mfloat-abi=hard -mtune=cortex-a9 -DCLOCK_MONOTONIC=0" CACHE STRING "" FORCE)

set(CMAKE_C_FLAGS_INIT "-std=c11 ${FLAGS} -Wall -O3 -c -fmessage-length=0 -MT\"$@\"" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_INIT "-std=c++11 ${FLAGS} -Wall -O3 -c -fmessage-length=0 -MT\"$@\"" CACHE STRING "" FORCE)

set(__BIG_ENDIAN__ 0)

# NOTE:
#
# For Xilinx board running FreeRTOS, to use hard-real-time task scheduling, a
# good practice is to create timers as periodic tasks, and implement an advanced
# scheduler (if the stock Round-Robin scheduler is not enough).
#
# Use of FreeRTOS plus TCP is not a must, unless you want to utilize its TCP for
# transport. In such case, you need to set:
# "-DUCLIENT_PLATFORM_FREERTOS_PLUS_TCP=ON"
# under the colcon.meta file for the board, under the "microxrcedds_client"
# section.
