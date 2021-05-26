#!/system/bin/sh
echo "APP需要连接网络才可以正常使用..."
[ -f $TOOLKIT/curl ] && chmod -R 777 $TOOLKIT/curl
 command -v curl >/dev/null 2>&1 || ( echo "缺少curl命令，开始下载..." ; $TOOLKIT/wget -q "https://miuiicons-generic.pkg.coding.net/icons/files/curl?version=latest" -O $TOOLKIT/curl 2>/dev/null ; chmod -R 777 $TOOLKIT/curl )
echo "开始初始化..."
curl -skLJo "$START_DIR/script/before_start_online.sh" https://miuiicons-generic.pkg.coding.net/icons/files/before_start.sh?version=latest
chmod 755 "$START_DIR/script/before_start_online.sh"
sh "$START_DIR/script/before_start_online.sh"