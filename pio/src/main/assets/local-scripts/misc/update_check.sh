install_count=0
[ "`curl -I -s --connect-timeout 1 https://miuiicons-generic.pkg.coding.net/icons/files/check?version=latest -w %{http_code} | tail -n1`" == "200" ] || ( echo "× 未检测到网络连接... "&& rm -rf $TEMP_DIR/* 2>/dev/null && exit 1; )

check() {
curl -skLJo "$TEMP_DIR/$f" "$url/$f?version=latest"
source $TEMP_DIR/$f
new_ver=$theme_version
echo "${string_checking}${theme_name}"
echo "${string_localver}$old_ver"
echo "${string_onlinever}$new_ver"
if [ $new_ver -ne $old_ver ] ;then 
echo "${string_hasnewver1}${theme_name}${string_hasnewver2}"
else
echo "${string_newestver1}${theme_name}${string_newestver2}"
fi
echo
}


echo "------------------------"
echo
modules_installed=0
#MIUI模块
if [ -f "/data/adb/modules_update/MIUIiconsplus/module.prop" ]; then
source /data/adb/modules_update/MIUIiconsplus/module.prop 2>/dev/null
modules_installed=1
elif [ -f "/data/adb/modules/MIUIiconsplus/module.prop" ]; then
source /data/adb/modules/MIUIiconsplus/module.prop 2>/dev/null
modules_installed=1
fi

if [[ $modules_installed == 1 ]]; then
url=https://miuiicons-generic.pkg.coding.net/icons/files/
echo ${string_checkingmiuimodule}
echo
if [ -z $themeid ]; then
echo ${string_outofdatemodule}
fi
url=https://miuiicons-generic.pkg.coding.net/icons/files/
if [ -z "$icons" ];then
	old_ver=$iconsrepo
else
	old_ver=$icons
fi
f=iconsrepo.ini
check
f=${themeid}.ini
eval old_ver='$'$themeid
check
echo "------------------------"
echo 
else
let install_count=$install_count+1
fi


#MIUI主图标包资源
cd theme_files
flist=$(ls *.ini) 2>/dev/null
if [ ! -z "$flist" ]; then
echo ${string_checkingmiuires}
echo
url=https://miuiicons-generic.pkg.coding.net/icons/files/
for f in $flist
do
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
if [ -d hwt ] && cd hwt && flist=$(ls | grep \.ini$) && [ ! -z "$flist" ]; then
echo ${string_checkingemuires}
echo
url=https://emuiicons-generic.pkg.coding.net/files/zip/
for f in $flist
do
source ./$f
old_ver=$theme_version
check
done
echo "------------------------"
echo 
else
let install_count=$install_count+1
fi


if [ $install_count = 3 ];then
echo $string_checknoupfile
echo
echo "------------------------"
 
fi

rm -rf $TEMP_DIR/*