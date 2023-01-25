get_theme_name() {
	[ $themeid = default ] && name=${string_default}
	[ $themeid = coloros12 ] && name=${string_ColorOS12}
	[ $themeid = explore ] && name=${string_explore}
	[ $themeid = flyme9 ] && name=${string_Flyme9}
	[ $themeid = lrone ] && name=${string_lrone}
	[ $themeid = luck7 ] && name=${string_luck7}
	[ $themeid = perfectcurve ] && name=${string_perfectcurve}
	[ $themeid = Aquamarine ] && name=${string_HarmonyOSAquamarine}
	[ $themeid = AmethystLake ] && name=${string_EMUIAmethystLake}
	[ $themeid = GoldenBeach ] && name=${string_EMUIGoldenBeach}
	[ $themeid = LightWings ] && name=${string_EMUILightWings}
	[ $themeid = Nebulae ] && name=${string_EMUINebulae}
	[ $themeid = StarrySky ] && name=${string_EMUIStarrySky}
	[ $themeid = Reconstruction ] && name=${string_EMUIReconstruction}
	[ $themeid = iOS ] && name=${string_iOS}
	[ $themeid = coloros13 ] && name=ColorOS13
}

if [ -d "/data/adb/modules_update/MIUIiconsplus" ]; then
	source /data/adb/modules_update/MIUIiconsplus/module.prop
	get_theme_name
	echo "Magisk${string_nowinstalled}${name}${string_themepack}${string_reboottomakeitwork}"
elif [ -d "/data/adb/modules/MIUIiconsplus" ]; then
	source /data/adb/modules/MIUIiconsplus/module.prop
	get_theme_name
	echo "Magisk${string_nowinstalled}${name}${string_themepack}"
fi

if [ -d "/data/adb/ksu/modules/MIUIiconsplus" ]; then
	source /data/adb/ksu/modules/MIUIiconsplus/module.prop
	get_theme_name
	echo "KernelSU${string_nowinstalled}${name}${string_themepack}"
fi
