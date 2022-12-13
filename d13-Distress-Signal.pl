#! /usr/bin/env perl
# Advent of Code 2022 Day 13 - Distress Signal - complete solution
# https://adventofcode.com/2022/day/13
# https://gerikson.com/files/AoC2022/UNLICENSE
###########################################################
use Modern::Perl '2015';

# useful modules
use List::Util qw/sum min product/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
sub sec_to_hms;
sub compare_lists;
sub compare_items;
my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

my %pairs;
### CODE
my $index      = 1;
my $line_count = 0;
my @allpackets;
for my $line (@input) {
    if ( length $line > 0 ) {
        $pairs{$index}->[$line_count] = eval $line;
        push @allpackets, eval $line;
        $line_count++;
    } else {
        $line_count = 0;
        $index++;
    }
}
my $sum = 0;
for my $index ( sort { $a <=> $b } keys %pairs ) {
    my $res = compare_lists( @{ $pairs{$index} } );
    $sum += $index if $res;

}


my $marker1 = [ [2] ];
my $marker2 = [ [6] ];
push @allpackets, ( $marker1, $marker2 );
my @sorted = sort { compare_items( $a, $b ) } @allpackets;
my @indices;
$index = 1;
for my $item (@sorted) {
    if ( $item eq $marker1 or $item eq $marker2 ) {
        push @indices, $index;
    }
    $index++;
}
my $product = product @indices;
### FINALIZE - tests and run time
is( $sum,     6656,  "Part 1: $sum" );
is( $product, 19716, "Part 2: $product" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub compare_items {    # custom compare function
    my ( $left, $right ) = @_;
    return -1 if compare_lists( $left,  $right );    # left < right
    return 1  if compare_lists( $right, $left );     # left > $right
    return 0;                                        # equal
}

sub compare_lists {

# Credit /u/ProfONeill
# https://www.reddit.com/r/adventofcode/comments/zkmyh4/2022_day_13_solutions/j00qrmp/
    my ( $left, $right ) = @_;
    die "invalid input!" unless ( defined $left and defined $right );
    if ( ref $left eq 'ARRAY' and ref $right eq 'ARRAY' ) {
        my $min = min( scalar @$left, scalar @$right );
        for ( my $idx = 0; $idx < $min; $idx++ ) {
            my $res = compare_lists( $left->[$idx], $right->[$idx] );
            return $res if defined $res;
        }
        if ( scalar @$left < scalar @$right ) {
            return 1;
        } elsif ( scalar @$left > scalar @$right ) {
            return 0;
        } else {
            return undef;
        }
    } elsif ( ref $left eq 'ARRAY' ) {
        return compare_lists( $left, [$right] );
    } elsif ( ref $right eq 'ARRAY' ) {
        return compare_lists( [$left], $right );
    } else {
        return 1 if $left < $right;
        return 0 if $left > $right;
        return undef;
    }
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 13: Distress Signal

=encoding utf8

I took a punt on today and found a nice perlish solution in the daily solutions thread. Credit in source!

Score: B<0>

Rating: 3/5

=cut
