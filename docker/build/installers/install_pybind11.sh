#!/usr/bin/env bash

###############################################################################
# Copyright 2020 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

# Fail on first error.
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

# shellcheck source=./installer_base.sh
. ./installer_base.sh

# Option 1: Install via apt
# apt_get_update_and_install \
#    pybind11-dev

# Option 2:
pip3_install pytest

VERSION="2.5.0"
PKG_NAME="pybind11-${VERSION}.tar.gz"
CHECKSUM="97504db65640570f32d3fdf701c25a340c8643037c3b69aec469c10c93dc8504"
DOWNLOAD_LINK="https://github.com/pybind/pybind11/archive/v${VERSION}.tar.gz"

download_if_not_cached "${PKG_NAME}" "${CHECKSUM}" "${DOWNLOAD_LINK}"

tar xzf "${PKG_NAME}"

pushd "pybind11-${VERSION}" >/dev/null
    mkdir build && cd build
    # -DDOWNLOAD_CATCH=1
    # -DBUILD_SHARED_LIBS=ON
    cmake .. \
        -DCMAKE_INSTALL_PREFIX="${SYSROOT_DIR}" \
        -DCMAKE_BUILD_TYPE=Release
    cmake --build . --config Release \
        -j "$(nproc)" \
        --target install # check
    make install
popd

# clean up
rm -rf "${PKG_NAME}" "pybind11-${VERSION}"
