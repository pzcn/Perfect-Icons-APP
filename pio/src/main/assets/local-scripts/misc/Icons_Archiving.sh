addon_path=/sdcard/Documents/${string_addonfolder}
[ -d "$addon_path" ] || mkdir -p $addon_path/${string_staticicons} && mkdir -p $addon_path/${string_animatingicons} && echo " " >  $addon_path/.nomedia
curl -skLJo "/sdcard/Documents/${string_addonfolder}/${string_archievedicons}.zip" "https://miuiicons-generic.pkg.coding.net/icons/files/Icons_Archiving.zip?version=latest"
echo "${string_archiveddownloadedto}/sdcard/Document/${string_addonfolder}/${string_archievedicons}.zip"