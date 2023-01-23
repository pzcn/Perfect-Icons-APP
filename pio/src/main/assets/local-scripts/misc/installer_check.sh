system_check() {
	var_miui_version="$(getprop ro.miui.ui.version.code)"
	if [ $ANDROID_SDK -lt 29 ]; then
		[ "$1" == norootcheck ] && echo 1 || echo 0
	elif [ $var_miui_version -lt 10 ]; then
		[ "$1" == norootcheck ] && echo 1 || echo 0
	else
		[ "$1" == norootcheck ] && echo 0 || echo 1
	fi
}

if [ "$1" == noroot ]; then
	system_check
elif [ "$1" == kernelsu ]; then
	if [ -n "$(cat /proc/kallsyms | grep ksu_)" ]; then
		system_check
	else
		echo 0
	fi
elif [ "$1" == magisk ]; then
	if [ $(magisk -V) -ge 20400 ]; then
		system_check
	else
		echo 0
	fi
elif [ "$1" == both ]; then
	if [ $(magisk -V) -ge 20400 ] && [ -n "$(cat /proc/kallsyms | grep ksu_)" ]; then
		echo 1
	else
		echo 0
	fi
elif [ "$1" == notboth ]; then
	if [ $(magisk -V) -ge 20400 ] && [ -n "$(cat /proc/kallsyms | grep ksu_)" ]; then
		echo 0
	else
		echo 1
	fi
else
	if [ $ROOT_PERMISSION == true ]; then
		system_check $1
	else
		[ "$1" == norootcheck ] && echo 1 || echo 0
	fi
fi
