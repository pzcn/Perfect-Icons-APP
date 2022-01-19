system_check(){
var_miui_version="`getprop ro.miui.ui.version.code`"
if [ $ANDROID_SDK -lt 29 ] ;then
echo 0
elif [ $var_miui_version -lt 10 ] ;then
echo 0
else
echo 1
fi
}

if [ "$1" == noroot ]; then 
system_check
else
	if [ $ROOT_PERMISSION == true ]; then
		system_check
	else
		echo 0
	fi
fi	


