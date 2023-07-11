#!/system/bin/sh

# 参数说明
# $1 脚本路径

# 将要执行的具体脚本，执行 executor.sh 时传入，如 ./executor.sh test.sh
script_path="$1"

# 全局变量 - 会由脚本引擎为其赋值
# 框架并不需要这些变量，如果你不需要可以将其删除
# 如有需要，你也可以增加一些自己的变量定义
# 但这个文件每次运行脚本都会被执行，不建议写太复杂的过程
export EXECUTOR_PATH="$({EXECUTOR_PATH})"
export START_DIR="$({START_DIR})"
export TEMP_DIR="$({TEMP_DIR})"
export ANDROID_UID="$({ANDROID_UID})"
export ANDROID_SDK="$({ANDROID_SDK})"
export SDCARD_PATH="$({SDCARD_PATH})"
export BUSYBOX="$({BUSYBOX})"
export MAGISK_PATH="$({MAGISK_PATH})"
export PACKAGE_NAME="$({PACKAGE_NAME})"
export PACKAGE_VERSION_NAME="$({PACKAGE_VERSION_NAME})"
export PACKAGE_VERSION_CODE="$({PACKAGE_VERSION_CODE})"
export APP_USER_ID="$({APP_USER_ID})"
export LANGUAGE="$({LANGUAGE})"

# ROOT_PERMISSION 取值为：true 或 false
export ROOT_PERMISSION=$({ROOT_PERMISSION})

# 修复非ROOT权限执行脚本时，无法写入默认的缓存目录 /data/local/tmp
export TMPDIR="$TEMP_DIR"

# toolkit工具目录
export TOOLKIT="$({TOOLKIT})"
# 添加toolkit添加为应用程序目录
if [[ ! "$TOOLKIT" = "" ]]; then
    # export PATH="$PATH:$TOOLKIT"
    PATH="$TOOLKIT:$PATH"
fi

# 安装busybox完整功能
if [[ -f "$TOOLKIT/install_busybox.sh" ]]; then
    sh "$TOOLKIT/install_busybox.sh"
fi

# 将busybox的tar功能替换为toybox的
if [[ -f "$TOOLKIT/tar" ]]; then
    rm $TOOLKIT/tar
    ln -s $TOOLKIT/toybox $TOOLKIT/tar
fi

# 判断是否有指定执行目录，跳转到起始目录
if [[ "$START_DIR" != "" ]] && [[ -d "$START_DIR" ]]
then
    cd "$START_DIR"
fi

# 删除旧的toolkit文件夹
if [[ -d "${START_DIR}/script/toolkit" ]]; then
    rm -rf ${START_DIR}/script/toolkit
fi

# 语言文件
if [ -f "$START_DIR/theme_files/beta_config" ]; then
    source $START_DIR/theme_files/beta_config
    if [ $beta = 1 ]; then
        extract_dir=$START_DIR/online-scripts
    else
        extract_dir=$START_DIR/local-scripts
    fi
else
    extract_dir=$START_DIR/local-scripts
fi

if [ $LANGUAGE == "zh-rCN" ]; then
  [ -f "$extract_dir/misc/string.ini" ] && source $extract_dir/misc/string.ini
else
  [ -f "$extract_dir/misc/stringeng.ini" ] && source $extract_dir/misc/stringeng.ini
fi

# 运行脚本
if [[ -f "$script_path" ]]; then
    chmod 755 "$script_path"
    # sh "$script_path"     # 2019.09.02 before
    source "$script_path"   # 2019.09.02 after
else
    echo "${script_path} 已丢失" 1>&2
fi