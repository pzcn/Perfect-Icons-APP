downloader() {
    local downloadUrl="$1"
    local md5="$2"
    downloader_result="" # 清空变量，后续此变量将用于存放文件下载后的存储路径
    source $START_DIR/theme_files/download_config

    echo "- 需要下载$theme_name资源... "

    [ $file_size ] || { echo "× 抱歉，在线资源临时维护中，请切换其他主题或稍后再试。" && rm -rf $TEMP_DIR/* 2>/dev/null&& exit 1; }

    echo "- 本次需下载 $(printf '%.1f' `echo "scale=1;$file_size/1048576"|bc`) MB"
    if [ $curlmode == 0 ]; then
    echo "- 开始下载... "
    # 检查是否下载过相同MD5的文件，并且文件文件还存在
    # 如果存在相同md5的文件，直接输出其路径，并跳过下载
    # downloader/path 目录存储的是此前下载过的文件路径，以md5作为区分
    local hisotry="$START_DIR/downloader/path/$md5"
    if [[ -f "$hisotry" ]]; then
        local abs_path=`cat "$hisotry"`
        if [[ -f "$abs_path" ]]; then
            # 此前下载的文件还在，检查md5是否一致
            local local_file=`md5sum "$abs_path"`
            if [[ "$local_file" = "$md5" ]]; then
                downloader_result="$abs_path"
                return
            fi
        fi
    fi

    local task_id=`cat /proc/sys/kernel/random/uuid`
    # intent参数
    # --es downloadUrl 【url】下载路径
    # --ez autoClose autoClose 【true/false】 是否下载完成后自动关闭界面
    # --es taskId 【taskId】下载任务的唯一标识 用于跟踪进度

    activity="$PACKAGE_NAME/com.projectkr.shell.ActionPageOnline"
    sh $START_DIR/online-scripts/misc/downloaduiactivity.sh start -a android.intent.action.MAIN -n "$activity" --es downloadUrl "$downloadUrl" --ez autoClose true --es taskId "$task_id" 1 > /dev/null

    # 等待下载完成
    # downloader/status 存储的是所有下载任务的进度
    # 0~100 为下载进度百分比，-1表示创建下载任务失败
    local task_path="$START_DIR/downloader/status/$task_id"
    local result_path="$START_DIR/downloader/result/$task_id"
    while [[ '1' = '1' ]]
    do
        if [[ -f "$task_path" ]]; then
            local status=`cat "$task_path"`
            if [[ "$status" = 100 ]] || [[ -f "$result_path" ]]; then
                echo "progress:[$status/100]"
                break
            elif [[ "$status" -gt 0 ]]; then
                echo "progress:[$status/100]"
                # echo '已下载：'$status
            elif [[ "$status" = '-1' ]]; then
                echo '文件下载失败' 1>&2
                # 退出
                return 10
            fi
        fi
        sleep 1
    done

    # 再次检查md5，以便校验下载后的文件md5是否一致
    if [[ "$md5" != "" ]]; then
        local hisotry="$START_DIR/downloader/path/$md5"
        if [[ -f "$hisotry" ]]; then
            downloader_result=`cat "$hisotry"`
        else
            echo '文件下载损坏，请重新尝试下载' && rm -rf $TEMP_DIR/* >/dev/null && exit 1;
        fi
    else
        downloader_result=`cat $START_DIR/downloader/result/$task_id`
    fi
    else
    echo "- 开始以兼容模式下载... "
    curlfile=$TEMP_DIR/$var_theme.tar.xz
    curl -skLJo "$curlfile" "$downloadUrl"
    md5_loacl=`md5sum $curlfile|cut -d ' ' -f1`
    if [[ "$md5" != "$md5_loacl" ]]; then
        echo '文件下载损坏，请重新尝试下载' 1>&2
    fi
    downloader_result=$curlfile
    fi

    if [[ ! "$downloader_result" = "" ]]; then
    echo '- 下载完成'
    else
    echo '× 下载失败' && rm -rf $TEMP_DIR/* >/dev/null && exit 1;
    fi
}