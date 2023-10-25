exec 3>&2
exec 2>/dev/null
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

install_count=0
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

check() {
	curl -skLJo "$TEMP_DIR/$f" "$url/$f?version=latest"
	source $TEMP_DIR/$f
	new_ver=$theme_version
	source $START_DIR/local-scripts/misc/get_theme_name.sh
	echo "${string_checking}${theme_name}"
	echo "${string_localver}$old_ver"
	echo "${string_onlinever}$new_ver"
	if [ $new_ver -ne $old_ver ]; then
		echo "${string_hasnewver1}${theme_name}${string_hasnewver2}"
	else
		echo "${string_newestver1}${theme_name}${string_newestver2}"
	fi
	echo
}

#MIUI主图标包资源
cd theme_files
flist=$(ls *.ini) 2>/dev/null
if [ ! -z "$flist" ]; then
	echo ${string_checkingmiuires}
	echo
	url=https://miuiicons-generic.pkg.coding.net/hyper/files/
	for f in $flist; do
		source ./$f
		old_ver=$theme_version
		check
	done
	echo "------------------------"
	echo
else
	let install_count=$install_count+1
fi

#EMUI资源
if [ -d "./hwt" ] && cd hwt && flist=$(ls | grep \.ini$) && [ ! -z "$flist" ]; then
	echo ${string_checkingemuires}
	echo
	url=https://emuiicons-generic.pkg.coding.net/files/zip/
	for f in $flist; do
		source ./$f
		old_ver=$theme_version
		check
	done
	echo "------------------------"
	echo
else
	let install_count=$install_count+1
fi

if [ $install_count = 3 ]; then
	echo $string_checknoupfile
	echo
	echo "------------------------"

fi

rm -rf $TEMP_DIR/*
