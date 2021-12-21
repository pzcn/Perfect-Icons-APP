#!/system/bin/sh
extract_dir="$START_DIR/online-scripts"

if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
    if [[ -f "$extract_dir/more.xml" ]]; then
        echo "$extract_dir/more.xml"
    fi
else
    if [[ -f "$extract_dir/local.xml" ]]; then
        echo "$extract_dir/local.xml"
    fi"
fi


