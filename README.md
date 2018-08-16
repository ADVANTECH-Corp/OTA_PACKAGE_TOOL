# OTA Package Tool

This tool can generate a OTA package for Arm Mbed.
- zImage (kernel)
- DTB file (device tree)

First, prepare a **update.zip** which is created by [ota-package.sh](https://raw.githubusercontent.com/ADVANTECH-Corp/meta-advantech/krogoth/meta-WISE-PaaS/recipes-ota/ota-script/files/ota-package.sh)
```
   $ ./ota-package.sh -k zImage -d am335x-rsb4220a1.dtb
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
