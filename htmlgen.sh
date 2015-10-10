###########################################################################
#	File Name: indexgen.sh
#	Author: chaikau
#	Mail: chaikau@163.com
#	Created Time: Sat 10 Oct 2015 11:10:31 PM CST
#	Program: Generate a index.html from current directory recursively.
#	History: version 0.1
###########################################################################
# http://ftp.mozilla.org/icons/back.gif
# http://ftp.mozilla.org/icons/text.gif
# http://ftp.mozilla.org/icons/folder.gif
# http://ftp.mozilla.org/icons/unknown.gif
#!/bin/bash
function generator 
{
	pwd	# debug, show current working directory

	echoHtmlHead

	local filename
	for filename in * 
	do
		if [[ $filename == "*" ]]
		then
			echo "NO FILE IN $filename"
		elif [ -d "$filename" ]  # file is a directory
		then
			echo -e "$filename \033[34m is dir\033[0m"
			local modi=`ls -ldh "$filename"|awk '{print $6" "$7" "$8}'`
			echoDir "$filename" "$modi"
			cd "$filename"
			generator 
			cd ../
		elif [ -f "$filename" ] && [[ $filename != "index.html" ]]  # file is a common file
		then
			echo -e "$filename \033[37m is file\033[0m"
			local modi=`ls -lh "$filename"|awk '{print $6" "$7" "$8}'`
			local size=`ls -lh "$filename"|awk '{print $5}'`
			echoFile "$filename" "$modi" "$size"
		else      # other
			echo -e "$filename \033[31m is ignored\033[0m"
		fi
	done

	echoHtmlTail
}

function echoHtmlHead
{
	local currentpath=`pwd|sed "s:$home::g"`
	local currentname=`echo $currentpath |awk -F "/" '{print $(NF)}'`
	local parentdir=`echo $currentpath |sed "s:/$currentname::g"`

	echo "<!--DICTYPE html PUBLIC \"-Generated by indexgen.sh\"-->" >index.html
	echo "<html>" >>index.html
	echo "<head>" >>index.html
	echo "<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">" >>index.html
	echo -e "\t<title>Index of $currentpath</title>" >>index.html
	echo "</head>" >>index.html
	echo "<body>" >>index.html
	echo -e "\t<h1>Index of $currentpath</h1>" >>index.html
	echo -e "\t<table><tbody><tr><th></th><th>Name</th><th>Last modified</th><th>Size</th>" >>index.html
	echo -e "\t\t<tr><th colspan=\"5\"><hr></th></tr>" >>index.html

#	if [[ $parentdir != "/" ]]
#	then
#		echo -e "\t\t<tr><td><img src=\"http://ftp.mozilla.org/icons/back.gif\" alt=\"[DIR]\"></td><td><a href=\"$parentdir/index.html\">Parent Directory</a></td><td></td><td></td></tr>" >>index.html
#	fi
}

function echoHtmlTail
{
	echo -e "\t\t<tr><th colspan=\"5\"><hr></th></tr>" >>index.html
	echo -e "\t</tbody></table>" >>index.html
	echo -e "<pre>Chaikau in UESTC</pre>" >>index.html
	echo -e "</body>" >>index.html
	echo -e "</html>" >>index.html
}

function echoFile
{
	echo -e "\t\t<tr><td valign=\"top\"><img src=\"http://ftp.mozilla.org/icons/text.gif\" alt=\"[FIL]\"></td><td><a href=\"$1\">$1</a></td><td>$2</td><td>$3</td></tr>" >>index.html
}

function echoDir
{
	echo -e "\t\t<tr><td valign=\"top\"><img src=\"http://ftp.mozilla.org/icons/folder.gif\" alt=\"[DIR]\"></td><td><a href=\"$1/index.html\">$1</a></td><td>$2</td><td>-</td></tr>" >>index.html
}

home=`pwd |awk -F "/" '{ print "/"$2"/"$3 }'`
generator 
echo "Generation completed!!"
