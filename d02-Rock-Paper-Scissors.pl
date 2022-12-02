#! /usr/bin/env perl
# Advent of Code 2022 Day 2 - Rock Paper Scissors - complete solution
# https://adventofcode.com/2022/day/2
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
my %shape_scores = ( rock => 1, paper => 2, scissors => 3 );
my %round_scores = ( lose => 0, draw  => 3, win      => 6 );
my %game_rules   = (
    rock     => { beats => 'scissors', loses_to => 'paper' },
    paper    => { beats => 'rock',     loses_to => 'scissors' },
    scissors => { beats => 'paper',    loses_to => 'rock' }
);
my %opponent_moves = ( A => 'rock', B => 'paper', C => 'scissors' );
my %input          = (
    X => { p1 => 'rock',     p2 => 'lose' },
    Y => { p1 => 'paper',    p2 => 'draw' },
    Z => { p1 => 'scissors', p2 => 'win' }
);

my %ans;

for my $game (@input) {
    my ( $opponent, $player ) = split( /\s+/, $game );
    my $result
        = rules_p1( $opponent_moves{$opponent}, $input{$player}->{p1} );
    $ans{1} += (
        $round_scores{$result} + $shape_scores{ $input{$player}->{p1} } );

    # part 2
    my $move = which_move( $opponent_moves{$opponent}, $input{$player}->{p2} );
    $ans{2}
        += ( $shape_scores{$move} + $round_scores{ $input{$player}->{p2} } );
}

### FINALIZE - tests and run time
is( $ans{1}, 12855, "Part 1: $ans{1}" );
is( $ans{2}, 13726, "Part 2: $ans{2}" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s / ( 60 * 60 ) ), ( $s / 60 ) % 60, $s % 60, $s * 1000 );
}

sub rules_p1 {
    my ( $opp, $player ) = @_;
    if ( $opp eq $player ) {
        return 'draw';
    }
    elsif ( $game_rules{$opp}->{loses_to} eq $player ) {
        return 'win';

    }
    else {
        return 'lose';
    }
}

sub which_move {
    my ( $opp, $want_to ) = @_;
    if ( $want_to eq 'draw' ) {  
        return $opp;
    }
    elsif ( $want_to eq 'lose' ) {  
        return $game_rules{$opp}->{beats};
    }
    elsif ( $want_to eq 'win' ) {
        return $game_rules{$opp}->{loses_to};
    }
    else {
        die "unknown want to: $want_to";
    }
}

###########################################################
=pod

=head3 Day 2: Rock Paper Scissors

=encoding utf8

This wasn't the easiest to plan out. There were too many repeated
logic lines that I wanted to consolidate. I made a bet on part 2 that
didn't really pan out so had to rearrange a lot. This result is what's
left after cleanup.

=cut
