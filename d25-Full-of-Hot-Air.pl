#! /usr/bin/env perl
# Advent of Code 2022 Day 25 - Full of Hot Air - complete solution
# https://adventofcode.com/2022/day/25
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

my %s2d = ( '=' => -2, '-' => -1, '0' => 0, 1 => 1,   2 => 2 );
my %d2s = ( '0' => 0,  1   => 1,  2   => 2, 3 => '=', 4 => '-' );

my $total;
for my $snafu (@input) {
    my $sum;
    my @digits = reverse( split //, $snafu );
    for my $exp ( 0 .. $#digits ) {
        $sum += $s2d{ $digits[$exp] } * 5**$exp;
    }

    $total += $sum;
}

my $snafu;
while ( $total > 0 ) {
    my $rem = $total % 5;
    $total = int $total / 5;
    $snafu .= $d2s{$rem};
    $total += 1 if $rem > 2;
}
my $ans = join( '', reverse( split //, $snafu ) );
### FINALIZE - tests and run time
is( $ans, '20-==01-2-=1-2---1-0', "Answer: " . $ans );
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

=head3 Day 25: Full of Hot Air

=encoding utf8

A fun final problem!

Score: 2

Rating: 3/5

Leaderboard completion time: 8m30s

=cut

