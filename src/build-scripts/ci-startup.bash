#!/usr/bin/env bash

# Copyright Contributors to the Open Shading Language project.
# SPDX-License-Identifier: BSD-3-Clause
# https://github.com/AcademySoftwareFoundation/OpenShadingLanguage

# This script is run when CI system first starts up.
# Since it sets many env variables needed by the caller, it should be run
# with 'source', not in a separate shell.

# Environment variables we always need
export PATH=/usr/local/bin/_ccache:/usr/lib/ccache:$PATH
export USE_CCACHE=${USE_CCACHE:=1}
export CCACHE_CPP2=
export CCACHE_DIR=$HOME/.ccache
mkdir -p $CCACHE_DIR

export OSL_ROOT=$PWD/dist
export DYLD_LIBRARY_PATH=$OSL_ROOT/lib:$DYLD_LIBRARY_PATH
export LD_LIBRARY_PATH=$OSL_ROOT/lib:$LD_LIBRARY_PATH
export OPENIMAGEIO_PLUGIN_PATH=$OSL_ROOT/lib:${OPENIMAGEIO_PLUGIN_PATH}
export OIIO_LIBRARY_PATH=$OSL_ROOT/lib:${OIIO_LIBRARY_PATH}
export LSAN_OPTIONS=suppressions=$PWD/src/build-scripts/nosanitize.txt
export ASAN_OPTIONS=print_suppressions=0:detect_odr_violation=1

export USE_PYTHON=${USE_PYTHON:=1}
export PYTHON_VERSION=${PYTHON_VERSION:="3.7"}
export PYTHONPATH=/usr/local/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PYTHONPATH=/usr/local/lib64/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export PYTHONPATH=$OSL_ROOT/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
export BUILD_MISSING_DEPS=${BUILD_MISSING_DEPS:=1}
export COMPILER=${COMPILER:=gcc}
export CC=${CC:=gcc}
export CXX=${CXX:=g++}
export OSL_CI=true
export USE_NINJA=${USE_NINJA:=1}
export CMAKE_GENERATOR=${CMAKE_GENERATOR:=Ninja}
export CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:=Release}
export CMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD:=17}

export LOCAL_DEPS_DIR=${LOCAL_DEPS_DIR:=$HOME/ext}
export CMAKE_PREFIX_PATH=${LOCAL_DEPS_DIR}/dist:${CMAKE_PREFIX_PATH}
export LD_LIBRARY_PATH=${LOCAL_DEPS_DIR}/dist/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${LOCAL_DEPS_DIR}/dist/lib64:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=${LOCAL_DEPS_DIR}/dist/lib:$DYLD_LIBRARY_PATH

export TESTSUITE_CLEANUP_ON_SUCCESS=${TESTSUITE_CLEANUP_ON_SUCCESS:=1}

# For CI, default to building missing dependencies automatically
export OpenImageIO_BUILD_MISSING_DEPS=${OpenImageIO_BUILD_MISSING_DEPS:=all}

# Sonar
export BUILD_WRAPPER_OUT_DIR="${PWD}/bw_output"
export BW_OUTPUT_DIR="${PWD}/bw_output"

# Parallel builds
if [[ `uname -s` == "Linux" ]] ; then
    echo "procs: " `nproc`
    head -40 /proc/cpuinfo
    export PARALLEL=${PARALLEL:=$((2 + `nproc`))}
elif [[ "${RUNNER_OS}" == "macOS" ]] ; then
    echo "procs: " `sysctl -n hw.ncpu`
    sysctl machdep.cpu.features
    export PARALLEL=${PARALLEL:=$((2 + `sysctl -n hw.ncpu`))}
elif [[ "${RUNNER_OS}" == "Windows" ]] ; then
    # Presumably Windows
    export PARALLEL=${PARALLEL:=$((2 + ${NUMBER_OF_PROCESSORS}))}
else
    export PARALLEL=${PARALLEL:=6}
fi
export PAR_MAKEFLAGS=-j${PARALLEL}
export CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL:=${PARALLEL}}
export CTEST_PARALLEL_LEVEL=${CTEST_PARALLEL_LEVEL:=${PARALLEL}}

mkdir -p build dist

echo "HOME = $HOME"
echo "PWD = $PWD"
echo "LOCAL_DEPS_DIR = $LOCAL_DEPS_DIR"
echo "uname -a: " `uname -a`
echo "uname -m: " `uname -m`
echo "uname -s: " `uname -s`
echo "uname -n: " `uname -n`
pwd
ls
env | sort

if [[ `uname -s` == "Linux" ]] ; then
    echo "nprocs: " `nproc`
    head -40 /proc/cpuinfo
elif [[ "${RUNNER_OS}" == "macOS" ]] ; then
    echo "nprocs: " `sysctl -n hw.ncpu`
    sysctl machdep.cpu.features
fi

# Save the env for use by other stages
src/build-scripts/save-env.bash
