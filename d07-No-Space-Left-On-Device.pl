#! /usr/bin/env perl
# Advent of Code 2022 Day 7 - No Space Left On Device - complete solution
# https://adventofcode.com/2022/day/7
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
my $FSLIMIT = 100_000;
my %dirsizes;
my @cwd;

for my $line (@input) {

    # we only care about directory changes...
    if ( $line =~ m/^\$ cd\s+(.*)/ ) {
        my $dir = $1;

        if ( $dir eq '/' ) { @cwd = ('/') }
        elsif ( $dir eq '..' ) {
            pop @cwd;
        } else {
            push @cwd, $cwd[-1] . '|' . $dir;
        }

    }

    # ... and file sizes. Ignore other inputs
    if ( $line =~ m/^(\d+)/ ) {
        my $size = $1;

        # update each dir currently in the path with the current filesize
        for my $d (@cwd) {
            $dirsizes{$d} += $size;
        }
    }
}
my $total = 0;
for my $d ( keys %dirsizes ) {
    $total += $dirsizes{$d} if $dirsizes{$d} <= $FSLIMIT;
}

# part 2
my $min_file_size;

# total size

my $all_files      = $dirsizes{'/'};
my $diff           = 70000000 - $all_files;
my $need_to_delete = 30000000 - $diff;
for my $d ( sort { $dirsizes{$a} <=> $dirsizes{$b} } keys %dirsizes ) {
    if ( $dirsizes{$d} >= $need_to_delete ) {
        $min_file_size = $dirsizes{$d};
        last;
    }
}

### FINALIZE - tests and run time

is( $total,         1391690, "Part 1: $total" );
is( $min_file_size, 5469168, "Part 2: $min_file_size" );
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

=head3 Day 7: No Space Left On Device

=encoding utf8

This was a tough one. I had the right basic idea but had to search for some hints in the subreddit. Credit /u/Abigail:

L<https://github.com/Abigail/AdventOfCode2022/blob/master/Day_07/solution.pl>

Score: B<1>

Rating: 4/7, tough but fair

=cut


