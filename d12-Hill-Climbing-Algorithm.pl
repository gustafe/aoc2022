#! /usr/bin/env perl
# Advent of Code 2022 Day 12 - Hill Climbing Algorithm - complete solution
# https://adventofcode.com/2022/day/12
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum min/;
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
my $Map;

my $moves = {
    N => { r => -1, c => 0 },
    S => { r => 1,  c => 0 },
    W => { r => 0,  c => -1 },
    E => { r => 0,  c => 1 }
};

my $start;
my $end;
my @starts;
for ( my $row = 0; $row <= $#input; $row++ ) {
    my $col = 0;
    for my $c ( split //, $input[$row] ) {
        $Map->{$row}{$col} = $c;
        push @starts, { r => $row, c => $col } if $Map->{$row}{$col} eq 'a';
        if ( $c eq 'S' ) {
            $start = { r => $row, c => $col };
            $Map->{$row}{$col} = 'a';
        }
        if ( $c eq 'E' ) {
            $end = { r => $row, c => $col };
            $Map->{$row}{$col} = 'z';
        }
        $col++;
    }
}
# put the original start point from part 1 first 
unshift @starts, $start;
my @paths;
for my $start (@starts) {

    my $end_found = 0;
    my @queue;
    push @queue, { r => $start->{r}, c => $start->{c} };
    my $came_from;
    my $visited;
    $visited->{ $start->{r} }{ $start->{c} } = 1;
    $came_from->{ $start->{r} }->{ $start->{c} } = undef;
BFS: while (@queue) {
        my $curr = shift @queue;
        for my $d ( keys %{$moves} ) {
            my $move_r = $curr->{r} + $moves->{$d}{r};
            my $move_c = $curr->{c} + $moves->{$d}{c};

            next unless $Map->{$move_r}{$move_c};
            next if $visited->{$move_r}{$move_c};
            if (ord( $Map->{$move_r}{$move_c} )
                <= ord( $Map->{ $curr->{r} }{ $curr->{c} } ) + 1 )
            {

                $came_from->{$move_r}->{$move_c} = $curr;
                if ( $move_r == $end->{r} and $move_c == $end->{c} ) {
                    $end_found = 1;
                    last BFS;
                }

                $visited->{$move_r}{$move_c}++;
                push @queue, { r => $move_r, c => $move_c };

            }
        }
    }

    # length of path
    if ($end_found) {

        my $path;
        unshift @{$path}, $end;

        while ( defined $came_from->{ $path->[0]{r} }{ $path->[0]{c} } ) {
            unshift @$path, $came_from->{ $path->[0]{r} }{ $path->[0]{c} };
        }

        push @paths, scalar @$path - 1;
    }
}

my $part1 = $paths[0];
my $part2 = min @paths;

### FINALIZE - tests and run time
is($part1, 330, "Part 1: $part1");
is($part2, 321, "Part 2: $part2");
done_testing();
say sec_to_hms(tv_interval($start_time));

### SUBS
sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 12: Hill Climbing Algorithm

=encoding utf8

Basic pathfinding. I really need to put these things into a library or somethnig.

Score: 2

Rating: 3/5

=cut
