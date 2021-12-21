
install() {
    echo "- 正在导出主题包..."
    mkdir -p $TEMP_DIR/
    mkdir -p $TEMP_DIR/hwt
    mkdir -p $TEMP_DIR/icons
    mkdir -p $TEMP_DIR/style
    tar -xf "$TEMP_DIR/icons.tar.xz" -C "$TEMP_DIR/" >&2
    tar -xf  $TEMP_DIR/$hwt_theme.tar.xz -C "$TEMP_DIR/hwt/"
    mv $TEMP_DIR/hwt/$sel_theme/icons $TEMP_DIR/hwt/$sel_theme/icons.zip
    unzip -qo $TEMP_DIR/hwt/$sel_theme/icons.zip -d $TEMP_DIR/icons
    rm -rf $TEMP_DIR/hwt/$sel_theme/icons.zip
    echo "- 正在设置形状和大小..."
    tar -xf "$TEMP_DIR/style.tar.xz" -C "$TEMP_DIR/style" >&2
    cp -rf ${TEMP_DIR}/style/${hwt_shape}_${hwt_size}/* $TEMP_DIR/icons
    source ${TEMP_DIR}/style/${hwt_shape}_${hwt_size}/config.ini
    cp -rf $TEMP_DIR/icons
    cd $TEMP_DIR/icons
    zip -qr $TEMP_DIR/icons.zip * 
    cd $TEMP_DIR
    mv $TEMP_DIR/icons.zip $TEMP_DIR/hwt/$sel_theme/icons
    date1=$(TZ=$(getprop persist.sys.timezone) date '+%m.%d %H:%M')
    sed -i "s/{name}/$name/g" $TEMP_DIR/hwt/$sel_theme/description.xml
    sed -i "s/{id}/$id/g" $TEMP_DIR/hwt/$sel_theme/description.xml
    sed -i "s/{date}/$date1/g" $TEMP_DIR/hwt/$sel_theme/description.xml
    date2=$(TZ=$(getprop persist.sys.timezone) date '+%m%d%H%M')
    cd $TEMP_DIR/hwt/$sel_theme
    zip -qr $TEMP_DIR/hwt.zip * 
    mv $TEMP_DIR/hwt.zip $hwtdir/${theme_name}完美图标补全-$date2.hwt
    rm -rf $TEMP_DIR/*
    echo "- hwt主题包已导出到 $hwtdir/${theme_name}完美图标补全-$date2.hwt"
    exit 0
    }

getfiles() {
file=$TEMP_DIR/$hwt_theme.tar.xz
if [ -f "theme_files/hwt/${hwt_theme}.tar.xz" ]; then
source theme_files/hwt/${hwt_theme}.ini
old_ver=$theme_version
curl -skLJo "$TEMP_DIR/${hwt_theme}.ini" "https://emuiicons-generic.pkg.coding.net/files/zip/${hwt_theme}.ini?version=latest"
source $TEMP_DIR/${hwt_theme}.ini
new_ver=$theme_version
if [ $new_ver -ne $old_ver ] ;then 
echo "- ${theme_name}有新版本，即将开始下载..."
download
else
echo "- ${theme_name}没有更新，无需下载..."
cp -rf theme_files/hwt/${hwt_theme}.ini $TEMP_DIR/${hwt_theme}.ini
cp -rf theme_files/hwt/${hwt_theme}.tar.xz $TEMP_DIR/${hwt_theme}.tar.xz
fi
else download
fi
}

download() {
    curl -skLJo "$TEMP_DIR/${hwt_theme}.ini" "https://emuiicons-generic.pkg.coding.net/files/zip/${hwt_theme}.ini?version=latest"
    mkdir theme_files 2>/dev/null
    source $TEMP_DIR/${hwt_theme}.ini
    cp -rf $TEMP_DIR/${hwt_theme}.ini theme_files/hwt/${hwt_theme}.ini
    downloadUrl=https://emuiicons-generic.pkg.coding.net/files/zip/${hwt_theme}.tar.xz?version=latest
    downloader "$downloadUrl" $md5
    cp $file theme_files/hwt/${hwt_theme}.tar.xz
    cp $downloader_result $file
    mv $downloader_result theme_files/hwt/${hwt_theme}.tar.xz
}

  exec 3>&2
  exec 2>/dev/null
  mkdir -p theme_files/hwt
  [ "`curl -I -s --connect-timeout 1 https://miuiiconseng-generic.pkg.coding.net/iconseng/engtest/test?version=latest -w %{http_code} | tail -n1`" == "200" ] ||{  echo "× 未检测到网络连接，取消安装 ... "&& rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
  source theme_files/hwt_theme_config
  source theme_files/hwt_dir_config
  source theme_files/hwt_size_config
  source theme_files/hwt_shape_config
  source $START_DIR/online-scripts/misc/downloader.sh
  [ -d "$hwtdir" ] || {  echo "× 选择导出的文件夹不存在，请重新选择 "&& rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
  hwt_theme=icons
  getfiles
  hwt_theme=style
  getfiles
  hwt_theme=$sel_theme
  getfiles
  install
  rm -rf $TEMP_DIR/*
  echo "---------------------------------------------"
  exit 0