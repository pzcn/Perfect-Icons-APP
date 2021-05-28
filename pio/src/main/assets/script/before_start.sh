#!/system/bin/sh
echo "APP需要连接网络才可以正常使用..."
chmod -R 777 $TOOLKIT/curl
echo "开始初始化..."
curl -skLJo "$START_DIR/script/before_start_online.sh" https://miuiicons-generic.pkg.coding.net/icons/files/before_start.sh?version=latest
chmod 755 "$START_DIR/script/before_start_online.sh"
sh "$START_DIR/script/before_start_online.sh"