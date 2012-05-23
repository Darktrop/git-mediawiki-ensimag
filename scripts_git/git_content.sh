#!/bin/sh

#usage : git_content file_1 file_2
#behavior : if file_1 and file_2 do not match, the program exit with an error.

result=$(diff $1 $2)

if  echo $result | grep -q *; then
	echo "test failed : file $1 and $2 do not match"
	exit 1;
fi
