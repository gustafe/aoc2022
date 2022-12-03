#! /usr/bin/env perl
# Advent of Code 2022 Day 3 - Rucksack Reorganization - complete solution
# https://adventofcode.com/2022/day/3
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
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %ans;

my @groups;

# split an array into groups of three: https://stackoverflow.com/a/1492846
push @groups, [ splice @input, 0, 3 ] while @input;

for my $group (@groups) {
    my %freq;
    my $id = 1;
    for my $r ( @{$group} ) {

        # part 1 logic
        my @rucksack = split( //, $r );
        my $size     = scalar @rucksack;
        my %counts;
        for my $idx ( 0 .. $#rucksack ) {
            if ( $idx < $size / 2 ) {
                $counts{1}->{ $rucksack[$idx] }++;
            } else {
                $counts{2}->{ $rucksack[$idx] }++;
            }
        }

  # union and intersection:
  # https://www.oreilly.com/library/view/perl-cookbook/1565922433/ch04s09.html
        my %union;
        my %isect;
        for my $e ( keys %{ $counts{1} }, keys %{ $counts{2} } ) {
            $union{$e}++ && $isect{$e}++;
        }
        say keys %isect if $testing;
        $ans{1} += priority( keys %isect );

        # part 2 logic
        for my $c (@rucksack) {
            $freq{$c}->{$id}++;
        }
        $id++;
    }
    for my $c ( keys %freq ) {
        if ( scalar keys %{ $freq{$c} } == 3 ) {
            $ans{2} += priority($c);
        }
    }
}

### FINALIZE - tests and run time
if ($testing) {
    is( $ans{1}, 157, "Part 1: $ans{1}" );
    is( $ans{2}, 70,  "Part 2: $ans{2}" );

} else {

    is( $ans{1}, 7811, "Part 1: $ans{1}" );
    is( $ans{2}, 2639, "Part 2: $ans{2}" );
}
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub priority {
    my ($c) = @_;
    if ( $c ge 'a' ) {
        return ord($c) - ord('a') + 1;
    } else {
        return ord($c) - ord('A') + 27;
    }
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s / ( 60 * 60 ) ), ( $s / 60 ) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 3: Rucksack Reorganization

=encoding utf8

A bit fiddly with all the indices but not too hard once I worked it all out.

Score: 2

Puzzle rating: 3/5

=cut
