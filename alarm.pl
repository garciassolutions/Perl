#!/usr/bin/perl

# Alarm Clock 3.2.
# Coded by JuggaloAnt
# irc.oftc.net #nerds

use strict;
 
$0 = "Alarm Clock";
my @stuff = split("\@", $ARGV[0]);

die "Usage is: perl $0 \"mp3\"\@HH:MM\n" unless scalar(@stuff) == 2;
die "Time must be HH:MM in a 24 hour time format.\n" unless $stuff[1] =~ /(\d{2}):(\d{2})/;
die "HH:MM must cannot be greater than 23:59.\n" unless ($1 < 24 && $2 < 60);
my $pid = fork; 
die "Error forking :: $!\n" unless defined $pid;
if($pid){   
  print "Alarm set \@ $stuff[1]\n";
  exit;
}
while(1){
  my $time = localtime(time);
  $time =~ s/.*(\d{2}:\d+):\d+.*/$1/;
  if($time eq $stuff[1]){
    my @array = `ps aux|grep xmms`;
    for(@array){                   
      chomp;
      /\d+/;
      kill 9, $&;
    }
    sleep 5;
    system("xmms \"$stuff[0]\"");
    exit;
  }
  sleep 20;
}
