#! /usr/bin/env perl
# Advent of Code 2022 Day 6 - Tuning Trouble - complete solution
# https://adventofcode.com/2022/day/6
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################

use Modern::Perl '2015';
# useful modules
use List::Util qw/sum/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my $part2   = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $WINDOW = $part2 ? 14 : 4;
my @ans;
for my $line (@input) {
    my @signal = split //, $line;
    my $start  = 0;
    while ( $start + $WINDOW - 1 <= $#signal ) {
        my %freq = map { $_ => 1 } @signal[ $start .. $start + $WINDOW - 1 ];

        if ( scalar keys %freq == $WINDOW ) {
            push @ans, $start + $WINDOW;
            last;
        }
        $start++;
    }
}
if ($testing) {
    if ($part2) {
        is( join( ',', @ans ), "19,23,23,29,26", "testing part2 ok" );
    } else {
        is( join( ',', @ans ), "7,5,6,10,11", "testing part1 ok" );
    }
} else {
    if ($part2) {
        is( $ans[0], 2625, "Part 2: " . $ans[0] );
    } else {
        is( $ans[0], 1816, "Part 1: " . $ans[0] );
    }
}
### FINALIZE - tests and run time
# is();
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s / ( 60 * 60 ) ), ( $s / 60 ) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 6: Tuning Trouble

=encoding utf8

An easy problem. I'm happy I went with my first instinct (using the
number of hash keys to detect (lack of) duplicates), along with
parametrizing the window size, because that made part 2 trivial. That
said my finishing standings were in the 16,000s despite a personal
best finishing time this year.

Score: 2

Puzzle rating: 3/5, too easy to make this really interesting.

=cut

