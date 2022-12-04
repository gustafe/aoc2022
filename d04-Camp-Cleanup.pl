#! /usr/bin/env perl
# Advent of Code 2022 Day 4 - Camp Cleanup - part 1 / part 2 / complete solution
# https://adventofcode.com/2022/day/4
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
my $count = 0;

my $contains   = 0;
my $no_overlap = 0;
for my $line (@input) {
    if ( $line =~ m/(\d+)-(\d+),(\d+)-(\d+)/ ) {
        my %r;
        ( $r{1}->{begin}, $r{1}->{end}, $r{2}->{begin}, $r{2}->{end} )
            = ( $1, $2, $3, $4 );
        if ((       $r{1}->{begin} >= $r{2}->{begin}
                and $r{1}->{end}   <= $r{2}->{end}
            )
            or (    $r{2}->{begin} >= $r{1}->{begin}
                and $r{2}->{end}   <= $r{1}->{end} )
            )
        {
            $contains++;
        }
        if (   $r{1}->{end}   < $r{2}->{begin}
            or $r{1}->{begin} > $r{2}->{end} )
        {
            $no_overlap++;
        }
    } else {
        die "unknown input: $line";
    }
    $count++;
}
my %ans;
$ans{1} = $contains;
$ans{2} = $count - $no_overlap;

### FINALIZE - tests and run time
is( $ans{1}, 567, "Part 1: $ans{1}" );
is( $ans{2}, 907, "Part 2: $ans{2}" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {
    my ($s) = @_;
    return sprintf(
        "Duration: %02dh%02dm%02ds (%.3f ms)",
        int( $s / ( 60 * 60 ) ),
        ( $s / 60 ) % 60,
        $s % 60, $s * 1000
    );
}

###########################################################

=pod

=head3 Day 4: Camp Cleanup

=encoding utf8

Sundays are traditionally hard but it's early days and this was
suspiciously easy. Maybe people would try to expand the quite
complicated condition in part 1 to part 2 instead of looking at the
obvious solution which was to find the ranges that I<didn't> overlap
and subtract those from the total.

=cut
