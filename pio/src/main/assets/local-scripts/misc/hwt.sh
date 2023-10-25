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
install() {
  echo "${string_exportinghwt}"
  mkdir -p $TEMP_DIR/
  mkdir -p $TEMP_DIR/hwt
  mkdir -p $TEMP_DIR/icons
  mkdir -p $TEMP_DIR/style
  cd theme_files/hwt/icons
  zip -r $TEMP_DIR/icons.zip * -x './.git/*' >/dev/null
  cd ../..
  tar -xf $TEMP_DIR/$hwt_theme.tar.xz -C "$TEMP_DIR/hwt/"
  mv $TEMP_DIR/hwt/$sel_theme/icons $TEMP_DIR/hwt/$sel_theme/icons.zip
  unzip -qo $TEMP_DIR/hwt/$sel_theme/icons.zip -d $TEMP_DIR/icons
  rm -rf $TEMP_DIR/hwt/$sel_theme/icons.zip
  echo "${string_setsizeshape}"
  tar -xf "$TEMP_DIR/style.tar.xz" -C "$TEMP_DIR/style" >&2
  cp -rf ${TEMP_DIR}/style/${hwt_shape}_${hwt_size}/* $TEMP_DIR/icons
  source ${TEMP_DIR}/style/${hwt_shape}_${hwt_size}/config.ini
  cp -rf $TEMP_DIR/icons
  cd $TEMP_DIR/icons
  zip -qr $TEMP_DIR/icons.zip *
  cd $TEMP_DIR
  mv $TEMP_DIR/icons.zip $TEMP_DIR/hwt/$sel_theme/icons
  date1=$(TZ=$(getprop persist.sys.timezone) date '+%m.%d %H:%M')
  date2=$(TZ=$(getprop persist.sys.timezone) date '+%m%d%H%M')
  sed -i "s/{name}/$name/g" $TEMP_DIR/hwt/$sel_theme/description.xml
  sed -i "s/{id}/$id/g" $TEMP_DIR/hwt/$sel_theme/description.xml
  sed -i "s/{date}/$date1/g" $TEMP_DIR/hwt/$sel_theme/description.xml
  cd $TEMP_DIR/hwt/$sel_theme
  zip -qr $TEMP_DIR/hwt.zip *
  mv $TEMP_DIR/hwt.zip "$hwtdir/${theme_name}${string_projectname}.hwt"
  cleanall
  echo "${string_hwthasexportto} $hwtdir/${theme_name}${string_projectname}.hwt"
  echo "${string_hwtapply}"
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
    if [ $new_ver -ne $old_ver ]; then
      echo "${string_newverdown_1}${theme_name}${string_newverdown_2}"
      download
    else
      echo "${string_vernoneedtodown_1}${theme_name}${string_vernoneedtodown_2}"
      cp -rf theme_files/hwt/${hwt_theme}.ini $TEMP_DIR/${hwt_theme}.ini
      cp -rf theme_files/hwt/${hwt_theme}.tar.xz $TEMP_DIR/${hwt_theme}.tar.xz
    fi
  else
    download
  fi
}

download() {
  curl -skLJo "$TEMP_DIR/${hwt_theme}.ini" "https://emuiicons-generic.pkg.coding.net/files/zip/${hwt_theme}.ini?version=latest"
  mkdir theme_files 2>/dev/null
  source $TEMP_DIR/${hwt_theme}.ini
  cp -rf $TEMP_DIR/${hwt_theme}.ini theme_files/hwt/${hwt_theme}.ini
  if [ $file_size -gt 5242880 ]; then
    downloadUrl=${link_emui}/${hwt_theme}.tar.xz
    downloader "$downloadUrl" $md5
    [ $hwt_theme == iconsrepo2 ] || cp $downloader_result theme_files/hwt/${hwt_theme}.tar.xz
    mv $downloader_result $file
  else
    echo "${string_needtodownloadname_1}${theme_name}${string_needtodownloadname_2}"
    [ $file_size ] || { echo ${string_cannotdownload} && cleanall 2>/dev/null && exit 1; }
    echo "${string_needtodownloadsize_1}$(printf '%.1f' $(echo "scale=1;$file_size/1048576" | bc))${string_needtodownloadsize_2}"
    curl -skLJo "$TEMP_DIR/${hwt_theme}.tar.xz" "https://emuiicons-generic.pkg.coding.net/files/zip/${hwt_theme}.tar.xz?version=latest"
    [ $hwt_theme == iconsrepo ] || cp "$TEMP_DIR/${hwt_theme}.tar.xz" "theme_files/hwt/${hwt_theme}.tar.xz"
    md5_loacl=$(md5sum $TEMP_DIR/${hwt_theme}.tar.xz | cut -d ' ' -f1)
    if [[ "$md5" == "$md5_loacl" ]]; then
      echo $string_downloadsuccess
    else
      echo ${string_downloaderror}
      cleanall >/dev/null
      exit 1
    fi
  fi
}

exec 3>&2
exec 2>/dev/null
mkdir -p theme_files/hwt
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
source theme_files/hwt_theme_config
source theme_files/hwt_dir_config
source theme_files/hwt_size_config
source theme_files/hwt_shape_config
source $START_DIR/local-scripts/misc/downloader.sh
[ -d "$hwtdir" ] || { echo ${string_dirnotexist} && cleanall >/dev/null && exit 1; }
hwt_theme=iconsrepo2
if [[ -d theme_files/hwt/icons/.git ]]; then
  source theme_files/hwt/${hwt_theme}.ini
  old_ver=$theme_version
  curl -skLJo "$TEMP_DIR/${hwt_theme}.ini" "https://emuiicons-generic.pkg.coding.net/files/zip/${hwt_theme}.ini?version=latest"
  source $TEMP_DIR/${hwt_theme}.ini
  new_ver=$theme_version
  if [ $new_ver -ne $old_ver ]; then
    echo "${string_newverdown_1}${theme_name}${string_newverdown_2}"
    cd theme_files/hwt/icons
    export LD_LIBRARY_PATH=$TOOLKIT/so: $LD_LIBRARY_PATH
    echo "${string_gitpull}"
    git pull --rebase >/dev/null
    cp -rf $TEMP_DIR/${hwt_theme}.ini ${START_DIR}/theme_files/hwt/${hwt_theme}.ini
    cd ../../..
  else
    echo "${string_vernoneedtodown_1}${theme_name}${string_vernoneedtodown_2}"
  fi
else
  getfiles
  echo "${string_extracting}${theme_name}..."
  tar -xf "$TEMP_DIR/iconsrepo2.tar.xz" -C "theme_files/hwt" >&2
  rm -rf $TEMP_DIR/iconsrepo2.tar.xz
fi
hwt_theme=style
getfiles
hwt_theme=$sel_theme
getfiles
install
cleanall
echo "---------------------------------------------"
exit 0
