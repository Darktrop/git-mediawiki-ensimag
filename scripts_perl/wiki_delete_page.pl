#!/usr/bin/perl

#wiki_delete_page <wiki_url> <page_name> <login> <passwd>
#delete the page <page_name> from the wiki with the url <wiki_url>.
#using the session : <login> + <passwd>
#by default behavior : wiki_delete page http://darktrop.fr.cr/wiki/api.php Petit_essai Ensimag-git bouteilledu38

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

