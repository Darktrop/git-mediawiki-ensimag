#!/bin/sh
#
# git-submodules.sh: add, init, update or list git submodules
#
# Copyright (c) 2012 Equipe ensimag test_git_mediawiki
# Format : delete_page <wiki_@> <file_to_delete>

wiki_delete_page(){
	echo "$1"
	echo "$2"
	perl -e '
		use MediaWiki::API;
		my $mw = MediaWiki::API->new({api_url => '\'$1\''});
		$mw->login({lgname => '\'Ensimag-git\'', lgpassword =>'\'bouteilledu38\'' });
		$mw->edit({
		action => '\'delete\'',
		title => '\'$2\''})
		|| die $mw->{error}->{code} . ": " . $mw->{error}->{details};'
}

export -f wiki_delete_page

wiki_delete_page $1 $2
