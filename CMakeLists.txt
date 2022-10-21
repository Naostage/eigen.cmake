# ~~~
# Copyright (C) Naostage - All Rights Reserved
# This work is licensed under the terms of the MIT license.
# For a copy, see <https://opensource.org/licenses/MIT>.
# ~~~

cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

# ──── Include guards ────

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR "In-source builds not allowed. "
                "Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

# ──── Main Project behavior ────

set(EIGEN_MAIN_PROJECT OFF)
if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  set(EIGEN_MAIN_PROJECT ON)
endif()

# ──── Default build to Release ────

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE
      "Release"
      CACHE STRING "Choose Release or Debug" FORCE
  )
endif()

# ───── 🔧 Configuration ─────

set(EIGEN_PROJECT
    "eigen.cmake"
    CACHE STRING "Project Name"
)

set(EIGEN_VERBOSE
    ${EIGEN_MAIN_PROJECT}
    CACHE BOOL "Log Verbose configuration"
)

set(EIGEN_ENABLE_EXAMPLES
    ${EIGEN_MAIN_PROJECT}
    CACHE BOOL "Create an example target."
)

set(EIGEN_ENABLE_INSTALL
    ${EIGEN_MAIN_PROJECT}
    CACHE BOOL "Create an install target."
)

# ───── 🚀 Project ─────

include(cmake/Version.cmake)

project(
  ${EIGEN_PROJECT}
  VERSION ${EIGEN_VERSION}
  LANGUAGES CXX
)

# ───── 🔊 Log config ─────

if(EIGEN_VERBOSE)
  message(STATUS "------ ${EIGEN_TARGET} Configuration ------")
  message(STATUS "EIGEN_BUILD_SHARED           : ${EIGEN_BUILD_SHARED}")
  message(STATUS "EIGEN_VERSION                : ${EIGEN_VERSION}")
  message(STATUS "EIGEN_VERSION_TAG_HEX        : ${EIGEN_VERSION_TAG_HEX}")
  message(STATUS "EIGEN_ENABLE_EXAMPLES        : ${EIGEN_ENABLE_EXAMPLES}")
  message(STATUS "EIGEN_ENABLE_INSTALL         : ${EIGEN_ENABLE_INSTALL}")
  message(STATUS "------ ${EIGEN_TARGET} End Configuration ------")
endif()

# ───── Add dependencies ─────

if(${EIGEN_ENABLE_INSTALL})
  include(GNUInstallDirs) # For CMAKE_INSTALL_INCLUDEDIR
endif()

# ───── Eigen3::Eigen ─────

set(EIGEN_REPOSITORY
    "https://gitlab.com/libeigen/eigen"
    CACHE STRING "Repository of eigen"
)
set(EIGEN_TAG
    "3.4.0"
    CACHE STRING "Git tag/branch of eigen"
)

# First try to find eigen to be compatible with opencv finding it
if(NOT TARGET Eigen3::Eigen)
  find_package(Eigen3 QUIET)
  message(STATUS "Eigen3_FOUND ${EIGEN_INCLUDE_DIR}")
  # todo : mark advance and don't do it again
endif()

