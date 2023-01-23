if [ $1 = list ]; then
	test=$(head -n 1 theme_files/denylist)
	if [ $test = all ]; then
		echo 所有APP
	elif [ "$test" = "" ]; then
		echo 禁用列表为空
	else
		cat theme_files/denylist
	fi
fi

if [ $1 = sel ]; then
	if [ -s theme_files/denylist ]; then
		cat theme_files/denylist
	fi
fi
