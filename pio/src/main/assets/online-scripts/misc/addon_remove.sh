if [ -d "/data/adb/modules_update/MIUIiconsplus_addon" ]; then
cp /data/adb/modules_update/MIUIiconsplus_addon/animating_icons/* /sdcard/Documents/MIUI完美图标自定义/动态图标 2>dev/unll
echo 自定义图标已移动到/sdcard/Documents/MIUI完美图标自定义
cp /data/adb/modules_update/MIUIiconsplus_addon/icons/* /sdcard/Documents/MIUI完美图标自定义/静态图标 2>dev/unll
rm -rf /data/adb/modules_update/MIUIiconsplus_addon
rm -rf /data/adb/modules/MIUIiconsplus_addon
echo 旧版本自定义模块已删除
echo 完成
elif [ -d "/data/adb/modules/MIUIiconsplus_addon" ]; then
cp /data/adb/modules_update/MIUIiconsplus/animating_icons/* /sdcard/Documents/MIUI完美图标自定义/动态图标 2>dev/unll
cp /data/adb/modules_update/MIUIiconsplus/icons/* /sdcard/Documents/MIUI完美图标自定义/静态图标 2>dev/unll
echo 自定义图标已移动到/sdcard/Documents/MIUI完美图标自定义
rm -rf /data/adb/modules/MIUIiconsplus_addon
echo 旧版本自定义模块已删除
echo 完成
else
echo "似乎没有检测到遗留的附加模块..."
fi