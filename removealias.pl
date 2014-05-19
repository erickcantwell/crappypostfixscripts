#!/usr/bin/perl

use strict;
use warnings;

use Net::LDAP;
use YAML qw(LoadFile);

# Load configuration
my $settings = LoadFile('../../ldapconf.conf');

my $ldap = Net::LDAP->new($settings->{'aliases'}->{'host'});
 
my $mesg = $ldap->bind($settings->{'aliases'}->{'bind_dn'}, password => $settings->{'aliases'}->{'bind_pw'});
$mesg->code && die print "Could not connect to ldap: ".$mesg->error."\n";

print "Alias to remove:\n";
my $alias = <STDIN>;
chomp($alias);

my $result = $ldap->delete("cn=$alias,$settings->{'aliases'}->{'base_dn'}");

$result->code && warn "failed to remove entry: ".$result->error."\n";

print "Alias removed!\n";
$mesg = $ldap->unbind;
