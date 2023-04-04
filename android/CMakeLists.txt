cmake_minimum_required(VERSION 3.4.1)  # for example

include_directories(${CMAKE_SOURCE_DIR}/app/src/main/Classes)

add_library(
        native_add
        SHARED
        app/src/main/Classes/native_add.cpp
)


add_library(
        method_channel
        SHARED
        app/src/main/Classes/method_channel.cpp
)

find_library( # Sets the name of the path variable.
        log-lib

        # Specifies the name of the NDK library that
        # you want CMake to locate.
        log)

target_link_libraries( # Specifies the target library.
        native_add
        # Links the target library to the log library
        # included in the NDK.
        ${log-lib} jnigraphics)