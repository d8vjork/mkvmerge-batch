#!/bin/bash 

system="$(uname -s)"
if [ $system == "Darwin" ]; then
    binary="/Applications/MKVToolNix*.app/Contents/MacOS/mkvmerge"
elif [ $system == "Linux" ]; then
    binary="mkvmerge"
else
	binary="path/to/mkvmerge"
fi

read -p "Specify the MKVMerge binary absolute path [${binary}]: " userBinary

if [ ! $userBinary ]; then
	userBinary=$binary
fi

read -p "Specify language to add to [e.g. spa/sp, eng/en, etc...]: " language

if [ ! $language ]; then
	echo "You must specify a language"
	exit 1
fi

mkdir merged

IFS=$'\n'
for f in $(find . -name "*.${language}.ass")
do
	filename="${f##*/}"
	filename="${filename%%.*}"
	cmd="${userBinary} --output 'merged/${filename}.mkv' '${filename}.mkv' --language 0:${language} '(' '${filename}.${language}.ass' ')'"

	for fi in $(find . -name '*.ttf')
	do
		cmd+=" --attach-file '${fi}'"
	done

	eval $cmd
done