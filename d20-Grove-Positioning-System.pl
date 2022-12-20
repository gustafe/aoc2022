#! /usr/bin/env perl
# Advent of Code 2022 Day 20 - Grove Positioning System - complete solution
# https://adventofcode.com/2022/day/20
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################
use Modern::Perl '2015';

# useful modules
use List::Util qw/sum first/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $part2   = 1;

my $testing = 0;

my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my @map = @input;
if ($part2) {
    @map = map { $_ * 811589153 } @map;
}

my @indexes = ( 0 .. $#map );

my $MAX_ITER = $part2 ? 10 : 1;
for my $round ( 1 .. $MAX_ITER ) {
    say "==> $round" if $part2;
    for my $i ( 0 .. $#map ) {
        my $pos;
        for my $j ( 0 .. $#map ) {
            if ( $indexes[$j] == $i ) {
                $pos = $j;
                last;
            }
        }
        my $el   = splice( @map, $pos, 1 );
        my $dest = ( $pos + $el ) % @map;
        splice( @map, $dest, 0, $el );
        splice( @indexes, $pos, 1 );
        splice( @indexes, $dest, 0, $i );
    }
}

# decode
my $zero_pos = first { $map[$_] == 0 } 0 .. $#map;

#say $zero_pos;
my $sum = 0;
for my $offset ( 1000, 2000, 3000 ) {
    $sum += $map[ ( $zero_pos + $offset ) % @map ];
}
say $sum;
### FINALIZE - tests and run time
if ($part2) {
    is( $sum, 9738258246847, "Part 2: $sum" );
} else {
    is( $sum, 14526, "Part 1: $sum" );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 20: Grove Positioning System

=encoding utf8

I am not a fan of C<splice> but with some trial and error this came
together in the end.

Score: 2

Rating: 3/5

Leaderboard completion time: 21m14s

=cut
