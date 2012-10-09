#!/bin/sh
IFS=$'\n'

if [ ${BUILD_ROOT} != ${SRCROOT}/Build ]; then
    rm -rf ${SRCROOT}/Build/RestKit
    cp -R ${BUILD_ROOT}/RestKit ${SRCROOT}/Build

    cd ${SRCROOT}/Build/RestKit
    find * -name '*.h' | xargs chmod a-w
fi

exit 0
