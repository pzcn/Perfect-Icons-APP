addon_path=/sdcard/Documents/@string:string_addonfolder}
[ -d "$addon_path" ] || mkdir -p $addon_path/@string:string_staticicons && mkdir -p $addon_path/@string:string_animatingicons && echo " " >  $addon_path/.nomedia
curl -skLJo "/sdcard/Documents/'@string:string_addonfolder'/'@string:string_archievedicons'.zip" "https://miuiicons-generic.pkg.coding.net/icons/files/Icons_Archiving.zip?version=latest"
echo "'@string:string_archiveddownloadedto'/sdcard/Document/'@string:string_addonfolder'/'@string:string_archievedicons'.zip"