#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl

echo '- 网络连接情况：'
if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
    echo '- 成功'
else
    echo '- 失败'
fi

echo '- 服务器连接情况：'
if [ "`curl -I -s --connect-timeout 1 https://miuiiconseng-generic.pkg.coding.net/iconseng/engtest/test?version=latest -w %{http_code} | tail -n1`" == "200" ]; then
    echo '- 成功'
else
    echo '- 失败'
fi  