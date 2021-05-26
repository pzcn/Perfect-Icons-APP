if [ -e "$TOOLKIT/sh" ];then
exit
else
echo " 安装busybox"
echo
busybox="$TOOLKIT/busybox1"
ln -sf $busybox $TOOLKIT/busybox
$busybox --install -s $TOOLKIT
chmod -R 777 $TOOLKIT
fi