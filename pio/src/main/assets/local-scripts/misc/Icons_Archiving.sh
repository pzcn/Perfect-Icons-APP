addon_path=/sdcard/Documents/MIUI完美图标自定义
[ -d "$addon_path" ] || mkdir -p $addon_path/静态图标 && mkdir -p $addon_path/动态图标 && echo " " >  $addon_path/.nomedia
curl -skLJo "/sdcard/Documents/MIUI完美图标自定义/图标存档.zip" "https://miuiicons-generic.pkg.coding.net/icons/files/Icons_Archiving.zip?version=latest"
echo 图标存档已下载到/sdcard/Document/MIUI完美图标/图标存档