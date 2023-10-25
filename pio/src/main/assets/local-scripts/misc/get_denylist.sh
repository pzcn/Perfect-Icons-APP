if [ $1 = list ]; then
	test=$(head -n 1 theme_files/denylist)
	if [ $test = all ]; then
		echo $string_allapp
	elif [ "$test" = "" ]; then
		echo $string_disablelistempty
	else
		cat theme_files/denylist
	fi
fi

if [ $1 = sel ]; then
	if [ -s theme_files/denylist ]; then
		cat theme_files/denylist
	fi
fi
