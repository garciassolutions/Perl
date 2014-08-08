#!/usr/bin/perl

use strict;

my @array;

for my $x (@ARGV){
        for(0..25){
                $x =~ tr/A-Za-z/B-ZA-Ab-za-a/;
                $array[$_] .= "$x ";
        }
}
for(0..25){
        print $_+1, " :: $array[$_]\n";
}

