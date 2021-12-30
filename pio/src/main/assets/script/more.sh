#!/system/bin/sh
[[ $(arch) == "aarch64" ]] || exit 
chmod -R 777 $TOOLKIT/curl
source theme_files/beta_config

if [ "`curl -I -s --connect-timeout 1 http://connect.rom.miui.com/generate_204 -w %{http_code} | tail -n1`" == "204" ]; then

    if [ -z $language ]; then
        page_dir=$extract_dir
    else
        page_dir=$extract_dir/eng
    fi
    
    if [[ -f "$page_dir/more.xml" ]]; then
        echo "$page_dir/more.xml"
    fi
fi
