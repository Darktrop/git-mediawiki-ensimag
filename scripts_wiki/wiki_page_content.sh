#!/bin/sh

#usage wiki_page_content <file> <page_name> <wiki_url>
#
#Exit with error code 1 if and only if the content of
#<page_name> and <file> do not match.

#export PATH=$PATH:$HOME/git-mediawiki-ensimag/scripts_wiki
#export PATH=$PATH:$HOME/git-mediawiki-ensimag/scripts_git

rm -rf ./tmp_test
mkdir ./tmp_test
wiki_getpage.pl $2 $3 -d ./tmp_test

if find ./tmp_test -name $2 -type f | grep -q $2; then
	git_content.sh $1 ./tmp_test/$2
	rm -rf ./tmp_test
else
	rm -rf ./tmp_test
	echo "ERROR : file $2 not found on wiki $3"
	exit 1;
fi
