#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl
echo "开始初始化..."

if [ `curl -L https://miuiicons-generic.pkg.coding.net/icons/files/network` ]; then
	curl -skLJo "$START_DIR/script/before_start_online.sh" https://miuiicons-generic.pkg.coding.net/icons/files/before_start_2.sh?version=latest
	chmod 755 "$START_DIR/script/before_start_online.sh"
	sh "$START_DIR/script/before_start_online.sh"
else
	rm -rf $START_DIR/online-scripts
	mkdir -p $START_DIR/online-scripts
	cp $TOOLKIT/local.xml $START_DIR/online-scripts/more.xml
fi
