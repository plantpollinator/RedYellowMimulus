#!/usr/bin/perl -w
use strict;

my $infile = $ARGV[0];
my $outfile = $infile . ".parsed.tsv";
open(IN,$infile) || die "Could not open $infile for reading: $!\n";
open(OUT,">$outfile") || die "Could not open $outfile for writing: $!\n";
print OUT "RT\tArea\tHit1\tHit1CAS\tHit1Formula\tHit1Match\tHit2\tHit2CAS\tHit2Formula\tHit2Match\tHit3\tHit3CAS\tHit3Formula\tHit3Match\n";

my $originalsep = $/;
undef $/;
chomp(my $alldata = <IN>);
$/ = $originalsep;

close(IN);
my @filelines = split(/\n+/,$alldata);

my $maxlines = scalar(@filelines);
my $count = 1;

while ($count <= $maxlines+2) {
    my @entry1 = split(/\s\s+/,$filelines[$count]);
    my @entry2 = split(/\s\s+/,$filelines[$count+1]);
    my @entry3 = split(/\s\s+/,$filelines[$count+2]);
    my $RT = $entry1[0];
    my $Area = $entry1[4];
    my $Hit1 = $entry1[1];
    my $Hit1CAS = $entry1[2];
    my $Hit1Formula = $entry1[3];
    my $Hit1Match = $entry1[5];
    if ($entry1[0] == $entry3[0]) {
	print "There are 3 lines of hits for RT $entry1[0]\n";
	my $Hit2 = $entry2[1];
	my $Hit2CAS = $entry2[2];
	my $Hit2Formula = $entry2[3];
	my $Hit2Match = $entry2[5];
	my $Hit3 = $entry3[1];
	my $Hit3CAS = $entry3[2];
	my $Hit3Formula = $entry3[3];
	my $Hit3Match = $entry3[5];
	print OUT "$RT\t$Area\t$Hit1\t$Hit1CAS\t$Hit1Formula\t$Hit1Match\t$Hit2\t$Hit2CAS\t$Hit2Formula\t$Hit2Match\t$Hit3\t$Hit3CAS\t$Hit3Formula\t$Hit3Match\n";
	$count=$count+3;
    } elsif ($entry1[0] == $entry2[0]) {
	print "There are 2 lines of hits for RT $entry1[0]\n";
	my $Hit2 = $entry2[1];
	my $Hit2CAS = $entry2[2];
	my $Hit2Formula = $entry2[3];
	my $Hit2Match = $entry2[5];
	my $Hit3 = "NA";
	my $Hit3CAS = "NA";
	my $Hit3Formula = "NA";
	my $Hit3Match = "NA";
	print OUT "$RT\t$Area\t$Hit1\t$Hit1CAS\t$Hit1Formula\t$Hit1Match\t$Hit2\t$Hit2CAS\t$Hit2Formula\t$Hit2Match\t$Hit3\t$Hit3CAS\t$Hit3Formula\t$Hit3Match\n";
	$count=$count+2;
    } elsif ($entry1[0] != $entry2[0]) {
	print "There is only a single hit for RT $entry1[0]\n";
	my $Hit2 = "NA";
	my $Hit2CAS = "NA";
	my $Hit2Formula = "NA";
	my $Hit2Match = "NA";
	my $Hit3 = "NA";
	my $Hit3CAS = "NA";
	my $Hit3Formula = "NA";
	my $Hit3Match = "NA";
	print OUT "$RT\t$Area\t$Hit1\t$Hit1CAS\t$Hit1Formula\t$Hit1Match\t$Hit2\t$Hit2CAS\t$Hit2Formula\t$Hit2Match\t$Hit3\t$Hit3CAS\t$Hit3Formula\t$Hit3Match\n";
	$count=$count+1;
    } else {
	print "There's something funky going on with your logic...\n";
    }
}

    
