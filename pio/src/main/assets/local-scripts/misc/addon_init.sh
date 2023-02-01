
[ -d "$addon_path/$string_staticicons" ] || mkdir -p $addon_path/$string_staticicons
[ -d "$addon_path/$string_animatingicons" ] || mkdir -p $addon_path/$string_animatingicons
[ -d "$addon_path/$string_advancedaddons" ] || mkdir -p $addon_path/$string_advancedaddons
[ -f "$addon_path/.nomedia" ] || echo " " >  $addon_path/.nomedia
