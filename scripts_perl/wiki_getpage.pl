#!/usr/bin/perl -w

# wiki_getpage wiki_url wiki_page [dest_path]
#
# fetch a page wiki_page from wiki at url wiki_url and copies its content
# in directory dest_path or, if no path given, into working directory

use MediaWiki::API;

my $wikiurl = $ARGV[0];
if (!defined($wikiurl)) {
    $wikiurl = 'http://darktrop.fr.cr/wiki/api.php';
}
my $pagename = $ARGV[1];
if (!defined($pagename)) {
    $pagename = 'Main_Page';
}
my $destdir = $ARGV[2];
if (!defined($destdir)) {
    $destdir = 'trash';
}

my $mw = MediaWiki::API->new;
$mw->{config}->{api_url} = $wikiurl;
my $page = $mw->get_page( { title => $pagename } );

my $content = $page->{'*'};

system("touch \'$destdir/$pagename\'");
system("echo \'$content\' > \'$destdir/$pagename\'");
