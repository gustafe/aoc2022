#! /usr/bin/env perl
# Advent of Code 2022 Day 5 - Supply Stacks - complete solution
# https://adventofcode.com/2022/day/5
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
my @ins;
my @premap;
for my $line (@input) {
    if ( $line =~ m/^move/ ) {
        push @ins, $line;
    } else {
        unshift @premap, $line;
    }
}

# get rid of empty line, then construct the map
# we need 2 separate for each part
shift @premap;
my $indices = shift @premap;
my $idx     = 0;
my %Map;
my %positions;
for my $e ( split( //, $indices ) ) {
    if ( $e =~ /\d+/ ) {
        $Map{pt1}{$e} = [];
	$Map{pt2}{$e} = [];
        $positions{$idx} = $e;
    }
    $idx++;
}

# populate the stacks
while (@premap) {
    my @curr = split( //, shift @premap );
    for my $idx ( sort { $a <=> $b } keys %positions ) {
        if ( $curr[$idx] =~ /[A-Z]/ ) {
            push @{ $Map{pt1}{ $positions{$idx} } }, $curr[$idx];
            push @{ $Map{pt2}{ $positions{$idx} } }, $curr[$idx];
        }
    }

}

# execute move instructions
for my $ins (@ins) {
    if ( $ins =~ /move (\d+) from (\d+) to (\d+)/ ) {
        my ( $amount, $src, $dst ) = ( $1, $2, $3 );
        my @tmp;
        while ( $amount > 0 ) {
	    # part 1, simple queue
            push @{ $Map{pt1}{$dst} }, pop @{ $Map{pt1}{$src} };
	    # part 2, preserve order
            unshift @tmp, pop @{ $Map{pt2}{$src} };

            $amount--;
        }
        push @{ $Map{pt2}{$dst} }, @tmp;

    } else {
        die "invalid instruction: $ins";
    }

}
my %ans;
for my $part ( sort keys %Map ) {

    for my $pos ( sort { $a <=> $b } keys %{ $Map{$part} } ) {
        $ans{$part} .= $Map{$part}{$pos}->[-1];
    }

}

### FINALIZE - tests and run time
is( $ans{pt1}, 'HNSNMTLHQ', "Part 1: $ans{pt1}" );
is( $ans{pt2}, 'RNLFDJMCT', "Part 1: $ans{pt2}" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub dump_map {
    my ( $part ) = @_;
    die unless $part =~ m/pt\d/;
    for my $pos ( sort { $a <=> $b } keys %{$Map{$part}} ) {
        say "$pos: ", join( '', @{ $Map{$part}{$pos} } );
    }
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s / ( 60 * 60 ) ), ( $s / 60 ) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 5: Supply Stacks

=encoding utf8

A typical AoC problem: massaging the input into a usable form is half the problem 😉

Score: 2

Puzzle rating: 4/5, mostly because I'm proud of my input wrangling

Leaderboard completion time: 7m58s

=cut
