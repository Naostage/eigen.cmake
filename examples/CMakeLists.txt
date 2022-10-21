# ~~~
# Copyright (C) Naostage - All Rights Reserved
# This work is licensed under the terms of the MIT license.
# For a copy, see <https://opensource.org/licenses/MIT>.
# ~~~

set(EIGEN_EXAMPLE_TARGET eigen_example)
message(STATUS "🚀 Add Example: ${EIGEN_EXAMPLE_TARGET}")
add_executable(${EIGEN_EXAMPLE_TARGET} EXCLUDE_FROM_ALL eigen_example.cpp)
target_link_libraries(${EIGEN_EXAMPLE_TARGET} PRIVATE eigen)
