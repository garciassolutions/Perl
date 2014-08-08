#!/usr/bin/perl

$|++;

use strict;

my $MAX = 1000;

my @nums = (1..$MAX);
my @array;
my %matrix; # Starts at 2.
my %offset;
my ($x, $y, $p);

die "perl $0 [length]" if(!@ARGV);

for $y (2..$MAX){
  while($x < $MAX){
    map {$array[$p] .= (($nums[$x++]%$y)?"0":"1")} (1..$ARGV[0]);
    $p++;
  }
  for(0..$MAX-1){
    if($array[$_] =~ /1/){ # Find the first number in our pattern.
      $p = $_;
      last;
    }
  }
  for my $r(($p+1)..$MAX){
    if($array[$p] eq $array[$r]){
      $offset{$y} = $p;
      for($p..($r-1)){
        $matrix{$y} .= $array[$_] . " ";
      }
      last;
    }
  }
  undef(@array);
  $x=$p=0;
}

map {print "$_ +" . $offset{$_} . " $matrix{$_}\n"} (2..$MAX);
