install() {
    echo "- 正在安装$theme_name..."
    tar -xf "$TEMP_DIR/icons.tar.xz" -C "$TEMP_DIR/" >&2
    mv $TEMP_DIR/icons $TEMP_DIR/icons.zip
    cd $TEMP_DIR
    tar -xf "$file" -C "$TEMP_DIR/" >&2
    mkdir -p ./res/drawable-xxhdpi
    mv  icons/* ./res/drawable-xxhdpi 2>/dev/null
    rm -rf icons
    zip -r icons.zip ./layer_animating_icons >/dev/null
    zip -r icons.zip ./res >/dev/null
    rm -rf res
    rm -rf layer_animating_icons
    cd ..
    [ $addon == 1 ] && addon
    mkdir -p $FAKEMODPATH/system/media/theme/default/
    cp -rf $TEMP_DIR/icons.zip $FAKEMODPATH/system/media/theme/default/icons
    [ $addon == 1 ] && cp -rf $addon_path/高级附加/* $FAKEMODPATH/system/media/theme/default 2>/dev/null
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
echo "- ${theme_name}有新版本，即将开始下载..."
download
else
echo "- ${theme_name}没有更新，无需下载..."
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
    downloadUrl=https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.tar.xz?version=latest

    downloader "$downloadUrl" $md5

    cp $downloader_result $file
    mv $downloader_result theme_files/${var_theme}.tar.xz
}
addon(){
    addon_path=/sdcard/Documents/MIUI完美图标自定义
    if [ -d "$addon_path" ];then
    echo "- 正在导入自定义图标..."
    mkdir -p $TEMP_DIR/res/drawable-xxhdpi/
    mkdir -p $TEMP_DIR/layer_animating_icons
    cp -rf $addon_path/动态图标/* $TEMP_DIR/layer_animating_icons/ 2>/dev/null
    cp -rf $addon_path/静态图标/* $TEMP_DIR/res/drawable-xxhdpi/ 2>/dev/null
    cd $TEMP_DIR
    zip -r icons.zip res >/dev/null
    zip -r icons.zip layer_animating_icons >/dev/null
    cd ..
    fi
}

patch(){
  cd $TEMP_DIR
    tar -xf "$file" -C "$TEMP_DIR/" >&2
    mkdir -p res/drawable-xxhdpi
    mv icons/* res/drawable-xxhdpi 2>/dev/null
    rm icons
    zip -d icons.zip "layer_animating_icons/*" >/dev/null
    zip -r icons.zip layer_animating_icons >/dev/null
    zip -r icons.zip res 2>/dev/null
    rm -rf res
    rm -rf layer_animating_icons
}

require_new_magisk() {
  echo
  echo "- 当前模块不支持此Magisk版本"
  echo
  echo "- 请安装最新的 Magisk ！"
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
source $START_DIR/online-scripts/misc/downloader.sh
  if [ $var_version -lt 10 ]; then 
    echo "- 您的 Android 版本不符合要求，即将退出安装。"
    rm -rf $TEMP_DIR/*
    exit 1
  elif [ $var_miui_version -ge 10 ]; then
  echo "- 开始安装过程..."
  fi
  [ "`curl -I -s --connect-timeout 1 https://miuiiconseng-generic.pkg.coding.net/iconseng/engtest/test?version=latest -w %{http_code} | tail -n1`" == "200" ] ||{  echo "× 未检测到网络连接，取消安装 ... "&& rm -rf $TEMP_DIR/* 2>/dev/null && exit 1; }
  echo ""
  REPLACE="/system/media/theme/miui_mod_icons"
  var_theme=icons
  getfiles
  var_theme=$sel_theme
  getfiles
  echo "id=MIUIiconsplus
name=MIUI完美图标补全
author=@PedroZ
description=使用$theme_name主题并补全MIUI完美图标
version=$(TZ=$(getprop persist.sys.timezone) date '+%Y%m%d%H%M')
theme=$theme_name
themeid=$var_theme" >> $TEMP_DIR/module.prop
  install
  mkdir -p $MODPATH
  cp -rf $FAKEMODPATH/. $MODPATH
  set_perm_recursive $MODPATH 0 0 0755 0644
  for TARGET in $REPLACE; do
  mktouch $MODPATH$TARGET/.replace
  done
  mktouch /data/adb/modules/MIUIiconsplus/update
  cp -af $MODPATH/module.prop /data/adb/modules/MIUIiconsplus/module.prop
  rm -rf \
  $MODPATH/system/placeholder $MODPATH/customize.sh \
  $MODPATH/README.md $MODPATH/.git* 2>/dev/null
  cd /
  rm -rf $TEMP_DIR/*
  settings put global is_default_icon 0
  echo ""
  echo "- 安装成功，请重启设备 (^_^) "
  echo "---------------------------------------------"
  exit 0