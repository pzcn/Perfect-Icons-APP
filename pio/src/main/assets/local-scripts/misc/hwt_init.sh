[ -f "theme_files/hwt_theme_config" ] || ( touch theme_files/hwt_theme_config && echo "sel_theme=Aquamarine" > theme_files/hwt_theme_config )
[ -f "theme_files/hwt_size_config" ] || ( touch theme_files/hwt_size_config && echo "hwt_size=M" > theme_files/hwt_size_config )
[ -f "theme_files/hwt_shape_config" ] || ( touch theme_files/hwt_shape_config && echo "hwt_shape=Rectangle" > theme_files/hwt_shape_config )

if [[ ! -f "theme_files/hwt_dir_config" ]]; then
	touch theme_files/hwt_dir_config
	if [[ -d "/sdcard/Huawei/Themes" ]]; then
		echo "hwtdir=/sdcard/Huawei/Themes" > theme_files/hwt_dir_config
	elif [[ -d "/sdcard/Download" ]]; then
		echo "hwtdir=/sdcard/Download" > theme_files/hwt_dir_config
	else
		echo "hwtdir=/sdcard" > theme_files/hwt_dir_config
	fi
fi
