### auto updating git repository

# sh edit.sh 或者双击 或者启动操作界面
# sh edit.sh *.apk 启动命令行修改方式
# sh edit.sh -f 刷新
p1=$1


if [ $# -eq 0 ]; then
    nohup java -jar apkParser.jar "editFrame" "editFrame" > ../log.txt 2>&1 &
    exit 1
elif [ ${p1}x = "-f"x ]; then
    git add -A && git commit -m "edit updateContent" && git push origin master
    exit 1
elif [[ ${p1##*.} != "apk" ]]; then
	echo "USAGE: sh $0 appName"
	exit 1
else
	echo -e "请输入更新内容(\033[31m换行以空格代替，Enter结束\033[0m)："
	read updateContent
fi
#if [[ -z $result ]]; then
#	echo "Your repository is clearly!"
	#git pull origin master
	
	
#else
#	echo "Your repository is not clear! Please make sure you have commit all changes!!!"
#fi
echo "更新内容："$updateContent
echo "是否确认更新？输入N/n取消，其他任意键继续更新"
read cmd

if [ $cmd == "N" -o $cmd == "n" ];then
	echo "取消编辑更新内容"
	exit 1
fi

java -jar apkParser.jar "edit:" ${p1##*/} $updateContent

git add -A && git commit -m "edit updateContent" && git push origin master

echo "编辑完成，请按任意键退出"
read -n 1
