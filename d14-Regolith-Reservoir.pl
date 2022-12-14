#! /usr/bin/env perl
# Advent of Code 2022 Day 14 - Regolith Reservoir - complete solution
# https://adventofcode.com/2022/day/14
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
no warnings 'recursion';
use List::Util qw/sum min max/;
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
#sub fill;
my $Map;
for my $line (@input) {
    my @segments = split( / \-\> /, $line );
    my @p1       = ( split /\,/, shift @segments );
    while (@segments) {
        my @p2 = ( split /\,/, shift @segments );

        if ( $p1[0] == $p2[0] ) {
            my @range = ( min( $p1[1], $p2[1] ), max( $p1[1], $p2[1] ) );

            for my $y ( $range[0] .. $range[1] ) {

                $Map->{ $p1[0] }{$y} = '#';
            }

        } elsif ( $p1[1] == $p2[1] ) {
            my @range = ( min( $p1[0], $p2[0] ), max( $p1[0], $p2[0] ) );

            for my $x ( $range[0] .. $range[1] ) {

                $Map->{$x}{ $p1[1] } = '#';
            }

        } else {
            die "invalid pair! " . join( ',', @p1 ) . ' ' . join( ',', @p2 );
        }
        @p1 = @p2;
    }
}
my ( $x_min, $x_max, $y_min, $y_max ) = ( 10_000, -10_000, 10_000, -10_000 );
for my $x ( keys %$Map ) {
    $x_min = $x if $x < $x_min;
    $x_max = $x if $x > $x_max;
    for my $y ( keys %{ $Map->{$x} } ) {
        $y_min = $y if $y < $y_min;
        $y_max = $y if $y > $y_max;
    }
}

# test example
if ($testing) {
    is( $Map->{503}{4}, '#', "ok" );
    is( $Map->{502}{7}, '#', "ok" );
    is( $Map->{499}{9}, '#', "ok" );
    is( $Map->{498}{5}, '#', "ok" );
}

my $floor = $y_max + 2;

fill( 500, 0 );
my $count = 0;
for my $x ( keys %{$Map} ) {
    for my $y ( keys %{ $Map->{$x} } ) {
        $count++ if $Map->{$x}{$y} eq 'o';
    }
}

say $count;

### FINALIZE - tests and run time
if ($part2) {
    is( $count, 32041, "Part 2: $count" );
} else {
    is( $count, 964, "Part 1: $count" );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub fill {
    no warnings 'uninitialized';
    my ( $x, $y ) = @_;
    my $curr = $Map->{$x}{$y};
    if ( $y == $floor or ( $curr eq '#' or $curr eq 'o' ) ) {
        return 1;
    }
    if ( $y > $y_max and !$part2 ) {
        return 0;
    }

    my $continue
        = fill( $x, $y + 1 )
        && fill( $x - 1, $y + 1 )
        && fill( $x + 1, $y + 1 );

    $Map->{$x}{$y} = 'o' if $continue;

    return $continue;
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 14: Regolith Reservoir

=encoding utf8

Cobbled together a solution beased on 2018 day 17.

Score: 2

Rating: 4/5

=cut
