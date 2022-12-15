#! /usr/bin/env perl
# Advent of Code 2022 Day 11 - Monkey in the Middle - complete solution
# https://adventofcode.com/2022/day/11
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

my $part2 = 1;

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %monkey_rules;
my %monkey_items;
my %monkey_activity;
my $curr = undef;
for my $line (@input) {
    if ( $line =~ m/^Monkey (\d+)/ ) {
        $curr = $1;
    }
    if ( $line =~ /Starting items: (.*)$/ ) {
        $monkey_items{$curr} = [ split( /\,/, $1 ) ];
    }
    if ( $line =~ /Operation: new = old (.*)$/ ) {
        $monkey_rules{$curr}->{op} = $1;
    }
    if ( $line =~ /Test: divisible by (\d+)$/ ) {
        $monkey_rules{$curr}->{divisor} = $1;
    }
    if ( $line =~ /If true: throw to monkey (\d+)/ ) {
        $monkey_rules{$curr}->{true_target} = $1;
    }
    if ( $line =~ /If false: throw to monkey (\d+)/ ) {
        $monkey_rules{$curr}->{false_target} = $1;
    }
}

my $all_products = 1;
for my $m ( keys %monkey_rules ) {
    $all_products *= $monkey_rules{$m}->{divisor};
}

my $round = 1;
my $LIMIT = $part2 ? 10_000 : 20;
while ( $round <= $LIMIT ) {
    for my $m ( sort keys %monkey_rules ) {
        while ( @{ $monkey_items{$m} } ) {

            my $item = shift @{ $monkey_items{$m} };
            $monkey_activity{$m}++;

            # calculate worry level
            my $level;
            my ( $operand, $term ) = split( /\s+/, $monkey_rules{$m}->{op} );
            if ( $term eq 'old' ) {
                $term = $item;
            }
            if ( $operand eq '+' ) {
                $level = $item + $term;
            } elsif ( $operand eq '*' ) {
                $level = $item * $term;
            } else {
                die "unkown operand: $operand";
            }

            $level = int( $level / 3 ) unless $part2;

            $level = $part2 ? $level % $all_products : $level;

            # pass the test?

            if ( $level % $monkey_rules{$m}->{divisor} == 0 ) {

                push @{ $monkey_items{ $monkey_rules{$m}->{true_target} } },
                    $level;
            } else {

                push @{ $monkey_items{ $monkey_rules{$m}->{false_target} } },
                    $level;
            }
        }
    }

    $round++;
}
my @sorted = sort { $b <=> $a } values %monkey_activity;
my $res    = $sorted[0] * $sorted[1];
### FINALIZE - tests and run time

if ($part2) {
    is( $res, 13606755504, "Part 2: $res" );
} else {
    is( $res, 54752, "Part 1: $res" );
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

=head3 Day 11: Monkey in the Middle

=encoding utf8

A fun Sunday problem!

Score: 2

Rating: 4/5

Leaderboard completion time: 18m05s

=cut

