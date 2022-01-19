require_new_magisk() {
  echo
  echo "$string_MagiskNotSupport"
  echo
  echo "$string_NeedNewMagisk"
  echo
  exit 1
}

rm -rf $TEMP_DIR/*
[ -f /data/adb/magisk/util_functions.sh ] || require_new_magisk
. /data/adb/magisk/util_functions.sh
[ $MAGISK_VER_CODE -gt 20000 ] || require_new_magisk
MODULEROOT=/data/adb/modules_update
MODPATH=/data/adb/modules_update/antimithemerestore
rm -rf $MODPATH 2>/dev/null

echo "id=antimithemerestore
name=${string_antimodulename}
author=@PedroZ
description=${string_antimoduledescription}
version=1.0
versionCode=1" >> $TEMP_DIR/module.prop

echo "#!/system/bin/sh
chmod 731 /data/system/theme
rm -rf /data/system/package_cache/*" >> $TEMP_DIR/service.sh

echo "#!/system/bin/sh
rm -rf /data/system/package_cache/*
chmod 775 /data/system/theme
rm -rf /data/system/theme/rights" >> $TEMP_DIR/uninstall.sh

  mkdir -p $MODPATH
  set_perm_recursive $MODPATH 0 0 0755 0644
  cp -af $TEMP_DIR/module.prop /data/adb/modules_update/antimithemerestore/module.prop
  cp -af $TEMP_DIR/service.sh /data/adb/modules_update/antimithemerestore/service.sh
  cp -af $TEMP_DIR/uninstall.sh /data/adb/modules_update/antimithemerestore/uninstall.sh
  cp -af $TEMP_DIR/module.prop /data/adb/modules/antimithemerestore/module.prop
  mktouch /data/adb/modules/antimithemerestore/update
  rm -rf \
  $MODPATH/system/placeholder $MODPATH/customize.sh \
  $MODPATH/README.md $MODPATH/.git* 2>/dev/null
  cd /
  rm -rf $TEMP_DIR/*
  echo "${string_installsuccess}"
  echo "---------------------------------------------"
  exit 0