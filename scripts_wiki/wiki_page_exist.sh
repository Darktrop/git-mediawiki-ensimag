#!/bin/sh

#usage wiki_page_exist <page_name> <wiki_url>
#Exit with error code 1 if and only if the page <page_name> is not on <wiki_url>

#/!\ to complete ...

mkdir tmp_test
perl -e wiki_getpage.pl $1 $2 -d ./tmp_test

if find ./tmp_test/ -name $1 -type f; then
	rm -rf tmp_test
else
	echo "file $1 not found on wiki $2"
	exit 1;
fi

