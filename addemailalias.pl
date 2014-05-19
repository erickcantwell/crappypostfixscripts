#!/usr/bin/perl

use strict;
use warnings;

use Net::LDAP;
use YAML qw(LoadFile);

# Load configuration
my $settings = LoadFile('../../ldapconf.conf');

my $alias;
my @destinations;
my $answer;

my $ldap = Net::LDAP->new($settings->{'aliases'}->{'host'});

my $mesg = $ldap->bind($settings->{'aliases'}->{'bind_dn'}, password => $settings->{'aliases'}->{'bind_pw'});
$mesg->code && die "Couldn't connect: ".$mesg->error."\n";

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
    my $result = $ldap->add("cn=$alias,$settings->{'aliases'}->{'base_dn'}",
        attrs => [
            'name'        => $alias,
            'mail'        => $alias,
            'objectclass' => ['mailAlias'],
            'maildrop'    => \@destinations,
        ]
    );
    $result->code && warn "failed to add entry: ".$result->error."\n";
}

print "Alias created!\n";
$mesg = $ldap->unbind;
