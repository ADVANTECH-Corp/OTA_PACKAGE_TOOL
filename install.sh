#!/bin/bash
CACHE_ROOT="/cache"

cd ${CACHE_ROOT}
/tools/do_update_mbed.sh ./update.zip

exit 0;