if(NOT TARGET Eigen3::Eigen)
  set(EIGEN_CAN_INSTALL TRUE)
  include(cmake/CPM.cmake)
  CPMAddPackage(
    NAME eigen
    GIT_REPOSITORY ${EIGEN_REPOSITORY}
    GIT_TAG ${EIGEN_TAG}
    DOWNLOAD_ONLY YES
  )

  set(Eigen3_FOUND
      TRUE
      CACHE BOOL "eigen fetch from github" FORCE
  )

  # todo mark advance, do only once
  file(GLOB_RECURSE EIGEN_SOURCES "${eigen_SOURCE_DIR}/Eigen/*"
       "${eigen_SOURCE_DIR}/unsupported/Eigen/*"
  )
  list(REMOVE_ITEM EIGEN_SOURCES "${eigen_SOURCE_DIR}/unsupported/Eigen/CMakeLists.txt")
  list(REMOVE_ITEM EIGEN_SOURCES
       "${eigen_SOURCE_DIR}/unsupported/Eigen/src/EulerAngles/CMakeLists.txt"
  )
  list(REMOVE_ITEM EIGEN_SOURCES "${eigen_SOURCE_DIR}/unsupported/Eigen/CXX11/CMakeLists.txt")

  # Copy all file to build folder
  foreach(eigen_source_file ${EIGEN_SOURCES})

    file(RELATIVE_PATH relative_path ${eigen_SOURCE_DIR} ${eigen_source_file})
    get_filename_component(file_name ${eigen_source_file} NAME)
    string(REPLACE ${file_name} "" relative_dir ${relative_path})
    file(
      COPY ${eigen_source_file}
      DESTINATION ${eigen_BINARY_DIR}/include/${relative_dir}
      FILE_PERMISSIONS OWNER_READ GROUP_READ OWNER_WRITE GROUP_WRITE OWNER_EXECUTE GROUP_EXECUTE
      DIRECTORY_PERMISSIONS OWNER_READ GROUP_READ OWNER_WRITE GROUP_WRITE OWNER_EXECUTE
                            GROUP_EXECUTE
    )

  endforeach()

  file(GLOB_RECURSE EIGEN_SOURCES "${eigen_BINARY_DIR}/include/Eigen/*")

  add_library(Eigen INTERFACE)

  # target_sources(eigen INTERFACE ${EIGEN_SOURCES}) # Not working with old version of cmake

  target_include_directories(
    Eigen INTERFACE $<BUILD_INTERFACE:${eigen_BINARY_DIR}/include>
                    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  )
  target_compile_definitions(Eigen INTERFACE "_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS")

  # Force opencv to use our eigen to avoid any problems
  set(EIGEN3_INCLUDE_DIR
      ${eigen_BINARY_DIR}
      CACHE STRING "eigen include dir"
  )
  set(EIGEN_INCLUDE_DIR
      ${eigen_BINARY_DIR}
      CACHE STRING "eigen include dir"
  )

  add_library(eigen ALIAS Eigen)
  add_library(Eigen3 INTERFACE)
  target_link_libraries(Eigen3 INTERFACE Eigen)
  # Official alias used by eigen doc
  add_library(Eigen3::Eigen ALIAS Eigen)
  add_library(Eigen::Eigen ALIAS Eigen)

  # automatically parse the version number
  file(READ "${eigen_SOURCE_DIR}/Eigen/src/Core/util/Macros.h" _eigen_version_header)
  string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen_world_version_match
               "${_eigen_version_header}"
  )
  set(EIGEN_WORLD_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen_major_version_match
               "${_eigen_version_header}"
  )
  set(EIGEN_MAJOR_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen_minor_version_match
               "${_eigen_version_header}"
  )
  set(EIGEN_MINOR_VERSION "${CMAKE_MATCH_1}")
  set(EIGEN_VERSION_NUMBER ${EIGEN_WORLD_VERSION}.${EIGEN_MAJOR_VERSION}.${EIGEN_MINOR_VERSION})

  set(EIGEN_VERSION_NUMBER
      ${EIGEN_VERSION_NUMBER}
      CACHE STRING "Eigen Version"
  )
  set(EIGEN_WORLD_VERSION
      ${EIGEN_WORLD_VERSION}
      CACHE STRING "Eigen Version World"
  )
  set(EIGEN_MAJOR_VERSION
      ${EIGEN_MAJOR_VERSION}
      CACHE STRING "Eigen Version Major"
  )
  set(EIGEN_MINOR_VERSION
      ${EIGEN_MINOR_VERSION}
      CACHE STRING "Eigen Version Minor"
  )

endif()

# ───── Add 🚀 Samples ─────

if(EIGEN_ENABLE_EXAMPLES)
  add_subdirectory(examples)
endif()

# ───── 📦️ Package Project ─────

if(EIGEN_ENABLE_INSTALL AND EIGEN_CAN_INSTALL)

  CPMAddPackage("gh:OlivierLDff/PackageProject.cmake@1.10.0")

  packageProject(
    NAME Eigen
    VERSION ${PROJECT_VERSION}
    BINARY_DIR ${PROJECT_BINARY_DIR}
    INCLUDE_DIR ${eigen_BINARY_DIR}/include
    INCLUDE_DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    NAMESPACE Eigen3
    COMPATIBILITY SameMinorVersion
  )

  packageProject(
    NAME Eigen3
    VERSION ${PROJECT_VERSION}
    BINARY_DIR ${PROJECT_BINARY_DIR}
    COMPATIBILITY SameMinorVersion
    NAMESPACE Eigen3
    DEPENDENCIES "Eigen"
  )

endif()

# ───── 🔊 Log dev command and info ─────

if(EIGEN_MAIN_PROJECT)

  message(STATUS "")
  message(STATUS "🎉 ${CMAKE_PROJECT_NAME} v${${CMAKE_PROJECT_NAME}_VERSION} Configuration Done 🎉")
  message(STATUS "")

  if(EIGEN_ENABLE_TESTS)
    message(STATUS "")
    message(STATUS "🚀 Samples Commands:")
  endif()

  if(TARGET eigen_example)
    message(
      STATUS
        "  eigen_example       : cmake --build . --target eigen_example --config ${CMAKE_BUILD_TYPE} ${PARALLEL_LEVEL}"
    )
  endif()

  if(EIGEN_ENABLE_INSTALL AND EIGEN_CAN_INSTALL)
    message(STATUS "")
    message(
      STATUS
        "📦️ Install            : cmake --build . --target install --config ${CMAKE_BUILD_TYPE} "
    )
  endif()

  message(STATUS "")

endif()
