set(EIGEN_VERSION_MAJOR 1)
set(EIGEN_VERSION_MINOR 0)
set(EIGEN_VERSION_PATCH 3)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
  execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE EIGEN_VERSION_TAG
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
endif()

if(NOT EIGEN_VERSION_TAG)
  set(EIGEN_VERSION_TAG 00000000)
endif(NOT EIGEN_VERSION_TAG)
set(EIGEN_VERSION_TAG_HEX 0x${EIGEN_VERSION_TAG})
set(EIGEN_VERSION ${EIGEN_VERSION_MAJOR}.${EIGEN_VERSION_MINOR}.${EIGEN_VERSION_PATCH})
