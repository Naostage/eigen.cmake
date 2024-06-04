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

option(EIGEN_ENABLE_FIND_PACKAGE "Use find_package to look for eigen first" OFF)
option(EIGEN_ENABLE_EXAMPLES "Create an example target." ${EIGEN_MAIN_PROJECT})
option(EIGEN_ENABLE_INSTALL "Create an install target." ${EIGEN_MAIN_PROJECT})

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
  message(STATUS "EIGEN_ENABLE_FIND_PACKAGE    : ${EIGEN_ENABLE_FIND_PACKAGE}")
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
if(NOT TARGET Eigen3::Eigen AND EIGEN_ENABLE_FIND_PACKAGE)
  if(NOT _EIGEN_FIND_PACKAGE_RUNNED_ONCE)
    find_package(Eigen3 ${EIGEN_TAG} QUIET NO_MODULE)

    if(NOT Eigen3_FOUND)
      # find_package takes quite some times, let's only try once and ignore it on next run
      set(_EIGEN_FIND_PACKAGE_RUNNED_ONCE
          TRUE
          CACHE BOOL "Fake file hierarchy have been copied from downloaded sources" FORCE
      )
      mark_as_advanced(_EIGEN_FIND_PACKAGE_RUNNED_ONCE)
    endif()
  endif()
  # todo : mark advance and don't do it again
endif()

if(NOT TARGET Eigen3::Eigen)
  set(EIGEN_CAN_INSTALL TRUE)
  include(cmake/CPM.cmake)
  CPMAddPackage(
    NAME Eigen3
    GIT_REPOSITORY ${EIGEN_REPOSITORY}
    GIT_TAG ${EIGEN_TAG}
    DOWNLOAD_ONLY YES
  )
endif()

# Eigen3_ADDED is defined by CPM if the dependency has not been added before
if(Eigen3_ADDED)
  message(STATUS "Eigen3 added from source, not found with find_package")

  set(Eigen3_FOUND
      TRUE
      CACHE BOOL "eigen fetch from github" FORCE
  )

  # Copying all files can take some hundred of milliseconds, so let's only do that once.
  set(_EIGEN_FAKE_FILE_COPIED _EIGEN_FAKE_FILE_COPIED_${EIGEN_TAG})
  if(NOT ${_EIGEN_FAKE_FILE_COPIED})

    set(${_EIGEN_FAKE_FILE_COPIED}
        TRUE
        CACHE BOOL "Fake file hierarchy have been copied from downloaded sources" FORCE
    )
    mark_as_advanced(${_EIGEN_FAKE_FILE_COPIED})
    # todo mark advance, do only once
    file(GLOB_RECURSE EIGEN_SOURCES "${Eigen3_SOURCE_DIR}/Eigen/*"
         "${Eigen3_SOURCE_DIR}/unsupported/Eigen/*"
    )
    list(REMOVE_ITEM EIGEN_SOURCES "${Eigen3_SOURCE_DIR}/unsupported/Eigen/CMakeLists.txt")
    list(REMOVE_ITEM EIGEN_SOURCES
         "${Eigen3_SOURCE_DIR}/unsupported/Eigen/src/EulerAngles/CMakeLists.txt"
    )
    list(REMOVE_ITEM EIGEN_SOURCES "${Eigen3_SOURCE_DIR}/unsupported/Eigen/CXX11/CMakeLists.txt")

    # Copy all file to build folder
    foreach(eigen_source_file ${EIGEN_SOURCES})

      file(RELATIVE_PATH relative_path ${Eigen3_SOURCE_DIR} ${eigen_source_file})
      get_filename_component(file_name ${eigen_source_file} NAME)
      file(RELATIVE_PATH relative_path ${Eigen3_SOURCE_DIR} ${eigen_source_file})
      get_filename_component(dest_dir ${Eigen3_BINARY_DIR}/include/${relative_path} DIRECTORY)
      file(
        COPY ${eigen_source_file}
        DESTINATION ${dest_dir}
        FILE_PERMISSIONS OWNER_READ GROUP_READ WORLD_READ OWNER_WRITE GROUP_WRITE WORLD_WRITE OWNER_EXECUTE GROUP_EXECUTE
        DIRECTORY_PERMISSIONS OWNER_READ GROUP_READ WORLD_READ OWNER_WRITE GROUP_WRITE WORLD_WRITE OWNER_EXECUTE
                              GROUP_EXECUTE
      )

    endforeach()
  endif()

  add_library(Eigen INTERFACE)

  # ~~~
  # Not working with old version of cmake :
  # file(GLOB_RECURSE EIGEN_SOURCES "${Eigen3_BINARY_DIR}/include/Eigen/*") target_sources(eigen
  # INTERFACE ${EIGEN_SOURCES})
  # ~~~

  target_include_directories(
    Eigen INTERFACE $<BUILD_INTERFACE:${Eigen3_BINARY_DIR}/include>
                    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  )
  target_compile_definitions(Eigen INTERFACE "_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS")

  # Force opencv to use our eigen to avoid any problems
  set(EIGEN3_INCLUDE_DIR
      ${Eigen3_BINARY_DIR}/include
      CACHE STRING "eigen include dir" FORCE
  )
  set(EIGEN3_INCLUDE_DIRS
      ${Eigen3_BINARY_DIR}/include
      CACHE STRING "eigen include dir" FORCE
  )
  set(EIGEN_INCLUDE_DIR
      ${Eigen3_BINARY_DIR}/include
      CACHE STRING "eigen include dir" FORCE
  )
  set(EIGEN_INCLUDE_DIRS
      ${Eigen3_BINARY_DIR}/include
      CACHE STRING "eigen include dir" FORCE
  )

  add_library(eigen ALIAS Eigen)
  # Create a real library, and not an alias to be able to install it, and use find_package(Eigen3)
  add_library(Eigen3 INTERFACE)
  target_link_libraries(Eigen3 INTERFACE Eigen)
  # Official alias used by eigen doc
  add_library(Eigen3::Eigen ALIAS Eigen)
  add_library(Eigen::Eigen ALIAS Eigen)

  # automatically parse the version number
  file(READ "${Eigen3_SOURCE_DIR}/Eigen/src/Core/util/Macros.h" _eigen_version_header)
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
    VERSION ${EIGEN_VERSION_NUMBER}
    BINARY_DIR ${PROJECT_BINARY_DIR}
    INCLUDE_DIR ${Eigen3_BINARY_DIR}/include
    INCLUDE_DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    NAMESPACE Eigen3
    COMPATIBILITY SameMinorVersion
  )

  if(Eigen3_ADDED)
    # ~~~
    # This is a hack, because we want to be able to do
    # find_package(Eigen3) like in official documentation
    # This depends on Eigen package,
    # so in the end `Eigen3::Eigen` target will be defined
    # ~~~
    packageProject(
      NAME Eigen3
      VERSION ${EIGEN_VERSION_NUMBER}
      BINARY_DIR ${PROJECT_BINARY_DIR}
      COMPATIBILITY SameMinorVersion
      NAMESPACE Eigen3
      DEPENDENCIES "Eigen"
    )
  endif()

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
