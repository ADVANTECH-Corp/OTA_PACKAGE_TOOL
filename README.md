# OTA Package Tool

This tool can generate a OTA package for Arm Mbed.
- .tgz file (files in rootfs)

First, prepare a **update.zip** which is created by [ota-package.sh](https://raw.githubusercontent.com/ADVANTECH-Corp/meta-advantech/krogoth/meta-WISE-PaaS/recipes-ota/ota-script/files/ota-package.sh)
```
   $ ./ota-package.sh -f package.tgz
```

Please note the **package.tgz** should contain the *absolute file path* based on ROOT folder (/).
The *owner* and *permissions* should be set correctly as well.
```
package.tgz
|- user
    |- local
        |- bin
        |    |- package
        |- include
        |        |- package.h
        |- lib
             |- package.a
             |- package.la
```

Second, use ZIP command to package.
```
   $ zip ../your-ota-package-name.zip ./*.sh ./update.zip
   show:
         adding: install.sh (deflated 11%)
         adding: result.sh (deflated 14%)
         adding: update.zip (stored 0%)
```

Finally, you can upload the *your-ota-package-name.zip* file upto Mbed Cloud for OTA update.
