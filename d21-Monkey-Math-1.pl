#! /usr/bin/env perl
# Advent of Code 2022 Day 21 - Monkey Math - part 1 
# https://adventofcode.com/2022/day/21
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
my $M;
for my $line (@input) {
    if ($line =~ /^(\S+): (\d+)$/) {
	$M->{$1}= {yells=>$2};
    } elsif ($line =~ /^(\S+): (\S+) (.) (\S+)$/) {
	$M->{$1} = {p1=>$2, op=>$3, p2=>$4};
    } else {
	die "can't parse $line";
    }
}
my $round =0;
while (! defined $M->{root}{yells}) {
    my $yells=0;
    my $solved=0;
    for my $k (keys %$M) {
	if (defined $M->{$k}{yells}) {
	    $yells++;
	    next;
	}
	if (defined $M->{$M->{$k}{p1}}{yells} and
	    defined $M->{$M->{$k}{p2}}{yells}) {
	    my $res = eval( $M->{$M->{$k}{p1}}{yells} . $M->{$k}{op} .$M->{$M->{$k}{p2}}{yells});
	    die "weird result! $res" unless $res =~ /\d+/;
	    $M->{$k}{yells}=$res;
	    $solved++;
	}
    }
    say "$round: yells = $yells, solved = $solved";
    $round++;
}
my $ans =  $M->{root}{yells};
### FINALIZE - tests and run time
is($ans, 124765768589550,"Part 1: $ans");
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

=head3 Day 21: Monkey Math, part 1

=encoding utf8

Score: 1

Leaderboard completion time: 16m15s

=cut

