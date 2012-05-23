#!/bin/sh

#usage : git_exist rep_name file_name
#behavior : if file_name is not present in rep_name or in his subdirectory, the program exit with an error

result=$(find $1 -type f -name $2)

if ! echo $result | grep -q $2; then
	echo "test failed : file $1/$2 does not exist"
	exit 1;
fi
