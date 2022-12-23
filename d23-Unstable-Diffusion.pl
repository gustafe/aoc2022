#! /usr/bin/env perl
# Advent of Code 2022 Day 23 - Unstable Diffusion - complete solution
# https://adventofcode.com/2022/day/23
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum first min max all/;
use Data::Dump qw/dump/;
use Test::More;
use Clone qw/clone/;
use Time::HiRes qw/gettimeofday tv_interval/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $debug   = 0;
my $testing = 0;
my @input;

my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $state;
my $row = 0;
for my $line (@input) {
    $state->{$row} = {};
    my $col = 0;
    for my $c ( split //, $line ) {
        if ( $c eq '#' ) {
            $state->{$row}{$col} = 1;    # occupied
        }
        $col++;
    }
    $row++;
}
my @instructions = (
    {   dir   => 'N',
        check => [ [ -1, -1 ], [ -1, 0 ], [ -1, 1 ] ],
        move  => [ -1, 0 ]
    },
    {   dir   => 'S',
        check => [ [ 1, -1 ], [ 1, 0 ], [ 1, 1 ] ],
        move  => [ 1, 0 ]
    },
    {   dir   => 'W',
        check => [ [ -1, -1 ], [ 0, -1 ], [ 1, -1 ] ],
        move  => [ 0, -1 ]
    },
    {   dir   => 'E',
        check => [ [ -1, 1 ], [ 0, 1 ], [ 1, 1 ] ],
        move  => [ 0, 1 ]
    }
);

dump_state() if $debug;
my $movement = 1;
my $rounds   = 0;
my $ans;
LOOP: while ($movement) {
    no warnings 'uninitialized';
    say "==> $rounds" if $rounds % 25 == 0;
    my $want_to_move = {};
    my $targets;

    for my $row ( keys %$state ) {
        for my $col ( keys %{ $state->{$row} } ) {
            next unless $state->{$row}{$col} == 1;
            say "found elf at $row,$col" if $debug;
            my @neighbors = (0) x 4;
            for my $idx ( 0 .. $#instructions ) {
                for my $ch ( @{ $instructions[$idx]->{check} } ) {
                    $neighbors[$idx]++
                        if (
                        $state->{ $row + $ch->[0] }{ $col + $ch->[1] } == 1 );
                }
            }
            say join( ',', @neighbors ) if $debug;
            if ( all { $_ == 0 } @neighbors ) {

                # do nothing
                say "clear all around, don't move" if $debug;

                next;
            } else {
                my $dir_idx;
            N: for my $i ( 0 .. $#neighbors ) {
                    if ( $neighbors[$i] == 0 ) {
                        $dir_idx = $i;
                        last N;
                    }
                }
                if ( defined $dir_idx ) {
                    say "desired direction: $instructions[$dir_idx]{dir}"
                        if $debug;
                    my $target_r = $row + $instructions[$dir_idx]{move}[0];
                    my $target_c = $col + $instructions[$dir_idx]{move}[1];
                    $targets->{$target_r}{$target_c}++;
                    $want_to_move->{$row}{$col} = [ $target_r, $target_c ];
                    say
                        "elf at $row,$col wants to move to $target_r,$target_c"
                        if $debug;
                } else {

                    # can't move
                    next;
                }
            }
        }
    }

    # create new state
    say "==> moving elfs" if $debug;
    if ( scalar( keys %$want_to_move ) == 0 ) {
        $movement = 1;
        $ans->{2} = $rounds + 1;
        last LOOP;
    }
    my $newstate;
    for my $row ( keys %$state ) {
        for my $col ( keys %{ $state->{$row} } ) {
            next unless $state->{$row}{$col} == 1;
            if ( defined $want_to_move->{$row}{$col} ) {

                my $target = $want_to_move->{$row}{$col};
                say "elf at $row,$col wants to move to "
                    . join( ',', @$target )
                    if $debug;
                if ( $targets->{ $target->[0] }{ $target->[1] } > 1 ) {
                    say "... but can't" if $debug;
                    $newstate->{$row}{$col} = 1;

                    # can't move

                } else {
                    say "moved elf to " . join( ',', @$target ) if $debug;
                    $newstate->{ $target->[0] }{ $target->[1] } = 1;
                    $newstate->{$row}{$col} = undef;
                }
            } else {
                say "$row,$col no change, transferring state" if $debug;
                $newstate->{$row}{$col} = 1;
            }
        }
    }
    $state = clone $newstate;

    my $first = shift @instructions;
    push @instructions, $first;
    if ( $rounds == 9 ) {    # part 1
        $ans->{1} = dump_state(1);
    }
    dump_state() if $debug;
    $rounds++;
}


### FINALIZE - tests and run time
is( $ans->{1}, 3862, "Part 1: " . $ans->{1} );
is( $ans->{2}, 913,  "Part 2: " . $ans->{2} );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub dump_state {
    no warnings 'uninitialized';
    my ($nodraw) = @_;
    my $empty = 0;
    my ( $r_min, $r_max ) = ( min( keys %$state ), max( keys %$state ) );
    my ( $c_min, $c_max ) = ( 1000, -1000 );

    for my $r ( keys %$state ) {
        my ( $min, $max )
            = ( min( keys %{ $state->{$r} } ),
            max( keys %{ $state->{$r} } ) );
        $c_min = $min if $min < $c_min;
        $c_max = $max if $max > $c_max;

    }
    my @output;
    for my $r ( $r_min .. $r_max ) {
        my $line;
        for my $c ( $c_min .. $c_max ) {
            if ( defined $state->{$r}{$c} ) {
                $line .= $state->{$r}{$c};
            } else {
                $line .= '.';
                $empty++;
            }
        }
        push @output, $line;
    }
    say join( "\n", @output ) unless $nodraw;
    return $empty;
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 23: Unstable Diffusion

=encoding utf8

After figuring out  that I wasn't outputting empty lines when debugging I finally got this to work. 

Leaderboard completion time: 24m43s

=cut
