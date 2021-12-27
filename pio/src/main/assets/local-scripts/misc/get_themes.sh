if [ -d "/data/adb/modules_update/MIUIiconsplus" ]; then
source /data/adb/modules_update/MIUIiconsplus/module.prop
echo "${string_nowinstalled}$theme${string_reboottomakeitwork}"
elif [ -d "/data/adb/modules/MIUIiconsplus" ]; then
source /data/adb/modules/MIUIiconsplus/module.prop
echo "${string_nowinstalled}$theme"
else
echo "$string_notinstalled"
fi