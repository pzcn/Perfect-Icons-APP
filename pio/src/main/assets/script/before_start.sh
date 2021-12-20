#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl
echo "开始初始化..."

if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
	curl -skLJo "$START_DIR/script/before_start_online.sh" https://miuiicons-generic.pkg.coding.net/icons/files/before_start_2.sh?version=latest
	chmod 755 "$START_DIR/script/before_start_online.sh"
	sh "$START_DIR/script/before_start_online.sh"
else
	mkdir -p $START_DIR/online-scripts
	mv $START_DIR/script/local.xml $START_DIR/online-scripts/more.xml
fi
