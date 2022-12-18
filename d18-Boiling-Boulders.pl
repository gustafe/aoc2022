#! /usr/bin/env perl
# Advent of Code 2022 Day 18 - Boiling Boulders - complete solution
# https://adventofcode.com/2022/day/18
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
my $Map;
my $skin;
my @moves = (
    [ -1, 0,  0 ],
    [ 1,  0,  0 ],
    [ 0,  -1, 0 ],
    [ 0,  1,  0 ],
    [ 0,  0,  -1 ],
    [ 0,  0,  1 ]
);
my ( $x_max, $y_max, $z_max, $x_min, $y_min, $z_min )
    = ( -1000, -1000, -1000, 1000, 1000, 1000 );

for my $line (@input) {
    my ( $x, $y, $z ) = split( /,/, $line );
    $Map->{$x}{$y}{$z}++;
    $x_max = $x if $x > $x_max;
    $y_max = $y if $y > $y_max;
    $z_max = $z if $z > $z_max;
    $x_min = $x if $x < $x_min;
    $y_min = $y if $y < $y_min;
    $z_min = $z if $z < $z_min;
}
say "$x_min $x_max $y_min $y_max $z_min $z_max" if $testing;
my $count;
for my $x ( $x_min .. $x_max ) {
    for my $y ( $y_min .. $y_max ) {
        for my $z ( $z_min .. $z_max ) {
            next unless $Map->{$x}{$y}{$z};
            for my $m (@moves) {
                my ( $dx, $dy, $dz )
                    = ( $x + $m->[0], $y + $m->[1], $z + $m->[2] );
                if ( !defined $Map->{$dx}{$dy}{$dz} ) {
                    push @{ $skin->{$x}{$y}{$z} }, [ $dx, $dy, $dz ];
                    $count++;
                }
            }
        }
    }
}

my $outside = 0;

for my $x ( keys %{$skin} ) {
    for my $y ( keys %{ $skin->{$x} } ) {
        for my $z ( keys %{ $skin->{$x}{$y} } ) {
            say "$x $y $z" if $testing;
            for my $edge ( @{ $skin->{$x}{$y}{$z} } ) {

                my $res = escape(@$edge);
                if ($res) {
                    say "$x $y $z is outside" if $testing;
                    $outside++;
                } else {
                    say "$x $y $z is inside" if $testing;
                }
            }
        }
    }
}

### FINALIZE - tests and run time
if ( !$testing ) {
    is( $count,   3576, "Part 1: $count" );
    is( $outside, 2066, "Part 2: $outside" );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub escape {
    my ( $x, $y, $z ) = @_;

    # try to move from this position, until we reach outside or not
    my @queue = ( [ $x, $y, $z ] );
    my $visited;
    $visited->{$x}{$y}{$z} = 1;
    while (@queue) {
        my $curr = shift @queue;

        # try to move
        for my $m (@moves) {
            my ( $dx, $dy, $dz ) = map { $curr->[$_] + $m->[$_] } ( 0, 1, 2 );
            if (   ( $dx < $x_min or $dx > $x_max )
                or ( $dy < $y_min or $dy > $y_max )
                or ( $dz < $z_min or $dz > $z_max ) )
            {
                return 1;
            }
            next if defined $visited->{$dx}{$dy}{$dz};
            next if defined $Map->{$dx}{$dy}{$dz};
            $visited->{$dx}{$dy}{$dz}++;
            push @queue, [ $dx, $dy, $dz ];
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

=head3 Day 18: Boiling Boulders

=encoding utf8

Finally back on track and finished 2 starts within the first 10,000 for the first time this year (oh how my standards have fallen).

My first attempt at part 1 was embarrasingly complex, I found a simpler way when starting on part 2. In that case I just flood fill from each "skin cube" until I either run out of space or reach the edge of the 3D map.

Runtime is around 15s.

Score: 2

Rating: 4/5

Leaderboard completion time: 12m29s

=cut


