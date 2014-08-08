#!/usr/bin/perl

use PDF::Reuse;
use PDF::Reuse::Util;
use strict;

# die "Usage is: perl $0 \"Message to add\" file.pdf\n" if(@ARGV != 2);

my $to_add = "Lawlerskatez on you!\n";
my $left = 1;
my $IN = "stack.pdf";
my $OUT = "tmp_" . $IN;

prFile($OUT);
while ($left) {
   prFont("Helvetica");
   prAdd("0 0 0 rg\n0 g\nf\n");
   prText(38, 800, $to_add);
   $left = prSinglePage($IN);   
} 

prEnd;
