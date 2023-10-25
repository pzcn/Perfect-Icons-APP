#!/system/bin/sh
[[ $(getprop ro.product.cpu.abi) == "arm64-v8a" ]] || exit 


if [ $LANGUAGE == "zh-rCN" ]; then
   string_init="启动中..."
   string_beta="当前为Beta通道..."
   language=""
   string_clean="正在清理缓存..."
else
   string_init="Initializing..."
   string_beta="Now in beta version..."
   language="eng"
   string_clean="Cleaning cache..."
fi

clean() {
cd ${START_DIR}/theme_files
rm -rf *.tar.xz
rm -rf *.ini
rm -rf hwt
rm -rf miui
rm -rf $SDCARD_PATH/Android/data/dev.miuiicons.pedroz/files/download
cd ${START_DIR}
echo $string_clean
}

chmod -R 777 $TOOLKIT/curl
echo $string_init


[ -d "theme_files" ] || mkdir theme_files
[ -f "theme_files/theme_config" ] || ( touch theme_files/theme_config && echo "sel_theme=default" > theme_files/theme_config )
[ -f "theme_files/addon_config" ] || ( touch theme_files/addon_config && echo "addon=0" > theme_files/addon_config )
[ -f "theme_files/mtzdir_config" ] || ( touch theme_files/mtzdir_config && echo "mtzdir=/sdcard/Download" > theme_files/mtzdir_config )
[ -f "theme_files/zipoutdir_config" ] || ( touch theme_files/zipoutdir_config && echo "zipoutdir=/sdcard/Download" > theme_files/zipoutdir_config )
[ -f "theme_files/hwt_theme_config" ] || ( touch theme_files/hwt_theme_config && echo "sel_theme=Aquamarine" > theme_files/hwt_theme_config )
[ -f "theme_files/hwt_size_config" ] || ( touch theme_files/hwt_size_config && echo "hwt_size=M" > theme_files/hwt_size_config )
[ -f "theme_files/hwt_shape_config" ] || ( touch theme_files/hwt_shape_config && echo "hwt_shape=Rectangle" > theme_files/hwt_shape_config )
[ -f "theme_files/update_status.ini" ] && ( rm -rf theme_files/update_status.ini )
[ -f "theme_files/download_config" ] || ( touch theme_files/download_config && echo "curlmode=0" > theme_files/download_config )
[ -f "theme_files/beta_config" ] || ( touch theme_files/beta_config && echo "beta=0" > theme_files/beta_config && beta=0 )
[ -f "theme_files/announce.txt" ] || ( touch theme_files/announce.txt )

var_miui_version="$(getprop ro.miui.ui.version.code)"
addon_path=$SDCARD_PATH/Documents/${string_addonfolder}

if [ -n "$var_miui_version" ]; then
[ -d "$addon_path/$string_staticicons" ] || mkdir -p $addon_path/$string_staticicons
[ -d "$addon_path/$string_animatingicons" ] || mkdir -p $addon_path/$string_animatingicons
[ -d "$addon_path/$string_advancedaddons" ] || mkdir -p $addon_path/$string_advancedaddons
[ -f "$addon_path/.nomedia" ] || echo " " >  $addon_path/.nomedia
fi

#旧版本升级清空旧版本缓存
if [ ! -f "theme_files/version" ]; then
clean
touch theme_files/version
echo "lastversion=3000" > theme_files/version
else
   source theme_files/version
   if [ $lastversion -lt 3000 ]; then
      clean
      echo "lastversion=3000" > theme_files/version
   fi
fi

if [ ! -f "theme_files/new_transform_config" ]; then
    if [ $(getprop ro.miui.ui.version.code) -le 14 ]; then
        touch theme_files/new_transform_config
        echo "new_transform_config=0" > theme_files/new_transform_config
    else
        touch theme_files/new_transform_config
        echo "new_transform_config=1" > theme_files/new_transform_config
    fi
fi

if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
   curl -skLJo "theme_files/iconscount.txt" "https://miuiicons-generic.pkg.coding.net/icons/hyper/iconscount.txt?version=latest"
fi

if [[ $beta = 1 ]]; then
   echo $string_beta
   [ -d "$extract_dir" ] || mkdir -p $extract_dir
   if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
      curl -skLJo "$extract_dir/before_start.sh" https://miuiicons-generic.pkg.coding.net/icons/files/before_start_3000.sh?version=latest
      chmod 755 "$extract_dir/before_start.sh"
      source "$extract_dir/before_start.sh"
   fi
else
   if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
      curl -skLJo "theme_files/announce.txt" "https://miuiicons-generic.pkg.coding.net/icons/files/announce3000${language}.txt?version=latest"
   fi
fi

