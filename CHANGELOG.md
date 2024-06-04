# Changelog

<a name="1.0.4"></a>
## 1.0.4 (2024-06-04)

### Fixed

- 🐛 Correct dest_dir for &#x60;Eigen/Eigen&#x60; ([#9](https://github.com/Naostage/eigen.cmake/issues/9)) [[da55be4](https://github.com/Naostage/eigen.cmake/commit/da55be40e861ebd1702011390f86b3fcee019591)]
- 🐛 add &#x60;include&#x60; to the &#x60;EIGEN3_INCLUDE_DIR&#x60; global variable. Also add &#x60;DIRS&#x60; variant that might be used ([#8](https://github.com/Naostage/eigen.cmake/issues/8)) [[dd1584a](https://github.com/Naostage/eigen.cmake/commit/dd1584ac2da5492be156a4386cf5d6c2c7427408)]

### Miscellaneous

- 📝 Update Changelog [skip ci] ([#7](https://github.com/Naostage/eigen.cmake/issues/7)) [[488fb72](https://github.com/Naostage/eigen.cmake/commit/488fb72b3927a7a038d28179196b0f17cbcdfc45)]


<a name="1.0.3"></a>
## 1.0.3 (2024-05-06)

### Changed

- ♻️ Add world permission on Eigen copied file ([#6](https://github.com/Naostage/eigen.cmake/issues/6)) [[5a17178](https://github.com/Naostage/eigen.cmake/commit/5a1717886e189ace438f022b7d25c654f55870a6)]

### Miscellaneous

- 📝 Update Changelog [skip ci] ([#5](https://github.com/Naostage/eigen.cmake/issues/5)) [[abf25b4](https://github.com/Naostage/eigen.cmake/commit/abf25b435a57fad9ff010e42b6f9a488977cf8de)]


<a name="1.0.2"></a>
## 1.0.2 (2024-04-29)

### Changed

- 🔧 Update .gitmoji-changelogrc with correct &#x60;name&#x60; &amp; &#x60;description&#x60; [[206fa5e](https://github.com/Naostage/eigen.cmake/commit/206fa5e77d9319c0c176b09696a7e8c694d67487)]

### Fixed

- 🐛 Use correct &#x60;Eigen3&#x60; CPM name so &#x60;CPM_USE_LOCAL_PACKAGE&#x60; can find eigen ([#4](https://github.com/Naostage/eigen.cmake/issues/4)) [[1db37c1](https://github.com/Naostage/eigen.cmake/commit/1db37c1ab82fdef379f662217cd852ad8ac4fd9b)]

### Miscellaneous

-  👷 only run repo-diagram by hand [[ab34ad3](https://github.com/Naostage/eigen.cmake/commit/ab34ad302024895a0752b689af820d755756a6a5)]
- 📝 Updating repository diagram [skip ci] [[245cbb9](https://github.com/Naostage/eigen.cmake/commit/245cbb937b98ec81bf04f1fe3d9df20f927536ac)]
- 📝 Updating repository diagram [skip ci] [[0584b3d](https://github.com/Naostage/eigen.cmake/commit/0584b3d0ebce34f0d365f266a4d87d042dbdf97d)]
-  👷 Don&#x27;t index docs folder in repo-diagram [[cf31482](https://github.com/Naostage/eigen.cmake/commit/cf31482a3ad75b487a6809718814162e78a1d30b)]
- 📝 Updating repository diagram [skip ci] [[adbdb7a](https://github.com/Naostage/eigen.cmake/commit/adbdb7af62c1c8d6cb012199c18fe06444fec6cd)]
- 📝 Updating repository diagram [skip ci] [[dcf7791](https://github.com/Naostage/eigen.cmake/commit/dcf77913f4120eb7fc61b20b35210dc82b4759d8)]
- 📝 Updating repository diagram [skip ci] [[d96305c](https://github.com/Naostage/eigen.cmake/commit/d96305c55f0e0cf2bd3916c9d7f853b7f3049566)]
- 📝 Updating repository diagram [skip ci] [[98dd97e](https://github.com/Naostage/eigen.cmake/commit/98dd97e1eeb25c6aad4b955835bff67bbfe8d1ff)]
- 📝 Update Changelog [skip ci] ([#3](https://github.com/Naostage/eigen.cmake/issues/3)) [[2a73f82](https://github.com/Naostage/eigen.cmake/commit/2a73f82f2c551950ec945a1b4760f85e4a488eb8)]


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


