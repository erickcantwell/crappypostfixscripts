#!/usr/bin/perl

use strict;
use warnings;

use Net::LDAP;

my $ldaphost = "";
my $bind_dn  = "";
my $bind_pw  = "";
my $basedn   = "";

my $alias;
my @destinations;
my $answer;

my $ldap = Net::LDAP->new($ldaphost);

my $mesg = $ldap->bind( "$bind_dn", password => "$bind_pw");
$mesg->code && die "Couldn't connect: $mesg->error\n";

print "Enter alias:\n";
$alias = <STDIN>;
chomp($alias);

do {
    my $destination;

    print "Enter destination:\n";
    $destination = <STDIN>;
    chomp($destination);
    push(@destinations,$destination);

    print "Add more?[y\\n]\n";
    $answer = <STDIN>;
    chomp($answer);

} while ($answer eq 'y');

print "\nVerify the following information:\n";
print "Alias: $alias\n";
print "Destinations:\n";

foreach my $dest (@destinations) {
    print "\t$dest\n";
};

print "Is this correct?\n";
$answer = <STDIN>;
chomp($answer);

if ($answer eq 'y') {
    my $result = $ldap->add("cn=$alias,$basedn",
        attrs => [
            'name'        => $alias,
            'mail'        => $alias,
            'objectclass' => ['mailAlias'],
            'maildrop'    => \@destinations,
        ]
    );
    $result->code && warn "failed to add entry: ", $result->error ;
}

print "Alias created!\n";
$mesg = $ldap->unbind;
