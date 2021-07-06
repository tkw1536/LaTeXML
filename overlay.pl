#!/usr/bin/perl
sub parseOverlayRanges {
    my ($spec, $lastPlus) = @_;
    my ($start, $end, @ranges);
    # iterate over each spec of the array
    for my $overlay (split /,/, $spec) {
        ($start, $end, $lastPlus) = parseOverlayRange($overlay, $lastPlus);
        push(@ranges, [$start, $end]); }
    return \@ranges, $lastPlus; }

# parses an overlay range from a string.
# takes as parameter the last encountered '+' character, and returns a triple ($start, $end, $lastPlus).
sub parseOverlayRange {
    my ($start, $lastPlus, $rest) = parseOverlaySpec(@_);
    # we don't have a rest to parse => we are done!
    return $start, $start, $plus unless ($rest =~ /^-/);
    # parse the second part
    my ($end, $endPlus, $ignored) = parseOverlaySpec(substr($rest, 1), $lastPlus);
    return $start, $end, $endPlus; }

# parseOverlaySpec parses a part of a specification.
# It takes a specification,and the last encountered '+' character.
# It returns the overlay to be used (or -1 if omitted), the new last value of the plus, and the rest to be parsed
# See https://web.archive.org/web/20140122005751/https://www.texdev.net/2014/01/17/the-beamer-slide-overlay-concept/. 
sub parseOverlaySpec {
    my ($spec, $lastPlus) = @_;
    # no spec provided => we are done
    return -1, $lastPlus, '' if ($spec eq '');
    # only a '-' => we only have an ending!
    my $start = substr($spec, 0, 1);
    return -1, $lastPlus, $spec if ($start eq '-');
    # only a number!
    if ($start =~ /^[0-9]/) {
        ($start, $spec) = ($spec =~ /^(\d+)(.*)$/);
        return $start + 0, $lastPlus, $spec; }
    # must have a '.' or a '+', or we have something weird!
    return -1, 0, '' unless ($start eq '.' || $start eq '+');
    $spec =~ s/^.//;
    my ($inc) = 0;
    # if we have a bracket, start with
    if ($spec =~ /^\(/) {
        ($inc, $spec) = ($spec =~ /^(\([^\)]+\))(.*)$/);
        $inc = substr($inc, 1, -1) + 0; }
    # if we don't have a specific offset, it is 0.
    elsif ($start eq '+') { $inc = 1; }
    my $current = $lastPlus + $inc;
    $lastPlus = $current if ($start eq '+');
    return $current, $lastPlus, $spec; }

use Data::Dumper;

$globalPlus = 0;
sub spec {
    my ($spec) = @_;
    print "parseOverlayRanges('$spec', $globalPlus)\n";
    my ($ranges);
    ($ranges, $globalPlus) = parseOverlayRanges($spec, $globalPlus);
    print Dumper($ranges, $globalPlus);
}

spec("+-,-+");