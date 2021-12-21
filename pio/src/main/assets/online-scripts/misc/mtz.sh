
install() {
    echo "- 正在导出$theme_name..."
    tar -xf "$TEMP_DIR/icons.tar.xz" -C "$TEMP_DIR/" >&2
    mv $TEMP_DIR/icons $TEMP_DIR/icons.zip
    cd $TEMP_DIR
    tar -xf  $TEMP_DIR/$var_theme.tar.xz -C "$TEMP_DIR/"
    mkdir -p ./res/drawable-xxhdpi
    mv  icons/* ./res/drawable-xxhdpi 2>/dev/null
    rm -rf icons
    zip -r icons.zip ./layer_animating_icons >/dev/null
    zip -r icons.zip ./res >/dev/null
    rm -rf res
    rm -rf layer_animating_icons
    cd ..
    [ $addon == 1 ] && addon
    mkdir $TEMP_DIR/mtztmp
    tar -xf "$TEMP_DIR/mtz.tar.xz" -C "$TEMP_DIR/mtztmp" >&2
    cp -rf $TEMP_DIR/icons.zip $TEMP_DIR/mtztmp/icons
    sed -i "s/themename/$theme_name/g" $TEMP_DIR/mtztmp/description.xml
    cd $TEMP_DIR/mtztmp
    time=$(TZ=$(getprop persist.sys.timezone) date '+%Y%m%d%H%M')
    zip -r mtz.zip * >/dev/null
    mv mtz.zip $mtzdir/${theme_name}完美图标补全-$time.mtz
    rm -rf $TEMP_DIR/*
    echo "- mtz主题包已导出到 $mtzdir/${theme_name}完美图标补全-$time.mtz。"
    echo "- 需要设计师账号或主题破解才能导入并使用。"
    exit 0
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
    echo "- 检测到自定义图标，正在导入..."
    mkdir -p $TEMP_DIR/res/drawable-xxhdpi/
    mkdir -p $TEMP_DIR/layer_animating_icons
    cp -rf $addon_path/动态图标/* $TEMP_DIR/layer_animating_icons/ >/dev/null
    cp -rf $addon_path/静态图标/* $TEMP_DIR/res/drawable-xxhdpi/ >/dev/null
    cd $TEMP_DIR
    zip -r icons.zip res >/dev/null
    zip -r icons.zip layer_animating_icons >/dev/null
    cd ..
    fi
}
  exec 3>&2
  exec 2>/dev/null
  [ "`curl -I -s --connect-timeout 1 https://miuiiconseng-generic.pkg.coding.net/iconseng/engtest/test?version=latest -w %{http_code} | tail -n1`" == "200" ] ||{  echo "× 未检测到网络连接，取消安装 ... "&& rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
  source theme_files/theme_config
  source theme_files/mtzdir_config
  source theme_files/addon_config
  source $START_DIR/online-scripts/misc/downloader.sh
  [ -d "$mtzdir" ] || {  echo "× 选择导出的文件夹不存在，请重新选择 "&& rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
  var_theme=icons
  getfiles
  var_theme=mtz
  getfiles
  var_theme=$sel_theme
  getfiles
  install
  rm -rf $TEMP_DIR/*
  echo "---------------------------------------------"
  exit 0