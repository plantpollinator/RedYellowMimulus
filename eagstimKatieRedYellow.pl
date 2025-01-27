#!/usr/bin/perl -w

use strict;

my @eagstim = ('airx6','solventx6','MverbRedx6','MverbYellowx6','McardRedx6','McardYellowx6');

   # fisher_yates_shuffle( \@array ) :
    # generate a random permutation of @array in place
sub fisher_yates_shuffle {
    my $array = shift;
    my $i;
    for ($i = @$array; --$i; ) {
	my $j = int rand ($i+1);
	next if $i == $j;
	@$array[$i,$j] = @$array[$j,$i];
    }
}

fisher_yates_shuffle( \@eagstim);

print "PAAx4 @eagstim[0..2] PAAx4 @eagstim[3..5] PAAx4\n";
