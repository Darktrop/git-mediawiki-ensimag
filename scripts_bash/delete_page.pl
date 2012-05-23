#!/usr/bin/perl

use MediaWiki::API;
my $mw = MediaWiki::API->new({api_url => 'http://darktrop.fr.cr/wiki/api.php'});
$mw->login({lgname => 'Ensimag-git', lgpassword =>'bouteilledu38' });
$mw->edit({
	action => 'delete',
	title => 'Petit_essai'})
|| die $mw->{error}->{code} . ": " . $mw->{error}->{details};

