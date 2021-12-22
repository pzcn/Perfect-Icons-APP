#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl
echo "开始初始化..."
addon_path=/sdcard/Documents/MIUI完美图标自定义
[ -d "theme_files" ] || mkdir theme_files
[ -f "theme_files/theme_config" ] || ( touch theme_files/theme_config && echo "sel_theme=default" > theme_files/theme_config )
[ -f "theme_files/addon_config" ] || ( touch theme_files/addon_config && echo "addon=0" > theme_files/addon_config )
[ -f "theme_files/mtzdir_config" ] || ( touch theme_files/mtzdir_config && echo "mtzdir=/sdcard/Download" > theme_files/mtzdir_config )
[ -f "theme_files/hwt_theme_config" ] || ( touch theme_files/hwt_theme_config && echo "sel_theme=Aquamarine" > theme_files/hwt_theme_config )
[ -f "theme_files/hwt_size_config" ] || ( touch theme_files/hwt_size_config && echo "hwt_size=M" > theme_files/hwt_size_config )
[ -f "theme_files/hwt_shape_config" ] || ( touch theme_files/hwt_shape_config && echo "hwt_shape=Rectangle" > theme_files/hwt_shape_config )
[ -f "theme_files/update_status.ini" ] && ( rm -rf theme_files/update_status.ini )
[ -f "theme_files/download_config" ] || ( touch theme_files/download_config && echo "curlmode=0" > theme_files/download_config )
[ -f "theme_files/beta_config" ] || ( touch theme_files/beta_config && echo "beta=0" > theme_files/beta_config )
[ -f "theme_files/announce.txt" ] || ( touch theme_files/announce.txt )
source theme_files/beta_config

if [[ $beta = 1 ]]; then
   extract_dir="$START_DIR/online-scripts"
   echo "当前为Beta通道..."
   [ -d "$START_DIR/online-scripts" ] || mkdir -p $START_DIR/online-scripts
   if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
      curl -skLJo "$START_DIR/online-scripts/before_start.sh" https://miuiicons-generic.pkg.coding.net/icons/files/before_start_23.sh?version=latest
      chmod 755 "$START_DIR/online-scripts/before_start.sh"
      sh "$START_DIR/online-scripts/before_start.sh"
   fi
else
   extract_dir="$START_DIR/local-scripts"
   if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
      curl -skLJo "theme_files/announce.txt" "https://miuiicons-generic.pkg.coding.net/icons/files/announce.txt?version=latest"
   fi
fi



