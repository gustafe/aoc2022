#! /usr/bin/env perl
# Advent of Code 2022 Day 15 - Beacon Exclusion Zone - complete solution
# https://adventofcode.com/2022/day/15
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
use POSIX qw/floor/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
# get sensors and their radii
my %sensors;
my $id = 1;
my ( $x_min, $x_max ) = ( 0, 0 );
for my $line (@input) {
    if ( $line =~ m/x\=(-?\d+)\, y\=(-?\d+).*x\=(-?\d+)\, y\=(-?\d+)$/ ) {
        my $sens = [ $1, $2 ];
        my $beac = [ $3, $4 ];
        my $radius  = manhattan( $sens, $beac );
        my @x_range = ( $sens->[0] - $radius, $sens->[0] + $radius );
        $x_min = $x_range[0] if $x_range[0] < $x_min;
        $x_max = $x_range[1] if $x_range[1] > $x_max;
        $sensors{$id} = { loc => $sens, rad => $radius };
    } else {
        die "invalid input line: $line";
    }
    $id++;
}
my $y_search = $testing ? 10 : 2_000_000;
say dump \%sensors if $testing;
my $step  = floor( ( $x_max - $x_min ) / 10 );
my $state = 0;
my ( $x_left, $x_right ) = ( $x_min, $x_max );
my $x = $x_min;
my @left;
my @right;

while ( $x <= $x_max ) {
    my $next = $x + $step;
    if (    in_range( [ $x, $y_search ] ) == 0
        and in_range( [ $next, $y_search ] ) > 0 )
    {
        @left = ( $x, $next );
    } elsif ( in_range( [ $x, $y_search ] ) > 0
        and in_range( [ $next, $y_search ] ) == 0 )
    {
        @right = ( $x, $next );
    }
    $x = $next;

}

# left side
my ( $L, $R ) = @left;
while ( $L < $R ) {
    my $m = floor( ( $L + $R ) / 2 );
    if ( in_range( [ $m, $y_search ] ) ) {
        $R = $m - 1;
    } else {
        $L = $m + 1;
    }
}
my $left_limit = $L + 1;

# right side
( $L, $R ) = @right;
while ( $L < $R ) {
    my $m = floor( ( $L + $R ) / 2 );
    if ( in_range( [ $m, $y_search ] ) ) {
        $L = $m + 1;
    } else {
        $R = $m - 1;
    }

}

my $part1 = $R - $left_limit;

# part 2

# follow each "circle" around, checking outside it. If one cell isn't in range, we've found it
my $max_val = $testing ? 20 : 4000000;
my $target;

# custom ordering based on my input (for speed), but all input lines are checked
LOOP:
for my $id (
    ( 23, 20, 7, 14 ),
    ( 1 .. 6 ),
    ( 8 .. 13 ),
    ( 15 .. 19 ),
    ( 21, 22 ),
    ( 24 .. 33 )
    )
{

    my $center = $sensors{$id}->{loc};
    my $radius = $sensors{$id}->{rad};
    printf( "checking circle $id with center (%d,%d) and radius %d, pass 1\n",
        @$center, $radius );
    my $y = $center->[1];
    my ( $upper, $lower ) = ( $y, $y );
    my $pos = 0;
    say "left half...";
    for ( my $x = $center->[0] - $radius; $x < $center->[0]; $x++ ) {

        $upper = $center->[1] - $pos;
        $lower = $center->[1] + $pos;

        if (    ( $x > 0 and $x < $max_val )
            and ( $upper > 0 and $upper < $max_val )
            and ( $lower > 0 and $lower < $max_val ) )
        {
            # check left
            if ( in_range( [ $x - 1, $upper ] ) == 0 ) {
                $target = [ $x - 1, $upper ];
                last LOOP;
            }

            # check down
            if ( in_range( [ $x, $lower + 1 ] ) == 0 ) {
                $target = [ $x, $lower + 1 ];
                last LOOP;
            }
        }
        $pos++;
    }
    say "right half...";
    for ( my $x = $center->[0]; $x <= $center->[0] + $radius; $x++ ) {

        $upper = $center->[1] - $pos;
        $lower = $center->[1] + $pos;

        if (    ( $x > 0 and $x < $max_val )
            and ( $upper > 0 and $upper < $max_val )
            and ( $lower > 0 and $lower < $max_val ) )
        {

            # check up
            if ( in_range( [ $x, $upper - 1 ] ) == 0 ) {
                $target = [ $x, $upper - 1 ];
                last LOOP;
            }

            # check right
            if ( in_range( [ $x + 1, $lower ] ) == 0 ) {
                $target = [ $x + 1, $lower ];
                last LOOP;
            }
        }
        $pos--;
    }

}

my $part2 = $target->[0] * 4000000 + $target->[1];

if ($testing) {
    is( in_range( [ -2, 9 ] ), 0, "not in range" );
    cmp_ok( in_range( [ -1, 9 ] ),  '>', 0, "in range" );
    cmp_ok( in_range( [ -2, 10 ] ), '>', 0, "in range" );
    cmp_ok( in_range( [ 24, 10 ] ), '>', 0, "in range" );
    is( in_range( [ 14, 11 ] ), 0, "not in range" );

}
### FINALIZE - tests and run time
if ($testing) {
    is( $part1, 26,       "Part 1 TESTING: $part1" );
    is( $part2, 56000011, "Part 2 TESTING: $part2" );

} else {
    is( $part1, 5083287,        "Part 1: $part1" );
    is( $part2, 13134039205729, "Part 2: $part2" );

}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub manhattan {
    my ( $p1, $p2 ) = @_;
    return sum( map { abs( $p2->[$_] - $p1->[$_] ) } ( 0 .. 1 ) );
}

sub in_range {
    my ($p) = @_;
    for my $id ( keys %sensors ) {
        if ( manhattan( $p, $sensors{$id}->{loc} ) <= $sensors{$id}->{rad} ) {
            return $id;
        }
    }
    return 0;
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 15: Beacon Exclusion Zone

=encoding utf8

A tough but fun one. I had flashbacks to the damn 3D beacons in ... 2019? (still not solved!) but this was much easier.

Part 1 was binary search (both ends). I guessed the area would be contigous. And of course it was, as part 2 proved. 

I figured out that if you checked the first cells outside the Manhattan circle you would have a much smaller search space. 

Score: 2

Rating: 4/5

=cut

