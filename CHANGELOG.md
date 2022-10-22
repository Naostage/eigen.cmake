# Changelog

<a name="1.0.1"></a>
## 1.0.1 (2022-10-22)

### Changed

- ♻️ use option instead of set in cache for boolean options https://github.com/cpm-cmake/CPM.cmake/issues/290 [[20d6909](https://github.com/Naostage/eigen.cmake/commit/20d69093e327ce621b705d7d0cc2f811c5a3247f)]

### Miscellaneous

- 📝 Update Changelog [skip ci] ([#1](https://github.com/Naostage/eigen.cmake/issues/1)) [[112f213](https://github.com/Naostage/eigen.cmake/commit/112f2134e7d26d99445d603a17163284d44e6bb9)]
- 📝 Updating repository diagram [skip ci] [[8c1a3c5](https://github.com/Naostage/eigen.cmake/commit/8c1a3c519acab51d413673af7de848b1a7673c93)]


<a name="1.0.0"></a>
## 1.0.0 (2022-10-22)

### Added

- ✨ EIGEN_ENABLE_FIND_PACKAGE (OFF by default). Turn it on to be compatible with opencv. Or turn on &#x60;CPM_USE_LOCAL_PACKAGES&#x60; [[a3f507f](https://github.com/Naostage/eigen.cmake/commit/a3f507f914ce1511485ebde8692330bbd3d8b92a)]

### Changed

- ⚡ Only find eigen3 once, not on next run if fail, to make it faster [[4c30a8f](https://github.com/Naostage/eigen.cmake/commit/4c30a8f18464b042a39b9c0323d701b80aa848dc)]
- ⚡ Only copy eigen sources once, so that subsequence configure are way faster [[79fe6e2](https://github.com/Naostage/eigen.cmake/commit/79fe6e29075b5d5848379a04e8c65213d32e095a)]

### Removed

- 🔇 find eigen3 package QUIET to avoid warning [[953936f](https://github.com/Naostage/eigen.cmake/commit/953936f5568bea0b65f1a5c18a1a1039f6b68434)]

### Fixed

- 🐛 add real eigen version to installed library [[aa812a0](https://github.com/Naostage/eigen.cmake/commit/aa812a0e68b531b88be8aa6d6280d11968a02853)]

### Miscellaneous

- 📝 fix readme with cmake variable [[83a819e](https://github.com/Naostage/eigen.cmake/commit/83a819eb621602d762b407e41bd510c68c0abfc7)]
-  👷 basic ci for install [[2c35417](https://github.com/Naostage/eigen.cmake/commit/2c35417272717497c9064edd8018d65be8f0d35d)]
- 🌱 basic project (no ci, slow), wrap eigen, kinda [[f7eb134](https://github.com/Naostage/eigen.cmake/commit/f7eb134f55b63ff0bc68b63385f3eecaedb8def3)]


