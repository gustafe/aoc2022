#! /usr/bin/env perl
# Advent of Code 2022 Day 21 - Monkey Math - complete solution
# https://adventofcode.com/2022/day/21
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################

#! /usr/bin/env perl
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum/;
use Data::Dump qw/dump/;
use Clone qw/clone/;
use POSIX qw/floor/;
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
my $M;
for my $line (@input) {
    if ( $line =~ /^(\S+): (\d+)$/ ) {
        $M->{$1} = { yells => $2 };

    } elsif ( $line =~ /^(\S+): (\S+) (.) (\S+)$/ ) {
        $M->{$1} = { p1 => $2, op => $3, p2 => $4 };
    } else {
        die "can't parse $line";
    }
}

### part 1
my $map   = clone $M;
my $part1 = solve( 'root', $map );

### part 2

my @branches = ( $M->{root}{p1}, $M->{root}{p2} );
my $target;
my $unsolved;

for my $p (@branches) {

    my $map = clone $M;
    $map->{humn} = {};

    my $res = solve( $p, $map );
    if ( defined $res ) {
        $target = $res;

    } else {
        $unsolved = $p;
    }
}
say "Solving part 2...";
say "Target value: $target";
say "Unsolved branch: $unsolved";

my ( $L, $R, $m ) = ( 1, $target, -1 );

while ( $L < $R ) {
    $m = floor( ( $L + $R ) / 2 );
    my $map = clone $M;
    $map->{humn}{yells} = $m;
    my $result = solve( $unsolved, $map );

    if ( $result > $target )
    {    # this setting worked for my input, it might not for all
        $L = $m + 1;
    } else {
        $R = $m - 1;
    }
}

#say "result: $m";
is( $part1, 124765768589550, "Part 1: $part1" );

is( $m, 3059361893920, "Part 2: $m" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub solve {    # find the value of a key in the map
    no warnings 'uninitialized';

    my ( $goal, $map ) = @_;
    my $limit  = 50;
    my $rounds = 0;
    while ( !defined $map->{$goal}{yells} and $rounds < $limit ) {
        for my $k ( keys %$map ) {
            next if defined $map->{$k}{yells};
            if (    defined $map->{ $map->{$k}{p1} }{yells}
                and defined $map->{ $map->{$k}{p2} }{yells} )
            {
                my $eval_str
                    = '('
                    . $map->{ $map->{$k}{p1} }{yells} . ')'
                    . $map->{$k}{op} . '('
                    . $map->{ $map->{$k}{p2} }{yells} . ')';


                my $res = eval($eval_str);
                if ( $res !~ /\d+/ ) {
                    next LOOP;
                }
                $map->{$k}{yells} = $res;
            }
        }
        $rounds++;
    }
    return $map->{$goal}{yells};
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 21: Monkey Math

=encoding utf8

No need to faff about with fancy trees and solvers when you can just
do a brute force binary search for the value you want...

Score: 2

Rating: 4/5

Leaderboard completion time: 16m15s

=cut

