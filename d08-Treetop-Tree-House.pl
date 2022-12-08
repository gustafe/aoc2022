#! /usr/bin/env perl
# Advent of Code 2022 Day 8 - Treetop Tree House - complete solution
# https://adventofcode.com/2022/day/8
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
my $Map;
my $max_r = $#input;
my $max_c;
my $seen;
for my $row ( 0 .. $#input ) {
    my @line = split //, $input[$row];
    $max_c = $#line;
    for my $col ( 0 .. $#line ) {
        $Map->[$row][$col] = $line[$col];
        $seen->{$row}{$col}++
            if ( $row == 0 or $row == $max_r or $col == 0 or $col == $max_c );
    }
}



for my $col ( 1 .. $max_c - 1 ) {
    # top, looking down
    my $max_height_top = $Map->[0][$col];
    for my $row ( 1 .. $max_r - 1 ) {
        if ( $Map->[$row][$col] > $max_height_top ) {
            $seen->{$row}{$col}++;
            $max_height_top = $Map->[$row][$col];
        }
    }
    # bottom, looking up
    my $max_height_bot = $Map->[$max_r][$col];
    for ( my $row = $max_r - 1; $row > 0; $row-- ) {
        if ( $Map->[$row][$col] > $max_height_bot ) {
            $seen->{$row}{$col}++;
            $max_height_bot = $Map->[$row][$col];
        }
    }

}

for my $row ( 1 .. $max_r - 1 ) {
    # left, looking right
    my $max_height_left = $Map->[$row][0];
    for my $col ( 1 .. $max_c - 1 ) {
        if ( $Map->[$row][$col] > $max_height_left ) {
            $seen->{$row}{$col}++;
            $max_height_left = $Map->[$row][$col];
        }
    }
    # right, looking left
    my $max_height_right = $Map->[$row][$max_c];
    for ( my $col = $max_c - 1; $col > 0; $col-- ) {
        if ( $Map->[$row][$col] > $max_height_right ) {
            $seen->{$row}{$col}++;
            $max_height_right = $Map->[$row][$col];
        }
    }

}


if ($testing) {
    say "top-left 5 (1,1): " . $seen->{1}{1};
    say "top-middle 5 (1,2): " . $seen->{1}{2};
    say "left-middle 5 (2,1): " . $seen->{2}{1};
    say "right-middle 3 (2,3): " . $seen->{2}{3};
    say "bottom-middle 5 (3,2): " . $seen->{3}{2};
}

my $count = 0;
for my $row ( keys %$seen ) {
    for my $col ( keys %{ $seen->{$row} } ) {
        $count++ if $seen->{$row}{$col};
    }
}


### Part 2

my $distances;
for my $row ( 1 .. $max_r - 1 ) {
    for my $col ( 1 .. $max_c - 1 ) {
        my $curr = $Map->[$row][$col];

        # look up
        my $up = 0;
    UP: for ( my $r = $row - 1; $r >= 0; $r-- ) {
            $up++;
            last UP if $Map->[$r][$col] >= $curr;
        }
        $distances->{$row}{$col}{up} = $up;

        # look down
        my $down = 0;
    DOWN: for ( my $r = $row + 1; $r <= $max_r; $r++ ) {
            $down++;
            last DOWN if $Map->[$r][$col] >= $curr;
        }
        $distances->{$row}{$col}{down} = $down;

        # look right
        my $right = 0;
    RIGHT: for ( my $c = $col + 1; $c <= $max_r; $c++ ) {
            $right++;
            last RIGHT if $Map->[$row][$c] >= $curr;
        }
        $distances->{$row}{$col}{right} = $right;

        # look left
        my $left = 0;
    LEFT: for ( my $c = $col - 1; $c >= 0; $c-- ) {
            $left++;
            last LEFT if $Map->[$row][$c] >= $curr;
        }
        $distances->{$row}{$col}{left} = $left;
    }
}

# find max distance
my $max_score = 0;
for my $row ( 1 .. $max_r - 1 ) {
    for my $col ( 1 .. $max_c - 1 ) {
        my $d
            = $distances->{$row}{$col}{up}
            * $distances->{$row}{$col}{down}
            * $distances->{$row}{$col}{left}
            * $distances->{$row}{$col}{right};
        if ( $d > $max_score ) {
            $max_score = $d;
        }
    }
}

### FINALIZE - tests and run time
is( $count, 1807,   "Part 1: $count" );
is( $max_score,   480000, "Part 2: $max_score" );
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

=head3 Day 8: Treetop Tree House

=encoding utf8

As usual, a bit fiddly with all the different directions and repeated code. 

Score: 2

Rating: 3/5

=cut

