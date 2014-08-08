#!/usr/bin/perl

use strict;
#use warnings;

for(<*.mp3>){
	my ($artist, $title, $cd, $track);
	for(`id3info '$_'`){
		if(/TIT2.*: (.*)/){
			$title = $1;
		}
		if(/TPE1.*: (.*)/){
			$artist = $1;
		}
		if(/TRCK.*: (\d+)/){
			$track = $1;
		}
		if(/TALB.*: (.*)/){
			$cd = $1;
		}
	}
	if($artist && $title && $cd){
		if(!-d $artist){
			mkdir($artist);
		}
		if(!-d "$artist/$cd"){
			mkdir("$artist/$cd");
		}
		if($track < 10 && length($track) < 2){
			$track = "0$track";
		}
		#print "$_ -> $artist/$cd/$track - $title.mp3\n";
		rename("$_", "$artist/$cd/$track - $title.mp3");
	}
}

