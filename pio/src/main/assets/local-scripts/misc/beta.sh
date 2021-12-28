echo "beta=$state" > theme_files/beta_config

if [[ -z $language ]]; then
	if [ $state = 1 ]; then
		echo '- 欢迎加入Beta计划'
		echo '- 以后在app启动时，将联网获取最新版本的脚本'
		echo '- 您将第一时间体验最新的功能，但是稳定性可能会降低'
		echo '- 重新打开APP即可体验'
	else
		echo '- 您已退出Beta计划'
		echo '- app将使用内置脚本'
		echo '- 请重启应用'
	fi
else
	if [ $state = 1 ]; then
		echo '- Welcome to try out beta version.'
		echo '- The scripts will automatically update itself when you launch the app.'
		echo '- You will experience the latest features, but with lower stability.'
		echo '- Restart the app to switch to beta version.'
	else
		echo '- You have switched to release version.'
		echo '- Now will use built-in scripts.'
		echo '- Please restart the app.'
	fi
fi
