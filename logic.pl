#!/usr/bin/perl

use strict;

my ($c, $x, $f);

# $x will contain the number of elements we're dealing with.
# $c will hold the count to determine which number we should get.
# $f will hold our eval string.

my %p = map {$_,0} split(/\W+/, $f=$ARGV[0]);
delete $p{""};
for(sort(keys(%p))){
	print "$_ ";$c=++$x;
}
print "| $f\n", "-"x($x*2), '+', "-"x(length($f)+6), "\n";
for my $o(0..(2**$x)-1){
	for(sort(keys(%p))){ 
  	$p{$_} = substr(sprintf("%0*b", $x, $o), $c++%$x, 1); # Get bit value and store it in the letter value.
    $f =~ s/$_/$p{$_}/g; # Change every letter to its corresponding bit value.
    print "$p{$_} "; # Display.
  }
  $f =~ s/\s//g;
  print "  $f -> ", eval($f), "\n"; # Display what the logic would look like and the result.
  $f=$ARGV[0]; # Change the eval string back to the logic string.
}
