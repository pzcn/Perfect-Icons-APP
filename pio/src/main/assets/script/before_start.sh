#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl
echo "开始初始化..."

text="若本APP未显示新图标，则需要对EMUI/鸿蒙或MIUI完美图标进行更新。上线EMUI/鸿蒙OS主题导出功能，如有问题请及时反馈。"
extract_dir="$START_DIR/online-scripts"
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

echo $text > $extract_dir/misc/announce.txt
