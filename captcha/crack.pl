#!/usr/bin/perl
# Captcha cracker? v1.0
# Written by nue

use strict;
use warnings;
use Image::Magick;

my $img;

die "Usage is: $0 imagefile\n" if(@ARGV!=1 || !-e $ARGV[0]);
open(IMG, '<', $ARGV[0]) or die "Error: $!\n"; # Open the image.

$img = Image::Magick->new;
$img->Read(file=>\*IMG); # Read the image.

$img->Quantize(colorspace=>'gray'); # Grayscale the image.

# Use different blur factors to produce different images for the ocr?
#$img->SelectiveBlur(threshold=>0.53, sigma=>1.4, channel=>'All');
$img->Solarize(threshold=>0.51, channel=>'All');
$img->WhiteThreshold();
$img->GaussianBlur(sigma=>1.2);
$img->WhiteThreshold(); # White owt! :)
$img->Trim(); # Clip the edges.
# Possibly split the image into multiple single char images?
$img->Write(filename=>"111.png", compression=>'None'); # Save the file to the disc.
# `./ocr $ARGV[0].tmp` # Feed the filtered image into the OCR.
close IMG;
