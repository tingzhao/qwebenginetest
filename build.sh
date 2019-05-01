#!/bin/bash

#Example:
#sh build.sh /Users/zhaot/local/lib/Trolltech/Qt-4.8.5/bin/qmake /Users/zhaot/local/lib/Trolltech/Qt-4.8.5/mkspecs/macx-g++

echo "Build args: $*"
config_options="debug|force_debug_info|release|sanitize"

if [ $# -lt 1 ]
then
  echo "Usage: sh build.sh <qmake_path> <qmake_spec_path> [-d cxx_define] [-e edition] [-c $config_options]"
  echo "Usage: sh build.sh <qt_dir> [-d cxx_define] [-e edition] [-c $config_options]"
  echo "Example: "
  echo 'sh build.sh $HOME/local/lib/Trolltech/Qt-4.8.5/bin/qmake $HOME/local/lib/Trolltech/Qt-4.8.5/mkspecs/macx-g++'
  exit 1
fi

echo $1 |grep '/qmake$'

if [ $? -eq 0 ]
then
  QMAKE=$1
  shift
  if [ $# -lt 1 ]
  then
    echo "Usage: sh build.sh <qmake_path> <qmake_spec_path> [-d cxx_define] [-e edition] [-c $config_options] [-q qmake_flags] [-m make_flags]"
    exit 1
  fi
  QMAKE_SPEC=$1
  shift
else
  QMAKE=$1/bin/qmake
  if [ `uname` = 'Darwin' ]; then
    if [ -n "$edition" ]
    then
      if [ $edition = "flyem" ] || [ $edition = "neu3" ]
      then
        QMAKE_SPEC=$1/mkspecs/macx-clang
      else
        QMAKE_SPEC=$1/mkspecs/macx-g++
      fi
    else
      QMAKE_SPEC=$1/mkspecs/macx-g++
    fi
  else
    QMAKE_SPEC=$1/mkspecs/linux-g++
  fi
  shift
fi

echo $QMAKE
echo $QMAKE_SPEC

set -e

debug_config=release
make_args='-j3'
while getopts d:e:c:q:m: option
do
  echo $option
  echo $OPTARG
  case $option in
    d)
      cxx_define=$OPTARG;;
    e)
      edition=$OPTARG;;
    c)
      debug_config=$OPTARG;;
    q)
      ext_qmake_args=$OPTARG;;
    m)
      make_args=$OPTARG;;
  esac
done


if [ ! -z "$QMAKE_SPEC" ]
then
  qmake_args="-spec $QMAKE_SPEC"
fi

if [ ! -z "$CONDA_ENV" ]
then
  qmake_args="$qmake_args 'CONDA_ENV=${CONDA_ENV}'"
fi

qmake_args="$qmake_args CONFIG+=$debug_config CONFIG+=x86_64 -o Makefile ../main.pro"

if [ -n "$PKG_VERSION" ]
then
  qmake_args="$qmake_args DEFINES+=_PKG_VERSION=\"$PKG_VERSION\""
fi

if [ -n "$ext_qmake_args" ]
then
  ext_qmake_args=`echo "$ext_qmake_args" | sed -e 's/^"//' -e 's/"$//'`
  echo $ext_qmake_args
  qmake_args="$qmake_args $ext_qmake_args"
fi

build_dir=build
if [ ! -d $build_dir ]
then
  mkdir $build_dir
fi

cd $build_dir
echo "qmake_args: $qmake_args"
echo $qmake_args > source.qmake
echo $qmake_args | xargs $QMAKE
echo "qmake done"


THREAD_COUNT=${CPU_COUNT:-3}  # conda-build provides CPU_COUNT
make -j${THREAD_COUNT}

