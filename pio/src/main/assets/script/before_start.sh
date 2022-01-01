#!/system/bin/sh

[[ $(getprop ro.product.cpu.abi) == "arm64-v8a" ]] || exit 


if [ $LANGUAGE == "zh-rCN" ]; then
   string_init="启动中..."
   string_beta="当前为Beta通道..."
   language=""
else
   string_init="Initializing..."
   string_beta="Now in beta version..."
   language="eng"
fi

chmod -R 777 $TOOLKIT/curl
echo $string_init
[ -d "theme_files" ] || mkdir theme_files
[ -f "theme_files/theme_config" ] || ( touch theme_files/theme_config && echo "sel_theme=default" > theme_files/theme_config )
[ -f "theme_files/addon_config" ] || ( touch theme_files/addon_config && echo "addon=0" > theme_files/addon_config )
[ -f "theme_files/mtzdir_config" ] || ( touch theme_files/mtzdir_config && echo "mtzdir=/sdcard/Download" > theme_files/mtzdir_config )
[ -f "theme_files/hwt_theme_config" ] || ( touch theme_files/hwt_theme_config && echo "sel_theme=Aquamarine" > theme_files/hwt_theme_config )
[ -f "theme_files/hwt_size_config" ] || ( touch theme_files/hwt_size_config && echo "hwt_size=M" > theme_files/hwt_size_config )
[ -f "theme_files/hwt_shape_config" ] || ( touch theme_files/hwt_shape_config && echo "hwt_shape=Rectangle" > theme_files/hwt_shape_config )
[ -f "theme_files/update_status.ini" ] && ( rm -rf theme_files/update_status.ini )
[ -f "theme_files/download_config" ] || ( touch theme_files/download_config && echo "curlmode=0" > theme_files/download_config )
[ -f "theme_files/beta_config" ] || ( touch theme_files/beta_config && echo "beta=0" > theme_files/beta_config && beta=0 )
[ -f "theme_files/announce.txt" ] || ( touch theme_files/announce.txt )

if [[ $beta = 1 ]]; then
   echo $string_beta
   [ -d "$extract_dir" ] || mkdir -p $extract_dir
   if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
      curl -skLJo "$extract_dir/before_start.sh" https://miuiicons-generic.pkg.coding.net/icons/files/before_start_252.sh?version=latest
      chmod 755 "$extract_dir/before_start.sh"
      source "$extract_dir/before_start.sh"
   fi
else
   if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
      curl -skLJo "theme_files/announce.txt" "https://miuiicons-generic.pkg.coding.net/icons/files/announce251${language}.txt?version=latest"
   fi
fi
