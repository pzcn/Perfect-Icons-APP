if [ -s theme_files/iconscount.txt ]; then
	var=`cat theme_files/iconscount.txt`
	echo ${string_iconscount}$var
else
	echo ${string_checkupdate}
fi