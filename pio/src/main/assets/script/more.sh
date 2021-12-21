#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl
source theme_files/beta_config

if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
    if [[ beta = 1 ]]; then
        extract_dir="$START_DIR/online-scripts"
    else
        extract_dir="$START_DIR/local-scripts"
    fi
    if [[ -f "$extract_dir/more.xml" ]]; then
        echo "$extract_dir/more.xml"
    fi
fi



    