if [ -d "/data/adb/modules_update/MIUIiconsplus" ]; then
source /data/adb/modules_update/MIUIiconsplus/module.prop
elif [ -d "/data/adb/modules/MIUIiconsplus" ]; then
source /data/adb/modules/MIUIiconsplus/module.prop
else
echo "- 当前未安装。"
exit 0
fi
if [ "$themeid" == "" ]; then
echo "- 检测到您安装了旧版本，无法获取已安装版本号。完成首次更新后即可正常检查更新。"
echo "icons=-1" >>theme_files/update_status.ini
exit 0
fi

check() {
  [ "`curl -I -s --connect-timeout 1 https://miuiiconseng-generic.pkg.coding.net/iconseng/engtest/test?version=latest -w %{http_code} | tail -n1`" == "200" ] || ( echo "× 未检测到网络连接... "&& rm -rf $TEMP_DIR/* 2>/dev/null && exit 1; )
curl -skLJo "$TEMP_DIR/${var_theme}.ini" "https://miuiicons-generic.pkg.coding.net/icons/files/${var_theme}.ini?version=latest"
source $TEMP_DIR/${var_theme}.ini
eval new_ver='$'$var_theme
if [ $theme_version -ne ${new_ver} ] ;then 
echo "- $name有新版本，可以升级了。"
echo "$var_theme=1" >> theme_files/update_status.ini
else
echo "- $name已是最新。"
echo "$var_theme=0" >> theme_files/update_status.ini
fi
}

:> theme_files/update_status.ini
name1=$theme
var_theme=icons
name=主图标包
check
var_theme=$themeid
name=$name1
check