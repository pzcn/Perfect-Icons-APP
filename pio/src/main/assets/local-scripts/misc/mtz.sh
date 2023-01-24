disable_dynamicicon() {
  test=$(head -n 1 ${START_DIR}/theme_files/denylist)
  if [ "$test" = "all" ]; then
    echo "- 禁用所有动态图标..."
    rm -rf $TEMP_DIR/layer_animating_icons
  elif [ "$test" = "" ]; then
    :
  else
    echo "- 禁用下列app的动态图标："
    list=$(cat ${START_DIR}/theme_files/denylist)
    for p in $list; do
      [ -d "$TEMP_DIR/layer_animating_icons/$p" ] && rm -rf $TEMP_DIR/layer_animating_icons/$p && echo "  ""$p"
    done
  fi
}

install() {
  echo "${string_exporting}$theme_name..."
  cd theme_files/miui
  zip -r $TEMP_DIR/icons.zip * -x './res/drawable-xxhdpi/.git/*' >/dev/null
  cd ../..
  cd $TEMP_DIR
  tar -xf $TEMP_DIR/$var_theme.tar.xz -C "$TEMP_DIR/"
  mkdir -p ./res/drawable-xxhdpi
  mv icons/* ./res/drawable-xxhdpi 2>/dev/null
  rm -rf icons
  [ -f ${START_DIR}/theme_files/denylist ] && disable_dynamicicon
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
  if [ "$1" == apply ]; then
    rm -rf com.miui.home
    rm -rf wallpaper
  fi
  time=$(TZ=$(getprop persist.sys.timezone) date '+%m%d%H%M')
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
  curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.ini?version=latest"
  mkdir theme_files 2>/dev/null
  source $TEMP_DIR/${var_theme}.ini
  source $START_DIR/local-scripts/misc/get_theme_name.sh
  cp -rf $TEMP_DIR/${var_theme}.ini theme_files/${var_theme}.ini
  if [ $file_size -gt 5242880 ]; then
    downloadUrl=${link_miui}/${var_theme}.tar.xz
    downloader "$downloadUrl" $md5
    [ $var_theme == iconsrepo ] || cp $downloader_result theme_files/${var_theme}.tar.xz
    mv $downloader_result $TEMP_DIR/$var_theme.tar.xz
  else
    echo "${string_needtodownloadname_1}${theme_name}${string_needtodownloadname_2}"
    [ $file_size ] || { echo ${string_cannotdownload} && cleanall 2>/dev/null && exit 1; }
    echo "${string_needtodownloadsize_1}$(printf '%.1f' $(echo "scale=1;$file_size/1048576" | bc))${string_needtodownloadsize_2}"
    curl -skLJo "$TEMP_DIR/${var_theme}.tar.xz" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.tar.xz?version=latest"
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

curl -skLJo "$TEMP_DIR/link.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/link.ini?version=latest"
if [ -f $TEMP_DIR/link.ini ]; then
  source $TEMP_DIR/link.ini
  http_code="$(curl -I -s --connect-timeout 1 ${link_check} -w %{http_code} | tail -n1)"
  if [ "$http_code" != null ]; then
    if [[ ! $httpcode == *$http_code* ]]; then
      { echo "${string_nonetworkdetected}" && cleanall >/dev/null && exit 1; }
    fi
  else
    { echo "${string_nonetworkdetected}" && cleanall >/dev/null && exit 1; }
  fi
else
  { echo "${string_nonetworkdetected}" && cleanall >/dev/null && exit 1; }
fi

source theme_files/theme_config
source theme_files/mtzdir_config
source theme_files/addon_config
source $START_DIR/local-scripts/misc/downloader.sh
[ -d "$mtzdir" ] || { echo ${string_dirnotexist} && cleanall >/dev/null && exit 1; }
var_theme=iconsrepo
if [[ -d theme_files/miui/res/drawable-xxhdpi/.git ]]; then
  source theme_files/${var_theme}.ini
  old_ver=$theme_version
  curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.ini?version=latest"
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
  sh $START_DIR/local-scripts/misc/am.sh start -a android.intent.action.MAIN -n "com.android.thememanager/.ApplyThemeForScreenshot" --es theme_file_path "$mtzfilepath" --es api_called_from "test" >/dev/null
fi

cleanall
echo "---------------------------------------------"
exit 0
