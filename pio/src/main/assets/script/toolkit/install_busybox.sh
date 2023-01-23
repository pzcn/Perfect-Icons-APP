version=20230123
busybox_install() {
	rm -rf $TOOLKIT/*
	cp -rf $toolkit_dir/* $TOOLKIT
	ln -sf $TOOLKIT/busybox1 $TOOLKIT/busybox
	$TOOLKIT/busybox1 --install -s $TOOLKIT
	echo $version >>$TOOLKIT/busybox.version
	chmod -R 777 $TOOLKIT
}

if [ ! -e "$TOOLKIT/sh" ]; then
	echo "Installing busybox..."
	busybox_install
fi

if [ -f $TOOLKIT/busybox.version ]; then
	if [ "$version" -gt $(cat "$TOOLKIT/busybox.version") ]; then
		echo "Updating busybox..."
		busybox_install
	fi
else
	echo "Updating busybox..."
	busybox_install
fi

if [ ! -e "$TOOLKIT/git-remote-https" ]; then
	ln -sf $TOOLKIT/git-remote-http $TOOLKIT/git-remote-https
fi
