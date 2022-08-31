install() {
    echo "${string_installing}$theme_name..."
    cd theme_files/miui
    zip -r $TEMP_DIR/icons.zip * -x './res/drawable-xxhdpi/.git/*' >/dev/null
    cd ../..
    toybox tar -xf "$file" -C "$TEMP_DIR/" >&2
    mkdir -p $TEMP_DIR/res/drawable-xxhdpi
    mv  $TEMP_DIR/icons/* $TEMP_DIR/res/drawable-xxhdpi 2>/dev/null
    rm -rf $TEMP_DIR/icons
    cd $TEMP_DIR
    zip -r $TEMP_DIR/icons.zip ./layer_animating_icons >/dev/null
    zip -r $TEMP_DIR/icons.zip ./res >/dev/null
    rm -rf $TEMP_DIR/res
    rm -rf $TEMP_DIR/layer_animating_icons
    cd $START_DIR
    [ $addon == 1 ] && addon
    if [ $ANDROID_SDK -lt 33 ] ;then
    mediapath=system
    else
    mediapath=system/product
    fi
    mkdir -p $FAKEMODPATH/$mediapath/media/theme/default/
    cp -rf $TEMP_DIR/icons.zip $FAKEMODPATH/$mediapath/media/theme/default/icons
    mktouch $FAKEMODPATH/$mediapath/media/theme/miui_mod_icons/.replace
    [ $addon == 1 ] && cp -rf $addon_path/${string_advancedaddons}/* $FAKEMODPATH/$mediapath/media/theme/default 2>/dev/null
    cp $TEMP_DIR/module.prop $FAKEMODPATH/module.prop
}

getfiles() {
file=$TEMP_DIR/$var_theme.tar.xz
if [ -f "theme_files/${var_theme}.tar.xz" ]; then
source theme_files/${var_theme}.ini
old_ver=$theme_version
curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.ini?version=latest"
source $TEMP_DIR/${var_theme}.ini
new_ver=$theme_version
if [ $new_ver -ne $old_ver ] ;then 
echo "${string_newverdown_1}${theme_name}${string_newverdown_2}"
download
else
echo "${string_vernoneedtodown_1}${theme_name}${string_vernoneedtodown_2}"
cp -rf theme_files/${var_theme}.ini $TEMP_DIR/${var_theme}.ini
cp -rf theme_files/${var_theme}.tar.xz $TEMP_DIR/${var_theme}.tar.xz
fi
else download
fi
echo "$var_theme=$theme_version" >> $TEMP_DIR/module.prop
}

download() {
curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.ini?version=latest"
    mkdir theme_files 2>/dev/null
    source $TEMP_DIR/${var_theme}.ini
    cp -rf $TEMP_DIR/${var_theme}.ini theme_files/${var_theme}.ini
    if [ $file_size -gt 5242880 ] ;then
    downloadUrl=${link_miui}/${var_theme}.tar.xz
    downloader "$downloadUrl" $md5
    [ $var_theme == iconsrepo ] || cp $downloader_result theme_files/${var_theme}.tar.xz
    mv $downloader_result $TEMP_DIR/$var_theme.tar.xz
    else
      echo "${string_needtodownloadname_1}${theme_name}${string_needtodownloadname_2}"
      [ $file_size ] || { echo ${string_cannotdownload} && rm -rf $TEMP_DIR/* 2>/dev/null&& exit 1; }
      echo "${string_needtodownloadsize_1}$(printf '%.1f' `echo "scale=1;$file_size/1048576"|bc`)${string_needtodownloadsize_2}"
      curl -skLJo "$TEMP_DIR/${var_theme}.tar.xz" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.tar.xz?version=latest"
      [ $var_theme == iconsrepo ] || cp "$TEMP_DIR/${var_theme}.tar.xz" "theme_files/${var_theme}.tar.xz"
    md5_loacl=`md5sum $TEMP_DIR/${var_theme}.tar.xz|cut -d ' ' -f1`
    if [[ "$md5" = "$md5_loacl" ]]; then
      echo $string_downloadsuccess
    else
      echo ${string_downloaderror}
    rm -rf $TEMP_DIR/* >/dev/null
    exit 1
    fi
    fi
}
addon(){
    addon_path=$SDCARD_PATH/Documents/${string_addonfolder}
    if [ -d "$addon_path" ];then
    echo "${string_importaddonicons}"
    mkdir -p $TEMP_DIR/res/drawable-xxhdpi/
    mkdir -p $TEMP_DIR/layer_animating_icons
    cp -rf $addon_path/${string_animatingicons}/* $TEMP_DIR/layer_animating_icons/ 2>/dev/null
    cp -rf $addon_path/${string_staticicons}/* $TEMP_DIR/res/drawable-xxhdpi/ 2>/dev/null
    cd $TEMP_DIR
    zip -r icons.zip res >/dev/null
    zip -r icons.zip layer_animating_icons >/dev/null
    cd ..
    fi
}

patch(){
  cd $TEMP_DIR
    toybox tar -xf "$file" -C "$TEMP_DIR/" >&2
    mkdir -p res/drawable-xxhdpi
    mv icons/* res/drawable-xxhdpi 2>/dev/null
    rm icons
    zip -d icons.zip "layer_animating_icons/*" >/dev/null
    zip -r icons.zip layer_animating_icons >/dev/null
    zip -r icons.zip res >/dev/null
    rm -rf res
    rm -rf layer_animating_icons
}

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
MODPATH=/data/adb/modules_update/MIUIiconsplus
rm -rf $MODPATH 2>/dev/null
var_version="`getprop ro.build.version.release`"
var_miui_version="`getprop ro.miui.ui.version.code`"
source theme_files/theme_config
source theme_files/addon_config
FAKEMODPATH=$TEMP_DIR/modpath
source $START_DIR/local-scripts/misc/downloader.sh
  if [ $var_version -lt 10 ]; then 
    echo "$string_SysVerNotSupport"
    rm -rf $TEMP_DIR/*
    exit 1
  elif [ $var_miui_version -ge 10 ]; then
  echo "$string_startinstallation"
  fi
  curl -skLJo "$TEMP_DIR/link.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/link.ini?version=latest"
  source $TEMP_DIR/link.ini
    if [ "$http_code" != null ];then
    if [ ! "$httpcode" =~ $http_code ]; then
    {  echo "${string_nonetworkdetected}" && rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
    fi
  else
    {  echo "${string_nonetworkdetected}" && rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
  fi
  echo ""
  var_theme=iconsrepo
  if [[ -d theme_files/miui/res/drawable-xxhdpi/.git ]]; then
    source theme_files/${var_theme}.ini
    old_ver=$theme_version
    curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.ini?version=latest"
    source $TEMP_DIR/${var_theme}.ini
    new_ver=$theme_version
    if [ $new_ver -ne $old_ver ] ;then 
    echo "${string_newverdown_1}${theme_name}${string_newverdown_2}"
        echo "${string_gitpull}"
        cd theme_files/miui/res/drawable-xxhdpi
        export LD_LIBRARY_PATH=${START_DIR}/script/toolkit/so: $LD_LIBRARY_PATH
        git pull --rebase >/dev/null
        cp -rf $TEMP_DIR/${var_theme}.ini ${START_DIR}/theme_files/${var_theme}.ini
    cd ../../../..
    else
    echo "${string_vernoneedtodown_1}${theme_name}${string_vernoneedtodown_2}"
    fi
    echo "$var_theme=$theme_version" >> $TEMP_DIR/module.prop
  else
    getfiles
    echo "${string_extracting}${theme_name}..."
    toybox tar -xf "$TEMP_DIR/iconsrepo.tar.xz" -C "$TEMP_DIR/" >&2
    mv $TEMP_DIR/icons $TEMP_DIR/icons.zip
    unzip $TEMP_DIR/icons.zip -d theme_files/miui >/dev/null
    rm -rf $TEMP_DIR/icons.zip
    rm -rf $TEMP_DIR/iconsrepo.tar.xz
  fi
  var_theme=$sel_theme
  getfiles
  echo "id=MIUIiconsplus
name=MIUI ${string_projectname}
author=@PedroZ
description=${string_moduledescription_1}${theme_name}${string_moduledescription_2}
version=$(TZ=$(getprop persist.sys.timezone) date '+%Y%m%d%H%M')
theme=$theme_name
themeid=$var_theme" >> $TEMP_DIR/module.prop
  install
  mkdir -p $MODPATH
  cp -rf $FAKEMODPATH/. $MODPATH
  set_perm_recursive $MODPATH 0 0 0755 0644
  mktouch /data/adb/modules/MIUIiconsplus/update
  cp -af $MODPATH/module.prop /data/adb/modules/MIUIiconsplus/module.prop
  rm -rf \
  $MODPATH/system/placeholder $MODPATH/customize.sh \
  $MODPATH/README.md $MODPATH/.git* 2>/dev/null
  cd /
  rm -rf $TEMP_DIR/*
  settings put global is_default_icon 0
  echo ""
  echo "${string_installsuccess}"
  echo "---------------------------------------------"
  exit 0
