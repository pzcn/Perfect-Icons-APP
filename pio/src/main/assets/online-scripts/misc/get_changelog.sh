#!/system/bin/sh
curl -skLJo "$TEMP_DIR/changelog.xml" https://miuiicons-generic.pkg.coding.net/icons/files/changelog.xml?version=latest
echo "$TEMP_DIR/changelog.xml"