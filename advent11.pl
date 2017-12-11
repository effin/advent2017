use strict;
use warnings FATAL => 'all';
use List::Util qw[min max];

open(my $filehandle, '<', 'input11.txt') or die "Unable to open file, $!";
while (<$filehandle>) {
    my @arr = split(/,/, $_);
    my $x = 0;
    my $y = 0;
    my $m = 0;
    foreach (@arr) {
        if ($_ eq "ne") {
            $x += 1;
        }
        elsif ($_ eq "sw") {
            $x -= 1;
        }
        elsif ($_ eq "s") {
            $y += 1;
        }
        elsif ($_ eq "n") {
            $y -= 1;
        }
        elsif ($_ eq "se") {
            $x += 1;
            $y += 1;
        }
        elsif ($_ eq "nw") {
            $x -= 1;
            $y -= 1;
        }
        $m = max(abs($x), abs($y), $m);
    }
    my $r = max(abs($x), abs($y));
    print "\nr is $r";
    print "\nm is $m";
}