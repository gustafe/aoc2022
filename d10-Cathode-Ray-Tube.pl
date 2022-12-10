#! /usr/bin/env perl
# Advent of Code 2022 Day 10 - Cathode-Ray Tube - complete solution
# https://adventofcode.com/2022/day/10
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
my @values = (1);
for my $ins (@input) {
    my $X = $values[-1];
    if ( $ins eq 'noop' ) {
        push @values, $X;
    } elsif ( $ins =~ m/^addx (.*)$/ ) {
        my $term = $1;
        push @values, $X;
        my $res = $X + $term;
        push @values, $res;
    } else {
        die "invalid instruction: $ins";
    }
}

my $sum = 0;
for my $d ( 20, 60, 100, 140, 180, 220 ) {
    $sum += $d * $values[ $d - 1 ];
}

## part 2

my @display;
for my $pxl ( 0 .. 239 ) {
    if (   $values[$pxl] - 1 == $pxl % 40
        or $values[$pxl] == $pxl % 40
        or $values[$pxl] + 1 == $pxl % 40 )
    {
        $display[$pxl] = '█';
    } else {
        $display[$pxl] = '·';
    }
}

my $ans_string;
for my $idx ( 0 .. $#display ) {
    push @{$ans_string}, $idx unless $display[$idx] eq '·';
}

is( $sum, 13520, "Part 1: $sum" );
is( join( ',', @$ans_string ),
    '0,1,2,6,7,10,11,12,15,18,20,21,22,25,26,27,28,31,32,35,36,37,40,43,45,48,50,53,55,58,60,63,65,70,73,75,78,80,83,85,90,93,95,96,97,98,100,101,102,105,106,107,110,113,115,116,117,120,121,122,125,127,128,130,131,132,135,138,140,143,145,150,151,152,153,155,158,160,165,168,170,175,178,180,183,185,190,193,195,198,200,206,207,208,210,215,218,220,221,222,225,226,227,228,230,233,235,236,237',
    "Part 2 OK"
);

for my $row ( 0 .. 5 ) {
    my $start = $row * 40;
    print '    ';
    for my $p ( $start .. $start + 40 - 1 ) {
        print $display[$p];

    }
    say '';
}
### FINALIZE - tests and run time
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

=head3 Day 10: Cathode-Ray Tube

=encoding utf8

Register Rodeo - but with timings!

A fun problem. The test input was nicely designed to ensure I caught my off-by-one error.

Score: 2

Rating: 4/5

=cut
