#!/usr/bin/perl -w

# wiki_getpage wiki_page wiki_url [-d dest_path] [-un username] [-pw password]
#
# fetch a page wiki_page from wiki at url wiki_url and copies its content
# in directory dest_path or, if no path given, into working directory

use MediaWiki::API;

my $pagename = shift;
if (!defined($pagename)) {
    $pagename = 'Main_Page';
}
my $wikiurl = shift;
if (!defined($wikiurl)) {
    $wikiurl = 'http://darktrop.fr.cr/wiki/api.php';
}
my $option= shift;
my $destdir;
my $username;
my $password;
while (defined($option)) {
    if ($option eq "-d") {
	$destdir = shift;
    }
    if ($option eq "-un") {
	$username = shift;
    }
    if ($option eq "-pw") {
	$password = shift;
    }
    $option = shift;
}

my $mw = MediaWiki::API->new;
$mw->{config}->{api_url} = $wikiurl;
if ( defined($username) && defined($password) ) {
    $mw->login( { lgname => "$username", lgpassword => "$password" } );
}
my $page = $mw->get_page( { title => $pagename } );

my $content = $page->{'*'};

if (!defined($destdir)) {
    $destdir = "trash";
}

system("touch \'$destdir/$pagename\'");
system("echo \'$content\' > \'$destdir/$pagename\'");
