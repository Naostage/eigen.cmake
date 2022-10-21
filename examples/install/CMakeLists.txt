# ~~~
# Copyright (C) Naostage - All Rights Reserved
# This work is licensed under the terms of the MIT license.
# For a copy, see <https://opensource.org/licenses/MIT>.
# ~~~

cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)
project(eigen_example LANGUAGES CXX)
find_package(Eigen3 REQUIRED NO_MODULE)
add_executable(eigen_example ${CMAKE_CURRENT_SOURCE_DIR}/../eigen_example.cpp)
target_link_libraries(eigen_example PRIVATE Eigen3::Eigen)
