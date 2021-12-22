echo "beta=$state" > theme_files/beta_config 

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