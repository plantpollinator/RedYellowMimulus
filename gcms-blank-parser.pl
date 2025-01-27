#!/usr/bin/perl -w

use strict;
use List::MoreUtils qw(any);

# help
unless($ARGV[1] =~ /^all/) {
    print "gcms-blank-parser.pl blankfile datafile\n";
    exit;
}

# get arguments, frob files
my @filestoread = @ARGV;
my $blankfile = $ARGV[0];
my $datafile = $ARGV[1];
my $outfile = $datafile . ".parsed.tsv";
open(BLANKFILE,$blankfile);
open(DATAFILE,$datafile);
open(OUTFILE,">$outfile");
print OUTFILE "Infile\tRealRT\tBlankRT\tPotentialBlankRTs\tArea\tBlankArea\tAreavsBlank\tHit1\tHit2\tHit3\n";

# declare data hashes
my %blankdata;
my %realdata;

# read blank file into a data structure
while(defined(my $blankline = <BLANKFILE>)) {
    next if ($blankline =~ /RT/); # strip out first line
    last unless ($blankline =~ /^\S/); # strip out last blank line
    my @blanklinedata = split(/\t/,$blankline);
    my $blanklinert = $blanklinedata[0];
    my @blanklinetokeep = ();
    $blanklinetokeep[0] = $blanklinedata[1];
    $blanklinetokeep[1] = $blanklinedata[2];
    $blanklinetokeep[2] = $blanklinedata[6];
    $blanklinetokeep[3] = $blanklinedata[10];
    $blankdata{$blanklinert} = [@blanklinetokeep];
}
# for my $rt (keys %blankdata) {
#     print "blankdata: $rt: @{$blankdata{$rt}}\n";
# }

# read data file into a data structure
while(defined(my $dataline = <DATAFILE>)) {
    next if ($dataline =~ /RT/); # strip out first line
    last unless ($dataline =~ /^\S/); # strip out last blank line
    my @datalinedata = split(/\t/,$dataline);
    my $datalinert = $datalinedata[0];
    my @datalinetokeep = ();
    $datalinetokeep[0] = $datalinedata[1];
    $datalinetokeep[1] = $datalinedata[2];
    $datalinetokeep[2] = $datalinedata[6];
    $datalinetokeep[3] = $datalinedata[10];
    $realdata{$datalinert} = [@datalinetokeep];
}
#for my $rt (keys %realdata) {
#    print "realdata: $rt: @{$realdata{$rt}}\n";
#} 

# sort keys (retention times)
# now a sorted list of RTs
# for all of those (sorted keys), which ones match each other/are close enough to the peak I'm testing against
# and then pull the values from the hash and do the comparator

my @realrts = sort keys %realdata;
my @blankrts = sort keys %blankdata;
my @realhits;
my @blankhits;
my $realarea;
my $blankarea;
my $arearatio;
my $blankrt;

foreach my $realrt (@realrts) {
    my $lowerend = $realrt - 0.1;
    my $upperend = $realrt + 0.1;
    my $alreadyhit = 0;
    my $hitcounter = 0;
    my $hitcounterhuman = $hitcounter+1;
    my @timehits = grep({$lowerend < $_ < $upperend} @blankrts);
    my $nohits = scalar(@timehits);
	@realhits = @{$realdata{$realrt}};
	$realarea = shift(@realhits);
    if ($nohits == 0) {
	print OUTFILE "$datafile\t$realrt\tNA\tNA\t$realarea\tNA\tNA\t$realhits[0]\t$realhits[1]\t$realhits[2]\n";
	print "\n\nNo relevant blank hits at RT $realrt, moving on...\n\n";
    } else {
	print "\n\nFound $nohits potential blank peak(s) at real RT $realrt which is/are @timehits\n";
	    while($alreadyhit != 1) {
		if($hitcounter < $nohits) {
		    my $timehit = $timehits[$hitcounter];
		    print "Checking peak $hitcounterhuman of $nohits at blank RT $timehit\n";
		    @blankhits = @{$blankdata{$timehit}};
		    $blankarea = shift(@blankhits);
		    if (grep({$_ eq $blankhits[0]} @realhits) or
			grep({$_ eq $blankhits[1]} @realhits) or
			grep({$_ eq $blankhits[2]} @realhits)) {
#			print "Found $blankhits[0] or $blankhits[1] or $blankhits[2] in @realhits\n";
			$arearatio = $realarea / $blankarea;
			print OUTFILE "$datafile\t$realrt\t$timehit\t@timehits\t$realarea\t$blankarea\t$arearatio\t$realhits[0]\t$realhits[1]\t$realhits[2]\n";
			print "Ratio of peaks is $arearatio...\n";
			$alreadyhit = 1;
			print "Since we found a match, going on to the next real peak...\n";
		    } else {
#			print "Didn't see the blank names @blankhits in the real names @realhits\n";
			print "No matches seen to $realrt for peak $hitcounterhuman\n";
			$hitcounter++;
			$hitcounterhuman++;
		    }
		} else {
			print "No hits found at all, going on to the next real peak...\n";
			print OUTFILE "$datafile\t$realrt\tNA\t@timehits\t$realarea\tNA\tNA\t$realhits[0]\t$realhits[1]\t$realhits[2]\n";
			$alreadyhit = 1;
		}
	    }
    }
}

close(BLANKFILE);
close(DATAFILE);
close(OUTFILE);
