### auto updating git repository
#for file in `ls apps`;
#	do
#		if [ "apk" = ${file##*.} ]; then
#			echo $file
#			echo `java -jar apkParser.jar apps"/"$file`
#		fi
#	done
result=`git add -A && git status |grep "apps/"`
commitor=`git config --list |grep "user.name"|sed 's/.*=//g'`

#echo "result="$result

if [[ -z $result ]]; then
	echo "Your repository is clearly!"
	git pull origin main
else
	##stash current repository
	git stash
	## update git repository to newly
	git pull origin main
	## reset stash
	git stash pop stash@{0}
	
	## list changes
	#result=`git add -A && git status |grep "apps/"`
	#echo "result = "$result
	#result=($result)

	for file in `git add -A && git status |grep "apps/"`;
		do
			if [ $file = "file:" -o $file = "deleted:" -o $file = "renamed:" -o $file = "modified:" -o ${file##*.} = "apk" ]; then
				if [ $file = "file:" -o $file = "deleted:" -o $file = "renamed:" -o $file = "modified:" ];then
					firstCmd=$file
					secondCmd=""
				else
					if [ $firstCmd = "file:" -o $firstCmd = "modified:" ]; then
						if [ $firstCmd = "file:" ]; then
							secondCmd=$file
							echo "create new file : "${file##*/}
							java -jar apkParser.jar $firstCmd $file $commitor
						else
							echo "modified file : " ${file##*/}
							java -jar apkParser.jar "renamed:" ${file##*/} $file $commitor
						fi
					elif [ $firstCmd = "renamed:" ]; then
						if [ -z $secondCmd ]; then
							secondCmd=$file
						else
							echo "renamed file : "${secondCmd##*/}" to "${file##*/}
							java -jar apkParser.jar $firstCmd ${secondCmd##*/} $file $commitor
						fi
					else
						echo "deleted file :"${file##*/} 
						java -jar apkParser.jar $firstCmd ${file##*/}
					fi
				fi
			fi
		done
		
	git add -A && git commit -m "upload" && git push origin main
fi

echo ""
echo ""
echo "更新成功，请按任意键退出"
