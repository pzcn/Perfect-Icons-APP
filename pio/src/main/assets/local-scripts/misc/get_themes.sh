if [ -d "/data/adb/modules_update/MIUIiconsplus" ]; then
source /data/adb/modules_update/MIUIiconsplus/module.prop
echo "当前已安装：$theme，重启后应用"
elif [ -d "/data/adb/modules/MIUIiconsplus" ]; then
source /data/adb/modules/MIUIiconsplus/module.prop
echo "当前已安装：$theme"
else
echo "当前未安装"
fi