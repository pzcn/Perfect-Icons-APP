#!/system/bin/sh
curl -skLJo "$TEMP_DIR/changelog.xml" https://miuiicons-generic.pkg.coding.net/icons/files/changelog2.xml?version=latest
cp -rf "$START_DIR/local-scripts/pic/push.png" "$TEMP_DIR/push.png"
cp -rf "$START_DIR/local-scripts/pic/update.png" "$TEMP_DIR/update.png"
cat >$TEMP_DIR/1.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8" ?>
<group>
<page html="https://iconsx.pedroz.eu.org/push.html"  icon="push.png">
<title>订阅新版本通知</title>
<desc>通过微信订阅后，有新版本会推送通知</desc>
</page>
<action icon="update.png">
<title>检查更新</title>
<set>source $START_DIR/local-scripts/misc/update_check.sh</set>
<desc sh="source local-scripts/misc/get_count.sh"/>
</action>
</group>
EOF
cat "$TEMP_DIR/changelog.xml" >> "$TEMP_DIR/1.xml"
echo "$TEMP_DIR/1.xml"