if [ ! -e "$TOOLKIT/sh" ];then
echo "Installing busybox..."
busybox="$TOOLKIT/busybox1"
ln -sf $busybox $TOOLKIT/busybox
$busybox --install -s $TOOLKIT
chmod -R 777 $TOOLKIT
fi
if [ ! -e "$TOOLKIT/git-remote-https" ];then
	ln -sf $TOOLKIT/git-remote-http $TOOLKIT/git-remote-https
fi
