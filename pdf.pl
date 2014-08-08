#!/usr/bin/perl

use strict;
use warnings;
use PDF::API2;

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

my ($ypos,$endw);

print "Enter the path to the filename: ";
chomp(my $filename=<STDIN>);
if(!-e $filename){
	die "File doesn't exist!\n";
}
open(IN, '<', $filename) or die "Error: $!\n";

my $pdf  = PDF::API2->new(-file => "test.pdf");
my $page = $pdf -> page(); # Make a new page in the pdf file.
$page->mediabox('A4');
#$page->mediabox( 105 / mm, 148 / mm );
$page->cropbox('A4');
#$page->cropbox( 7.5 / mm, 7.5 / mm, 97.5 / mm, 140.5 / mm );
my %font = (
    Helvetica => {
        Bold   => $pdf->corefont( 'Helvetica-Bold',    -encoding => 'latin1' ),
        Roman  => $pdf->corefont( 'Helvetica',         -encoding => 'latin1' ),
        Italic => $pdf->corefont( 'Helvetica-Oblique', -encoding => 'latin1' ),
    },
    Times => {
        Bold   => $pdf->corefont( 'Times-Bold',   -encoding => 'latin1' ),
        Roman  => $pdf->corefont( 'Times',        -encoding => 'latin1' ),
        Italic => $pdf->corefont( 'Times-Italic', -encoding => 'latin1' ),
    },
);
my $blue_box = $page->gfx;
$blue_box->fillcolor('darkblue');
$blue_box->rect(5 / mm, 274 / mm, 200 / mm, 18 / mm );
$blue_box->fill;
my $text = $page->text();
$text->font($font{'Helvetica'}{'Bold'}, 18/pt);
$text->translate(100/mm, 278/mm);
$text->fillcolor('white');
$text->text_center('EGI Part Listing');

$text->font( $font{'Times'}{'Bold'}, 24/pt );
$text->fillcolor('black');
$text->translate(100/mm, 260/mm);
$text->text_center('Stators');
$text->font( $font{'Times'}{'Roman'}, 24/pt );
$text->translate(100/mm, 250/mm);
$text->text_center('  EGI Number  |  Quanity   |  Price   ');

my $posy = 240/mm;

while(<IN>){
	chomp;
	split /,/;
	$text->translate(100/mm, $posy);
	$text->text_center("    $_[0]    $_[1]     $_[2]");
	$posy -= 10/mm;
	if($posy <= 5/mm){
		$pdf->page($page);
		$posy = 292/mm;
		$text->translate(100/mm, $posy);
		$text->text_center('  EGI Number  |  Quanity   |  Price   ');
		$posy -= 10/mm;
	}
}

$pdf->save;
$pdf->end();
close IN;
#my $photo = $page->gfx;
#die("Unable to find image file: $!") unless -e $picture;
#my $photo_file = $pdf->image_jpeg($picture);
#$photo->image( $photo_file, 54 / mm, 66 / mm, 41 / mm, 55 / mm ); # Add picture to pdf.

sub text_block {
    my $text_object = shift;
    my $text = shift;
    my %arg = @_;

    my @paragraphs = split( /\n/, $text ); # Get the text in paragraphs
    my $space_width = $text_object->advancewidth(' '); # calculate width of all words

    my @words = split( /\s+/, $text );
    my %width = ();
    foreach (@words) {
        next if exists $width{$_};
        $width{$_} = $text_object->advancewidth($_);
    }

    $ypos = $arg{'-y'};
    my @paragraph = split( / /, shift(@paragraphs) );
    my $first_line      = 1;
    my $first_paragraph = 1;

    while ( $ypos >= $arg{'-y'} - $arg{'-h'} + $arg{'-lead'} ) { # while we can add another line
        unless (@paragraph) {
            last unless scalar @paragraphs;
            @paragraph = split( / /, shift(@paragraphs) );
            $ypos -= $arg{'-parspace'} if $arg{'-parspace'};
            last unless $ypos >= $arg{'-y'} - $arg{'-h'};
            $first_line      = 1;
            $first_paragraph = 0;
        }
        my $xpos = $arg{'-x'};
        # while there's room on the line, add another word
        my @line = ();
        my $line_width = 0;
        if ( $first_line && exists $arg{'-hang'} ) {
            my $hang_width = $text_object->advancewidth( $arg{'-hang'} );
            $text_object->translate( $xpos, $ypos );
            $text_object->text( $arg{'-hang'} );
            $xpos       += $hang_width;
            $line_width += $hang_width;
            $arg{'-indent'} += $hang_width if $first_paragraph;
        }
        elsif ( $first_line && exists $arg{'-flindent'} ) {
            $xpos       += $arg{'-flindent'};
            $line_width += $arg{'-flindent'};
        }
        elsif ( $first_paragraph && exists $arg{'-fpindent'} ) {
            $xpos       += $arg{'-fpindent'};
            $line_width += $arg{'-fpindent'};
        }
        elsif ( exists $arg{'-indent'} ) {
            $xpos       += $arg{'-indent'};
            $line_width += $arg{'-indent'};
        }

        while (@paragraph and $line_width + ( scalar(@line) * $space_width ) + $width{ $paragraph[0] } < $arg{'-w'} ){

            $line_width += $width{ $paragraph[0] };
            push( @line, shift(@paragraph) );

        }

        # calculate the space width
        my ( $wordspace, $align );
        if ( $arg{'-align'} eq 'fulljustify'
            or ( $arg{'-align'} eq 'justify' and @paragraph ) )
        {
            if ( scalar(@line) == 1 ) {
                @line = split( //, $line[0] );
            }
            $wordspace = ( $arg{'-w'} - $line_width ) / ( scalar(@line) - 1 );
            $align = 'justify';
        }
        else {
            $align = ( $arg{'-align'} eq 'justify' ) ? 'left' : $arg{'-align'};
            $wordspace = $space_width;
        }
        $line_width += $wordspace * ( scalar(@line) - 1 );
        if ( $align eq 'justify' ) {
            foreach my $word (@line) {
                $text_object->translate( $xpos, $ypos );
                $text_object->text($word);
                $xpos += ( $width{$word} + $wordspace ) if (@line);
            }
            $endw = $arg{'-w'};
        }
        else {
            # calculate the left hand position of the line
            if ( $align eq 'right' ) {
                $xpos += $arg{'-w'} - $line_width;
            }
            elsif ( $align eq 'center' ) {
                $xpos += ( $arg{'-w'} / 2 ) - ( $line_width / 2 );
            }
            # render the line
            $text_object->translate( $xpos, $ypos );
            $endw = $text_object->text( join( ' ', @line ) );
        }
        $ypos -= $arg{'-lead'};
        $first_line = 0;
    }
    unshift( @paragraphs, join( ' ', @paragraph ) ) if scalar(@paragraph);
    return ( $endw, $ypos, join( "\n", @paragraphs ) )
}