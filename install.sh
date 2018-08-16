#!/bin/bash

PACKAGE_FILE="update.zip"
DISK_DIR="/"
CACHE_ROOT="/cache"
RECOVERY_PATH="/cache/recovery/"
INTENT_FILE="/cache/recovery/intent"
LAST_INSTALL_FILE="/cache/recovery/last_install"

UPDATE_DIR="ota-update"
UPDATE_SCRIPT="updater-script"

BOOT_LABEL="boot"
ROOTFS_LABEL="rootfs"
MISC_LABEL="misc"

# ===========
#  Functions
# ===========
printMsg()
{
    echo "[OTA] $1"
}

exitRecovery()
{
    RETURN_LOG="$1"
    NOT_CLEAN="$2"

    cd ${CACHE_ROOT}
    rm $PACKAGE_FILE
    rm -rf $UPDATE_DIR

    echo "$RETURN_LOG" > $INTENT_FILE
    printMsg "$RETURN_LOG"

    if [ -z $NOT_CLEAN ] ; then
        rm -rf $PACKAGE_FILE 
    fi

    #exit 1;
}

doUpdate()
{
    IN_FILE=$1
    OUT_FILE=$2

    printMsg "tar -xzvf ${IN_FILE} -C ${OUT_FILE}"
    tar -xzf ${IN_FILE} -C ${OUT_FILE}

    [ "$?" -ne 0 ] && exitRecovery "Err: 'tar' command failed!" true
    sync
    printMsg "Update done!"
}

updateFiles()
{
    UPDATE_FILES=`grep update-files $UPDATE_SCRIPT | cut -d ',' -f 2`
    if [ -e ${DISK_DIR} ] ; then
        doUpdate ${UPDATE_FILES} ${DISK_DIR}
        sync
    else
        exitRecovery "Err: Cannot find rootfs partition in ${DISK_DIR}"
    fi
    
}

# ===========
#    Main
# ===========

# [1] Check OTA package
printMsg "Check OTA package ..."
cd ${CACHE_ROOT}
if [ ! -e ${RECOVERY_PATH} ] ; then
    mkdir -p ${RECOVERY_PATH}
fi 

if [ ! -e ${PACKAGE_FILE} ] ; then
    exitRecovery "Err: ${PACKAGE_FILE} does not exist!"
fi

printMsg "Unzip $PACKAGE_FILE ..."
unzip -o $PACKAGE_FILE -d $CACHE_ROOT
cd ${CACHE_ROOT}/${UPDATE_DIR}
if [ ! -e ${UPDATE_SCRIPT} ] ; then
    exitRecovery "Err: ${UPDATE_SCRIPT} does not exist in ${PACKAGE_FILE}"
fi

IMAGE_LIST=`cut $UPDATE_SCRIPT -d ',' -f 2`
for IMAGE in $IMAGE_LIST ; do
    if [ ! -e $IMAGE ] ; then
        exitRecovery "Err: ${IMAGE} listed in ${UPDATE_SCRIPT} does not exist!"
    fi

    MD5_P=`grep $IMAGE $UPDATE_SCRIPT | cut -d ',' -f 3`
    MD5_Q=`md5sum -b $IMAGE | cut -d ' ' -f 1`
    if [ $MD5_P != $MD5_Q ] ; then
        exitRecovery "Err: MD5 of ${IMAGE} does not match!"
    fi
done

# [2] Update images
printMsg "Parse $UPDATE_SCRIPT in $PACKAGE_FILE ..."
OTA_CMD_LIST=`cut $UPDATE_SCRIPT -d ',' -f 1`
for OTA_CMD in $OTA_CMD_LIST ; do
    case $OTA_CMD in
    "update-files")
        updateFiles
        ;;
    *)
	printMsg "incorrect install.sh for update files ..."
        ;;
    esac
done

# [3] Finish recovery
echo $PACKAGE_FILE > $LAST_INSTALL_FILE
exitRecovery "OK"
