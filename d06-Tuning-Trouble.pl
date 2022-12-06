#! /usr/bin/env perl
# Advent of Code 2022 Day 6 - Tuning Trouble - complete solution
# https://adventofcode.com/2022/day/6
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

my %parts = (
	     1 => { window_size  => 4,
		    test_results => '7,5,6,10,11',
		    answer       => 1816 },
	     2 => {
		   window_size  => 14,
		   test_results => '19,23,23,29,26',
		   answer       => 2625 },);

### CODE
for my $part ( sort keys %parts ) {
    my $WINDOW = $parts{$part}->{window_size};
    for my $line (@input) {
        my @signal = split //, $line;
        my $start  = 0;
        while ( $start + $WINDOW - 1 <= $#signal ) {
            my %freq
                = map { $_ => 1 } @signal[ $start .. $start + $WINDOW - 1 ];

            if ( scalar keys %freq == $WINDOW ) {
                push @{ $parts{$part}->{ans} }, $start + $WINDOW;
                last;
            }
            $start++;
        }
    }
}

for my $part ( sort keys %parts ) {
    if ($testing) {
        is( join( ',', @{ $parts{$part}->{ans} } ),
            $parts{$part}->{test_results},
            "testing part $part ok"
        );
    } else {
        is( $parts{$part}->{ans}->[0],
            $parts{$part}->{answer},
            "Part $part: " . $parts{$part}->{answer}
        );
    }
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

=head3 Day 6: Tuning Trouble

=encoding utf8

An easy problem. I'm happy I went with my first instinct (using the
number of hash keys to detect (lack of) duplicates), along with
parametrizing the window size, because that made part 2 trivial. That
said my finishing standings were in the 16,000s despite a personal
best finishing time this year.

Score: 2

Puzzle rating: 3/5, too easy to make this really interesting.

=cut

