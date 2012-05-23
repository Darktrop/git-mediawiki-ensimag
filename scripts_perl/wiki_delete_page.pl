#!/usr/bin/perl

use MediaWiki::API;

my $wikiurl = $ARGV[0];
if (!defined($wikiurl)) {
    $wikiurl = 'http://darktrop.fr.cr/wiki/api.php';
}
my $pagename = $ARGV[1];
if (!defined($pagename)) {
    $pagename = 'Petit_essai';
}
my $login = $ARGV[2];
if (!defined($login)) {
    $login = 'Ensimag-git';
}
my $passwd= $ARGV[3];
if (!defined($passwd)) {
    $passwd = 'bouteilledu38';
}


my $mw = MediaWiki::API->new({api_url => $wikiurl});
#connecting...
$mw->login({lgname => $login, lgpassword => $passwd });

$mw->edit({
	action => 'delete',
	title => $pagename})
|| die $mw->{error}->{code} . ": " . $mw->{error}->{details};

