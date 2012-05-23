#!/usr/bin/perl -w

# wiki_editpage <wiki_page> <wiki_content> <wiki_append> <wiki_url> <wiki_login> <wiki_pass>
#
# Edit a page <wiki_page> at url <wiki_url> with content <wiki_content>
# Connect with Login <wiki_login> and password <wiki_pass>
#
# If <wiki_append> == true : append
#
# If page doesn't exist : it creates page

use MediaWiki::API;

my $wiki_page = $ARGV[0];
if (!defined($wiki_page)) {
	print("Name of page needed\n");
	die;
}

my $wiki_content = $ARGV[1];
if (!defined($wiki_content)) {
	print("Content of page needed\n");
	die;
}

my $wiki_append = $ARGV[2];
my $append = 0;
if (defined($wiki_append) && $wiki_append eq 'true') {
	$append=1;
}
 
my $wiki_url = $ARGV[3];
if (!defined($wiki_url)) {
	$wiki_url = 'http://localhost/wiki/api.php';
}

my $wiki_login = $ARGV[4];
if (!defined($wiki_login)) {
	$wiki_login = 'Ensimag-git';
}
	
my $wiki_password = $ARGV[5];
if (!defined($wiki_password)) {
	$wiki_pass = 'bouteilledu38'; 
}

my $mw = MediaWiki::API->new;
$mw->{config}->{api_url} = $wiki_url;
$mw->login({lgname => $wiki_login, lgpassword => $wiki_pass });
my $previous_text ="";

if ($append) {
	my $ref = $mw->get_page( { title => $wiki_page } );
	$previous_text = $ref->{'*'};
}
if (!defined($previous_text)) {
	$previous_text="";
}
my $text = $previous_text."\n\n".$wiki_content;

$mw->edit( { action => 'edit', title => $wiki_page, text => "$text"} );

