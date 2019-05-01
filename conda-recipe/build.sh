if [ $(uname) == 'Darwin' ]; then
    CC=/usr/bin/cc
    CXX=/usr/bin/clang
else
    # conda is providing gcc and defining $CC,
    # but the binary isn't named 'gcc'.
    # Create a symlink for build scripts that expect that name.
    cd $(dirname ${CC}) && ln -s $(basename ${CC}) gcc && cd -
    cd $(dirname ${CXX}) && ln -s $(basename ${CXX}) g++ && cd -
    cd $(dirname ${LD}) && ln -s $(basename ${LD}) ld && cd -
    additional_qflag='LIBS+=-Wl,-rpath-link,/usr/lib64 LIBS+=-Wl,-rpath-link,/lib64 LIBS+=-L/usr/lib64 INCLUDEPATH+=/usr/include'
fi

if [ $(uname) == 'Darwin' ]; then
    QMAKE_SPEC_PATH=${PREFIX}/mkspecs/macx-clang
else
    QMAKE_SPEC_PATH=${PREFIX}/mkspecs/linux-g++-64
fi

app_name=qwebenginetest

echo "Build flag: $build_flag"
bash -x -e build.sh ${PREFIX}/bin/qmake ${QMAKE_SPEC_PATH} -q "$additional_qflag"

build_dir=build
# Install to conda environment
if [ $(uname) == 'Darwin' ]; then
    mv ${build_dir}/${app_name}.app ${PREFIX}/bin/
else
    mv ${build_dir}/${app_name} ${PREFIX}/bin/
fi
