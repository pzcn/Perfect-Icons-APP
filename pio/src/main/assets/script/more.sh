#!/system/bin/sh
chmod -R 777 $TOOLKIT/curl
source theme_files/beta_config

if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then
    if [[ $beta = 1 ]]; then
        extract_dir="$START_DIR/online-scripts"
    else
        extract_dir="$START_DIR/local-scripts"
    fi
    if [ "$(getprop persist.sys.locale)" = "zh-CN" ]; then
        page_dir=$extract_dir
    else
        page_dir=$extract_dir/eng
    fi
    if [[ -f "$page_dir/more.xml" ]]; then
        echo "$page_dir/more.xml"
    fi
fi
