#!/usr/bin/perl

# ipdf
# http://search.cpan.org/dist/PDF-Reuse/
# http://search.cpan.org/~areibens/PDF-API2-0.73/lib/PDF/API2.pm

use strict;
use PDF::API2;
use PDF::Reuse;

my $IN = "stack.pdf";
my $OUT = "done_stack.pdf";

my $ipdf = PDF::API2->open($IN);
my $pages = $ipdf->pages; # How many pages are there?
$ipdf->end();
prFile($OUT);

my $intName = prFont("Helvetica"); # Set the font.
my $string =  "q\nBT\n/$intName 1 Tf\n" .
# set a text matrix
# 1. width of text
# 2. rotation angle (counterclockwise)
# 3. inclination (clockwise)
# 4. height of text
# 5. position x (0=left)
# 6. position y (0=bottom)    
"12 0 0 12 0 0 Tm\n" .        
#"1 0 0 rg" . # set rgb-color (values between 0 and 1)
"1 g\n" . # White 1, Black 0.
"(192.168.1.100 :: sample\@aol.com) Tj\n" . # The Watermark you'd like to add
"ET\n" .
"Q\n";

for (my $i=1;$i<=$pages;$i++){
    my $internalName = prForm( # Add what was on the page prior to the watermark.
    	{
            file     => $IN,
            page     => $i,
            effect   => 'print',
            tolerant  => 'no'
        } 
    );
    prAdd($string);
    prPage; # Add a pagebreak.
}

prEnd(); # Save and close.
