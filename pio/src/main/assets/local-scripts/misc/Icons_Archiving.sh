addon_path=$SDCARD_PATH/Documents/${string_addonfolder}
[ -d "$addon_path" ] || mkdir -p $addon_path/${string_staticicons} && mkdir -p $addon_path/${string_animatingicons} && echo " " >  $addon_path/.nomedia
curl -skLJo "$SDCARD_PATH/Documents/${string_addonfolder}/${string_archievedicons}.zip" "https://miuiicons-generic.pkg.coding.net/icons/files/Icons_Archiving.zip"
echo "${string_archiveddownloadedto}/sdcard/Document/${string_addonfolder}/${string_archievedicons}.zip"