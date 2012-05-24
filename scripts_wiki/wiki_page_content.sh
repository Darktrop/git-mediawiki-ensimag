#!/bin/sh

#usage wiki_page_content <file> <page_name> <wiki_url>
#
#Exit with error code 1 if and only if the content of
#<page_name> and <file> do not match.

mkdir ./tmp_test
perl -e './wiki_getpage.pl '$2 $3 -d ./tmp_test

if find ./tmp_test -name $2 -type f; then
	git_content.sh $1 ./tmp_test/$2
	rm -rf ./tmp_test
else
	echo "file $2 not found on wiki $3"
	exit 1;
fi


