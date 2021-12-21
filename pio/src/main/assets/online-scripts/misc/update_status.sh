if [ -d "/data/adb/modules_update/MIUIiconsplus" ]; then
source /data/adb/modules_update/MIUIiconsplus/module.prop
elif [ -d "/data/adb/modules/MIUIiconsplus" ]; then
source /data/adb/modules/MIUIiconsplus/module.prop
else
echo "当前未安装"
exit 0
fi


name=$theme
if [ ! -f "theme_files/update_status.ini" ] ;then
echo "轻触『检查更新』以获取当前状态"
else
source theme_files/update_status.ini
if [ $icons = 1 ]; then
echo "主图标包：有新版本！"
elif [ $icons = 0 ]; then
echo 主图标包：已是最新
elif [ $icons = -1 ]; then
echo "检测到您安装了旧版本，无法获取已安装版本号。完成首次更新后即可正常检查更新"
exit 0
else
echo "主图标包：状态异常"
fi
eval theme1='$'$themeid
if [ $theme1 = 1 ]; then
echo $name：有新版本！
elif [ $theme1 = 0 ]; then
echo $name：已是最新
else 
echo $name：状态异常
fi
fi