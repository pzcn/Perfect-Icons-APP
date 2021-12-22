export CLASSPATH=$START_DIR/local-scripts/misc/am.apk
unset LD_LIBRARY_PATH LD_PRELOAD
exec /system/bin/app_process / com.termux.termuxam.Am "$@"
