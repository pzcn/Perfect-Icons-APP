if [ -d "/data/adb/modules_update/MIUIiconsplus_addon" ]; then
cp /data/adb/modules_update/MIUIiconsplus_addon/animating_icons/* /sdcard/Documents/$string_addonfolder/$string_animatingicons 2>dev/unll
echo $string_addonmovedto/sdcard/Documents/$string_addonfolder
cp /data/adb/modules_update/MIUIiconsplus_addon/icons/* /sdcard/Documents/$string_addonfolder/$string_staticicons 2>dev/unll
rm -rf /data/adb/modules_update/MIUIiconsplus_addon
rm -rf /data/adb/modules/MIUIiconsplus_addon
echo $string_oldaddondeleted
echo $string_completed
elif [ -d "/data/adb/modules/MIUIiconsplus_addon" ]; then
cp /data/adb/modules_update/MIUIiconsplus/animating_icons/* /sdcard/Documents/$string_addonfolder/$string_animatingicons 2>dev/unll
cp /data/adb/modules_update/MIUIiconsplus/icons/* /sdcard/Documents/$string_addonfolder/$string_staticicons 2>dev/unll
echo $string_addonmovedto/sdcard/Documents/$string_addonfolder
rm -rf /data/adb/modules/MIUIiconsplus_addon
echo $string_oldaddondeleted
echo $string_completed
else
echo $string_nooldaddon
fi