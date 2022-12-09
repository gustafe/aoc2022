#! /usr/bin/env perl
# Advent of Code 2022 Day 9 - Rope Bridge - complete solution
# https://adventofcode.com/2022/day/9
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################

use Modern::Perl '2015';
# useful modules
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
my %dirs = (
    U => { x => 0,  y => 1 },
    D => { x => 0,  y => -1 },
    R => { x => 1,  y => 0 },
    L => { x => -1, y => 0 }
);
my $chain_length = $part2 ? 10 : 2;
my @chain;

# initialize
for my $idx ( 1 .. $chain_length ) {
    push @chain, { x => 0, y => 0 };
}

my $seen_tail->{0}{0}++;

for my $line (@input) {
    my ( $dir, $dist ) = $line =~ m/^(.) (\d+)$/;

    my $dx = $dirs{$dir}->{x};
    my $dy = $dirs{$dir}->{y};
    for my $step ( 1 .. $dist ) {
        $chain[0]->{x} += $dx;
        $chain[0]->{y} += $dy;

        # move the chain
        for my $idx ( 1 .. $#chain ) {
            my $prev = $chain[ $idx - 1 ];
            my $curr = $chain[$idx];
            if (   abs( $prev->{x} - $curr->{x} ) > 1
                or abs( $prev->{y} - $curr->{y} ) > 1 )
            {
                $curr->{x} += $prev->{x} <=> $curr->{x};
                $curr->{y} += $prev->{y} <=> $curr->{y};

                $chain[$idx] = { x => $curr->{x}, y => $curr->{y} };

                # record the chain tail
                $seen_tail->{ $curr->{x} }{ $curr->{y} }++ if $idx == $#chain;
            }
        }
    }
}

my $count;
for my $x ( keys %{$seen_tail} ) {
    for my $y ( keys %{ $seen_tail->{$x} } ) {
        $count++;
    }
}
### FINALIZE - tests and run time
if ($part2) {
    is( $count, 2661, "Part 2: $count" );
} else {
    is( $count, 6284, "Part 1: $count" );
}

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

=head3 Day 9: Rope Bridge

=encoding utf8

Another challenging puzzle. My first attempt was to move the head
directly, then "trace" the path of the tail. This worked fine for the
example but my real input was off by some tens, which made it really
hard to debug.

I then switched to a model where the tail directly followed the head
through each step.

The trick with C<< <=> >> to compare chain movements was picked up
from a couple of Perlers in the subreddit.

Score: 2, barely

Rating: 4/5

=cut


