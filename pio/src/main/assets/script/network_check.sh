#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl
if [[ $(arch) == "aarch64" ]];then
echo '- 设备架构支持，检查网络情况：'
echo '- 网络连接情况：'
if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
    echo '- 成功'
else
    echo '- 失败'
fi

echo '- 服务器连接情况：'
if [ "`curl -I -s --connect-timeout 1 https://miuiicons-generic.pkg.coding.net/icons/files/check?version=latest -w %{http_code} | tail -n1`" == "200" ]; then
    echo '- 成功'
else
    echo '- 失败'
fi  

else
    echo "- 您的设备架构为：$(arch)，不受支持"
fi