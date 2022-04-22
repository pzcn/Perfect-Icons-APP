
install() {
    echo "${string_exporting}$theme_name..."
    cd theme_files/miui
    zip -r $TEMP_DIR/icons.zip * -x './res/drawable-xxhdpi/.git/*' >/dev/null
    cd ../..
    cd $TEMP_DIR
    toybox tar -xf  $TEMP_DIR/$var_theme.tar.xz -C "$TEMP_DIR/"
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
    toybox tar -xf "$TEMP_DIR/mtz.tar.xz" -C "$TEMP_DIR/mtztmp" >&2
    cp -rf $TEMP_DIR/icons.zip $TEMP_DIR/mtztmp/icons
    sed -i "s/themename/$theme_name/g" $TEMP_DIR/mtztmp/description.xml
    cd $TEMP_DIR/mtztmp
    if [ "$1" == apply ]; then 
     rm -rf com.miui.home
     rm -rf wallpaper
    fi
    time=$(TZ=$(getprop persist.sys.timezone) date '+%Y%m%d%H%M')
    zip -r mtz.zip * >/dev/null
    mtzfilepath=$mtzdir/${theme_name}${string_projectname}-$time.mtz
    mv mtz.zip $mtzfilepath
    echo "${string_mtzhasexportto} $mtzfilepath"
    echo "${string_mtznotice}"
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
    addon_path=$SDCARD_PATH/Documents/${string_addonfolder}
    if [ -d "$addon_path" ];then
    echo "${string_importaddonicons}"
    mkdir -p $TEMP_DIR/res/drawable-xxhdpi/
    mkdir -p $TEMP_DIR/layer_animating_icons
    cp -rf $addon_path/${string_animatingicons}/* $TEMP_DIR/layer_animating_icons/ >/dev/null
    cp -rf $addon_path/${string_staticicons}/* $TEMP_DIR/res/drawable-xxhdpi/ >/dev/null
    cd $TEMP_DIR
    zip -r icons.zip res >/dev/null
    zip -r icons.zip layer_animating_icons >/dev/null
    cd ..
    fi
}
  exec 3>&2
  exec 2>/dev/null
  [ "`curl -I -s --connect-timeout 1 https://miuiicons-generic.pkg.coding.net/icons/files/check?version=latest -w %{http_code} | tail -n1`" == "200" ] ||{  echo "${string_nonetworkdetected}" && rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
  source theme_files/theme_config
  source theme_files/mtzdir_config
  source theme_files/addon_config
  source $START_DIR/local-scripts/misc/downloader.sh
  [ -d "$mtzdir" ] || {  echo ${string_dirnotexist} && rm -rf $TEMP_DIR/* >/dev/null && exit 1; }
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
  var_theme=mtz
  getfiles
  var_theme=$sel_theme
  getfiles
  install
  if [ "$1" == apply ]; then 
    echo ${string_mtztrailtimeout}
    echo ${string_mtztrailwarn}
    echo 5...
    sleep 1
    echo 4...
    sleep 1
    echo 3...
    sleep 1
    echo 2...
    sleep 1
    echo 1...
    sleep 1
    sh $START_DIR/local-scripts/misc/am.sh start -a android.intent.action.MAIN -n "com.android.thememanager/.ApplyThemeForScreenshot" --es theme_file_path "$mtzfilepath" --es api_called_from "test" > /dev/null
  fi

  rm -rf $TEMP_DIR/*
  echo "---------------------------------------------"
  exit 0
