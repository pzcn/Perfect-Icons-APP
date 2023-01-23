if [ -d "/data/adb/modules_update/MIUIiconsplus_addon" ]; then
	echo 1
elif [ -d "/data/adb/modules/MIUIiconsplus_addon" ]; then
	echo 1
else
	echo 0
fi
