device_check() {
if [ -n "$1" ]; then
  var_version="$(getprop ro.build.version.release)"
  var_miui_version="$(getprop ro.miui.ui.version.code)"
  if [ $var_version -lt 10 ]; then
    echo "- 您的 Android 版本不符合要求，即将退出安装。"
    echo "- Your Android version does not meet the requirements and the installation will be exited."
    cleanall
    exit 1
  fi
  if [ $var_miui_version -lt 10 ]; then
    echo "- 您的 MIUI 版本不符合要求或者不是 HyperOS/MIUI，即将退出安装。"
    echo "- Your MIUI version does not meet the requirements or is not HyperOS/MIUI, and the installation will exit."
    cleanall
    exit 1
  fi
fi
}

network_check() {
a=0
b=0
while [ "$b" -lt 3 ]
do
      let "b = $b + 1"
  curl -skLJo "$TEMP_DIR/link.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/link.ini?version=latest"
if [ -f $TEMP_DIR/link.ini ]; then
  source $TEMP_DIR/link.ini
  http_code="$(curl -I -s --connect-timeout 1 ${link_check} -w %{http_code} | tail -n1)"
  if [ "$http_code" != null ]; then
    if [[ ! $httpcode == *$http_code* ]]; then
      let "a = $a + 1"
    fi
  else
    let "a = $a + 1"
  fi
else
  let "a = $a + 1"
fi
[ "$a" -ne "$b" ] && b=3
done
[ "$a" = 3 ] &&  echo "${string_nonetworkdetected}" && cleanall >/dev/null && exit 1
}

init() {
source theme_files/theme_config
source theme_files/zipoutdir_config
source theme_files/addon_config
source theme_files/new_transform_config
source $START_DIR/local-scripts/misc/downloader.sh
[ -d "$zipoutdir" ] || { echo ${string_dirnotexist} && cleanall >/dev/null && exit 1; }
}

