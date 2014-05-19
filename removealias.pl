#!/usr/bin/perl

use strict;
use warnings;

use Net::LDAP;

my $ldaphost = "";
my $bind_dn  = "";
my $bind_pw  = "";
my $base_dn  = "";

my $ldap = Net::LDAP->new($ldaphost);
 
my $mesg = $ldap->bind("$bind_dn", password => "$bind_pw");
$mesg->code && die print "Could not connect to ldap: $mesg->error\n";

print "Alias to remove:\n";
my $alias = <STDIN>;
chomp($alias);

my $result = $ldap->delete("cn=$alias,$basedn"); 

$result->code && warn "failed to remove entry: ", $result->error ;

print "Alias removed!\n";
$mesg = $ldap->unbind;
