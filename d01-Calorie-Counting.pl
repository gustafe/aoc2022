#! /usr/bin/env perl
# Advent of Code 2022 Day 1 - Calorie Counting - complete solution
# https://adventofcode.com/2022/day/1
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
my $elf=0;
my %data;

for my $line(@input) {
    if ($line =~ /\d+/) {
	$data{$elf} += $line;
    } else {
	$elf++;
    }
}

my @top = sort {$b <=> $a}values %data;
my $part1 = $top[0];
my $part2 = $part1 + sum @top[1..2];

### FINALIZE - tests and run time
is($part1, 70369, "Part 1: $part1");
is($part2, 203002, "Part 2: $part2");
done_testing();
say sec_to_hms(tv_interval($start_time));

### SUBS
sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s / ( 60 * 60 ) ), ( $s / 60 ) % 60, $s % 60, $s * 1000 );
}
###########################################################

=head1 Day 1: Calorie Counting

=encoding utf8

=head2 Discussion

Easy start, as expected. I had some issues with my first solution, I
tried to sort the %data hash per the sums of its elements but for some
reason must have gotten the references wrong. Reworked to store the
running sums directly.

=cut