cleanall() {
if [[ -d "${START_DIR}/downloader" ]]; then
  rm -rf ${START_DIR}/downloader/*
fi
if [[ -d "${START_DIR}/kr-script" ]]; then
  rm -rf ${START_DIR}/kr-script/*
fi
if [[ -d "${TEMP_DIR}" ]]; then
  rm -rf ${TEMP_DIR}/*
fi
}

module_files() {
  mkdir -p $TEMP_DIR/moduletmp/META-INF/com/google/android
  echo "#MAGISK" >>$TEMP_DIR/moduletmp/META-INF/com/google/android/updater-script
  cat >$TEMP_DIR/moduletmp/META-INF/com/google/android/update-binary <<'EOF'
#!/sbin/sh
umask 022
ui_print() { echo "$1"; }

require_new_magisk() {
  ui_print "*******************************"
  ui_print " Please install Magisk v20.4+! "
  ui_print "*******************************"
  exit 1
}
OUTFD=$2
ZIPFILE=$3

mount /data 2>/dev/null

[ -f /data/adb/magisk/util_functions.sh ] || require_new_magisk
. /data/adb/magisk/util_functions.sh
[ $MAGISK_VER_CODE -lt 20400 ] && require_new_magisk
install_module
exit 0
EOF

  cat >$TEMP_DIR/moduletmp/post-fs-data.sh <<'EOF'
MODDIR="${0%/*}"
for i in /data/user/0/com.xiaomi.market/files/download_icon /data/user/0/com.xiaomi.market/cache/icons; do
  if [ -d $i ]; then
    rm -rf $i/*
    chattr +i $i
  fi
done
EOF

  cat >$TEMP_DIR/moduletmp/customize.sh <<'EOF'
#!/sbin/sh

ui_print "---------------------------------------------"
ui_print "  完美图标补全计划"
ui_print "  Perfect-Icons-Complement-Project"
ui_print "---------------------------------------------"
ui_print "- 本模块下载自【完美图标计划】APP"
ui_print "- 在酷安搜索【完美图标计划】获取更多信息"
ui_print "- QQ群：561180493"
ui_print ""
ui_print "- This module is downloaded from [Perfect Icon Project] APP"
ui_print "- Search [Perfect Icon Project] on Github or Coolapk to get more information"
ui_print "- Telegram: miuiicons"

ui_print "---------------------------------------------"

SKIPUNZIP=1
var_version="`getprop ro.build.version.release`"
var_miui_version="`getprop ro.miui.ui.version.code`"


if [ $var_version -lt 10 ]; then 
  abort "- 您的 Android 版本不符合要求，即将退出安装。"
  abort "- Your Android version does not meet the requirements and the installation will be exited."
fi
if [ $var_miui_version -lt 10 ]; then 
  abort "- 您的 HyperOS/MIUI 版本不符合要求，即将退出安装。"
  abort "- Your HyperOS/MIUI version does not meet the requirements and will exit the installation."
fi

if [ -L "/system/media" ] ;then
  mediapath=/system$(realpath /system/media)
else
  if [ -d "/system/media" ]; then 
    mediapath=/system/media
  else
    abort "- ROM似乎有问题，无法安装。"
    abort "- There seems to be a problem with the ROM and it cannot be installed."
  fi
fi

REPLACE="$mediapath/theme/miui_mod_icons"

echo "- 安装中..."
echo "- installing..."
mkdir -p ${MODPATH}${mediapath}/theme/default/
unzip -oj "$ZIPFILE" icons -d $MODPATH/$mediapath/theme/default/ >&2
unzip -oj "$ZIPFILE" addons/* -d $MODPATH/$mediapath/theme/default/ >&2
unzip -oj "$ZIPFILE" module.prop -d $MODPATH/ >&2
unzip -oj "$ZIPFILE" post-fs-data.sh -d $MODPATH/ >&2
settings put global is_default_icon 0
set_perm_recursive $MODPATH 0 0 0755 0644

rm -rf /data/system/package_cache/*
echo "√ 安装成功，请重启设备"
echo "√ Installation successful, please restart the device"
echo "---------------------------------------------"
EOF

  echo "id=MIUIiconsplus
name=MIUI ${string_projectname}
author=@PedroZ
description=${string_moduledescription_1}${theme_name}${string_moduledescription_2}
version=$(TZ=$(getprop persist.sys.timezone) date '+%Y%m%d%H%M')
theme=$theme_name
themeid=$var_theme" >>$TEMP_DIR/moduletmp/module.prop
}

save() {
  time=$(TZ=$(getprop persist.sys.timezone) date '+%m%d%H%M')
  modulefilepath="${zipoutdir}/${theme_name}${string_module}-$time.zip"
  mv $TEMP_DIR/moduletmp/module.zip "${modulefilepath}"
  echo "${string_modulesaveto}""${modulefilepath}"
}

disable_dynamicicon() {
  test=$(head -n 1 ${START_DIR}/theme_files/denylist)
  if [ "$test" = "all" ]; then
    echo "${string_disablealldynamic}"
    rm -rf $TEMP_DIR/layer_animating_icons
  elif [ "$test" = "" ]; then
    :
  else
    echo "${string_disabledynamic}"
    list=$(cat ${START_DIR}/theme_files/denylist)
    for p in $list; do
      [ -d "$TEMP_DIR/layer_animating_icons/$p" ] && rm -rf $TEMP_DIR/layer_animating_icons/$p && echo "  ""$p"
    done
  fi
}

pack() {
  echo "${string_exporting}$theme_name..."
  cd ${START_DIR}/theme_files/miui
  transform_config
  zip -r $TEMP_DIR/icons.zip * -x './res/drawable-xxhdpi/.git/*' >/dev/null
  cd $TEMP_DIR
  tar -xf $TEMP_DIR/$var_theme.tar.xz -C "$TEMP_DIR/"
  mkdir -p $TEMP_DIR/res/drawable-xxhdpi
  mv $TEMP_DIR/icons/* $TEMP_DIR/res/drawable-xxhdpi 2>/dev/null
  rm -rf $TEMP_DIR/icons
  [ -f ${START_DIR}/theme_files/denylist ] && disable_dynamicicon
  zip -r icons.zip ./layer_animating_icons >/dev/null
  zip -r icons.zip ./res >/dev/null
  rm -rf $TEMP_DIR/res
  rm -rf $TEMP_DIR/layer_animating_icons
  mkdir $TEMP_DIR/moduletmp
  [ $addon == 1 ] && addon
  mv $TEMP_DIR/icons.zip $TEMP_DIR/moduletmp/icons
  cd ${START_DIR}
}

install() {
  cd $TEMP_DIR/moduletmp
  module_files
  zip -r module.zip * >/dev/null
  if [ "$1" == kernelsu ]; then
    if [ -f "$TOOLKIT/mount" ]; then
      rm $TOOLKIT/mount
    fi
    if [ -f "$TOOLKIT/losetup" ]; then
      rm $TOOLKIT/losetup
    fi
    if [ -f "/data/adb/ksud" ]; then
      /data/adb/ksud module install $TEMP_DIR/moduletmp/module.zip >/dev/null
      echo "$string_installwithksu"
    else
      echo "$string_cannotinstall"
      save
    fi
  elif [ "$1" == magisk ]; then
    if [ $(magisk -V) -ge 20400 ]; then
      magisk --install-module $TEMP_DIR/moduletmp/module.zip >/dev/null
      echo "$string_installwithmagisk"
    else
      echo "$string_cannotinstall"
      save
    fi
  elif [ "$1" == save ]; then
    save
  fi
}

save_mtz() {
  themename2=$theme_name
  var_theme=mtz
  getfiles
  tar -xf "$TEMP_DIR/mtz.tar.xz" -C "$TEMP_DIR/moduletmp" >&2
  sed -i "s/themename/$themename2/g" $TEMP_DIR/moduletmp/description.xml
  cd $TEMP_DIR/moduletmp
  time=$(TZ=$(getprop persist.sys.timezone) date '+%m%d%H%M')
  zip -r mtz.zip * >/dev/null
  mtzfilepath="${zipoutdir}/${themename2}${string_projectname}-$time.mtz"
  mv $TEMP_DIR/moduletmp/mtz.zip "${mtzfilepath}"
  echo "$string_mtzsaveto""$mtzfilepath"
}

getfiles() {
  file=$TEMP_DIR/$var_theme.tar.xz
  if [ -f "${START_DIR}/theme_files/${var_theme}.tar.xz" ]; then
    source ${START_DIR}/theme_files/${var_theme}.ini
    old_ver=$theme_version
    curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/hyper/${var_theme}.ini?version=latest"
    source $TEMP_DIR/${var_theme}.ini
    source $START_DIR/local-scripts/misc/get_theme_name.sh
    new_ver=$theme_version
    if [ $new_ver -ne $old_ver ]; then
      echo "${string_newverdown_1}${theme_name}${string_newverdown_2}"
      download
    else
      echo "${string_vernoneedtodown_1}${theme_name}${string_vernoneedtodown_2}"
      cp -rf theme_files/${var_theme}.ini $TEMP_DIR/${var_theme}.ini
      cp -rf theme_files/${var_theme}.tar.xz $TEMP_DIR/${var_theme}.tar.xz
    fi
  else
    download
  fi
}

download() {
  curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/hyper/${var_theme}.ini?version=latest"
  mkdir theme_files 2>/dev/null
  source $TEMP_DIR/${var_theme}.ini
  source $START_DIR/local-scripts/misc/get_theme_name.sh
  cp -rf $TEMP_DIR/${var_theme}.ini theme_files/${var_theme}.ini
  if [ $file_size -gt 6291456 ]; then
    downloadUrl=${link_hyper}/${var_theme}.tar.xz
    downloader "$downloadUrl" $md5
    [ $var_theme == iconsrepo ] || cp $downloader_result theme_files/${var_theme}.tar.xz
    mv $downloader_result $TEMP_DIR/$var_theme.tar.xz
  else
    echo "${string_needtodownloadname_1}${theme_name}${string_needtodownloadname_2}"
    [ $file_size ] || { echo ${string_cannotdownload} && cleanall 2>/dev/null && exit 1; }
    echo "${string_needtodownloadsize_1}$(printf '%.1f' $(echo "scale=1;$file_size/1048576" | bc))${string_needtodownloadsize_2}"
    curl -skLJo "$TEMP_DIR/${var_theme}.tar.xz" "https://miuiicons-generic.pkg.coding.net/icons/hyper/${var_theme}.tar.xz?version=latest"
    [ $var_theme == iconsrepo ] || cp "$TEMP_DIR/${var_theme}.tar.xz" "theme_files/${var_theme}.tar.xz"
    md5_loacl=$(md5sum $TEMP_DIR/${var_theme}.tar.xz | cut -d ' ' -f1)
    if [[ "$md5" == "$md5_loacl" ]]; then
      echo $string_downloadsuccess
    else
      echo ${string_downloaderror}
      cleanall >/dev/null
      exit 1
    fi
  fi
}

addon() {
  addon_path=$SDCARD_PATH/Documents/${string_addonfolder}
  if [ -d "$addon_path" ]; then
    echo "${string_importaddonicons}"
    mkdir -p $TEMP_DIR/res/drawable-xxhdpi
    mkdir -p $TEMP_DIR/layer_animating_icons
    mkdir -p $TEMP_DIR/moduletmp/addons
    [ -d "$addon_path/${string_animatingicons}" ] && cp -rf $addon_path/${string_animatingicons}/* $TEMP_DIR/layer_animating_icons/ >/dev/null
    [ -d "$addon_path/${string_staticicons}" ] && cp -rf $addon_path/${string_staticicons}/* $TEMP_DIR/res/drawable-xxhdpi/ >/dev/null
    [ -d "$addon_path/${string_advancedaddons}" ] && cp -rf $addon_path/${string_advancedaddons}/* $TEMP_DIR/moduletmp/addons/ 2>/dev/null
    cd $TEMP_DIR
    zip -r icons.zip res >/dev/null
    zip -r icons.zip layer_animating_icons >/dev/null
    cd ..
  fi
}

transform_config() {
  if [ $new_transform_config = 1 ]; then
    cp -rf $START_DIR/local-scripts/misc/transform_config2.xml transform_config.xml
  else
    cp -rf $START_DIR/local-scripts/misc/transform_config1.xml transform_config.xml
  fi
}

exec 3>&2
exec 2>/dev/null

if [ "$1" != mtz ]; then
  device_check
fi

network_check
init
var_theme=iconsrepo
if [[ -d theme_files/miui/res/drawable-xxhdpi/.git ]]; then
  source theme_files/${var_theme}.ini
  old_ver=$theme_version
  curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/hyper/${var_theme}.ini?version=latest"
  source $TEMP_DIR/${var_theme}.ini
  source $START_DIR/local-scripts/misc/get_theme_name.sh
  new_ver=$theme_version
  if [ $new_ver -ne $old_ver ]; then
    echo "${string_newverdown_1}${theme_name}${string_newverdown_2}"
    echo "${string_gitpull}"
    cd theme_files/miui/res/drawable-xxhdpi
    export LD_LIBRARY_PATH=$TOOLKIT/so: $LD_LIBRARY_PATH
    git pull >/dev/null 2>&1 
    cp -rf $TEMP_DIR/${var_theme}.ini ${START_DIR}/theme_files/${var_theme}.ini
    cd ../../../..
  else
    echo "${string_vernoneedtodown_1}${theme_name}${string_vernoneedtodown_2}"
  fi
  echo "$var_theme=$theme_version" >>$TEMP_DIR/module.prop
else
  getfiles
  echo "${string_extracting}${theme_name}..."
  tar -xf "$TEMP_DIR/iconsrepo.tar.xz" -C "$TEMP_DIR/" >&2
  mv $TEMP_DIR/icons $TEMP_DIR/icons.zip
  unzip $TEMP_DIR/icons.zip -d theme_files/miui >/dev/null
  rm -rf $TEMP_DIR/icons.zip
  rm -rf $TEMP_DIR/iconsrepo.tar.xz
fi
var_theme=$sel_theme
getfiles
pack
if [ "$1" == mtz ]; then
  save_mtz
else
  install $1
fi
cleanall
echo "---------------------------------------------"
exit 0
