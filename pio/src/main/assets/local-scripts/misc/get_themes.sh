if [ -d "/data/adb/modules_update/MIUIiconsplus" ]; then
source /data/adb/modules_update/MIUIiconsplus/module.prop
echo "'@string:string_nowinstalled'$theme'@string:string_reboottomakeitwork'"
elif [ -d "/data/adb/modules/MIUIiconsplus" ]; then
source /data/adb/modules/MIUIiconsplus/module.prop
echo "'@string:string_nowinstalled'$theme"
else
echo "@string:string_notinstalled"
fi