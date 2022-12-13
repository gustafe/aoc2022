#! /usr/bin/env perl
use Modern::Perl '2015';
use Pod::Markdown;
###
use utf8;

my %opts = ( output_encoding => 'UTF-8',);

my $dir = '.';
my $readme = "$dir/README.md";
opendir( D, $dir) or die "can't open directory: $!";
my @files = grep {(!/^\./) and -f "$dir/$_" and ($_ =~ m/^d.*\.pl$/) } readdir(D);
closedir D;

open(my $out_fh, ">", $readme) or die "can't open $readme for writing: $!";
my $md_string;
my @entries;
my $score_sum;
for my $f (sort {$b cmp $a} @files) {
    my $str;
    open( my $in_fh, '<:encoding(UTF-8)', "$dir/$f") or die "can't open $dir/$f for reading: $!";

    my $parser = Pod::Markdown->new(%opts);
    $parser->output_string($str);
    $parser->parse_file( $in_fh);

    if ($str =~ m/^Score\:.*(\d+)/m) {
	$score_sum += $1;
    }
    push @entries, $str;
    close $in_fh;
}
my $top = shift @entries;
say $out_fh $top;
say $out_fh "Running score: $score_sum / ". (scalar (@entries))*2 ."\n";
for my $e (@entries) {
    say $out_fh $e;
}

close $out_fh;

sub get_handle {
  my ($path, $op, $default) = @_;
  (!defined($path) || $path eq '-') ? $default : do {
    open(my $fh, $op, $path)
      or die "Failed to open '$path': $!\n";
    $fh;
  };
}
