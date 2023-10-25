cleanall() {
if [[ -d "${START_DIR}/downloader" ]]; then
  rm -rf ${START_DIR}/downloader/*
fi
if [[ -d "${START_DIR}/kr-script" ]]; then
  rm -rf ${START_DIR}/kr-script/*
fi
if [[ -d "${TEMP_DIR}" ]]; then
  rm -rf ${TEMP_DIR}/*
fi
}

cd ${START_DIR}/theme_files
rm -rf *.tar.xz
rm -rf *.ini
rm -rf hwt
rm -rf miui
rm -rf $SDCARD_PATH/Android/data/dev.miuiicons.pedroz/files/download
cd ${START_DIR}

echo $string_cachecleaned
echo $string_willredownloadres
cleanall