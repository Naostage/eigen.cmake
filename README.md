# eigen.cmake

<p align="left">
    <a href="https://isocpp.org/">
        <img src="https://img.shields.io/badge/language-C%2B%2B17-blue.svg">
    </a>
    <a href="https://gitmoji.dev/">
        <img src="https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat-square">
    </a>
    <a href="https://github.com/Naostage/eigen.cmake/actions/workflows/unit-tests.yml">
        <img src="https://github.com/Naostage/eigen.cmake/actions/workflows/unit-tests.yml/badge.svg">
    </a>
</p>

Eigen cmake library wrapper, because official cmake is 💩

## 🔨 Build

```bash
# ⬇️ Download project from Github
git clone https://github.com/Naostage/eigen.cmake
cd eigen.cmake

# 🔧 Configure project
cmake -E make_directory build
cmake \
  -DEIGEN_ENABLE_EXAMPLES=ON `# 🚀 Enable Examples (eigen_example)` \
  -DEIGEN_ENABLE_INSTALL=ON `# 📦️ Enable Install` \
  -DEIGEN_ENABLE_FIND_PACKAGE=ON `# Enable find_package before cpm` \
  -B build -S .

# 🔨 Build:
cmake --build build --target eigen_example --config Release -j12

# 📦️ Install library (You can control installation path with -DCMAKE_INSTALL_PREFIX=mypath)
cmake --build . --target install
```

### Extra flags

* `CPM_SOURCE_CACHE`: Share CPM download with multiple build. [More info.](https://github.com/cpm-cmake/CPM.cmake#CPM_SOURCE_CACHE)
* `CPM_USE_LOCAL_PACKAGES`: Force `CPMAddPackage` to first try to `find_package`
* `EIGEN_ENABLE_FIND_PACKAGE`: Enable `find_package`  before `CPMAddPackage`. **Off By Default**
* `CMAKE_INSTALL_PREFIX`: Select where installation should happen. [More info](https://cmake.org/cmake/help/latest/variable/CMAKE_INSTALL_PREFIX.html)

### Use in your project

#### CPM

When using CPM, adding `eigen.cmake` to your project is as simple as:

```cmake
CPMAddPackage(
  NAME eigen.cmake
  GIT_REPOSITORY "https://github.com/Naostage/eigen.cmake"
  GIT_TAG "v3.4.0"
)
target_link_libraries(mytarget PRIVATE Eigen3::Eigen)
```

#### find_package

One the library is installed you can simply:

```cmake
find_package(Eigen3 REQUIRED)
target_link_libraries(mytarget PRIVATE Eigen3::Eigen)
```

Complete example can be found in [examples/install](./examples/install/CMakeLists.txt).

## 💅 Format

* [clang-format](https://github.com/llvm/llvm-project/releases/tag/llvmorg-12.0.1) : format cpp
* [cmake-format](https://github.com/cheshirekow/cmake_format) : format cmake

## 📦️ Repository overview

![repo-diagram](docs/assets/repo-diagram.svg)

## 👥 Authors

* [Olivier Le Doeuff](olivier.ledoeuff@naostage.com)
