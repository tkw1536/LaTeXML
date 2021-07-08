#!/usr/bin/env perl

use strict;
use Parse::RecDescent;
use Data::Dumper;

my $grammar = <<'OVERLAYGRAMMAR';
parse : 
    modespec(s /|,/)

# a single mode specification is either a mode, a sliderange, or both
modespec : 
      mode '@' sliderange   { $return = [ "mode" => $item[1], "range" => $item[3] ] }
    | mode                  { $return = [ "mode" => $item[1], "range" => undef    ] }
    | sliderange            { $return = [ "mode" => undef,    "range" => $item[1] ] }

# a range of slides
sliderange : 
      slidenumber '-' slidenumber { $return = [ "from" => $item[1], "to" => $item[3] ] }
    | '-' slidenumber             { $return = [ "from" => undef,    "to" => $item[2] ] }
    | slidenumber '-'             { $return = [ "from" => $item[1], "to" => undef    ] }
    | slidenumber                 { $return = [ "from" => $item[1], "to" => $item[1] ] }

slidenumber : 
      relative  { $return = [ "kind" => "relative", "value" => $item[1] ] }
    | posint    { $return = [ "kind" => "absolute", "value" => $item[1] ] }

# relative specification - denoted by either a '.' or '+'
relative : 
      modifier '(' int ')' { $return = [ "modifier" => $item[1], "offset" => $item[3] ] }
    | modifier             { $return = [ "modifier" => $item[1], "offset" => undef    ] }

modifier : '.' | '+'

# positive and normal integers => return the kind integer
int: /-?[0-9]*/       { $return = $item[1] + 0 }
posint: /[1-9][0-9]*/ { $return = $item[1] + 0 }

# modes for beamer
mode: 'all' | 'presentation' | 'article' | 'beamer' | 'second' | 'handout' | 'trans' | 'alert'

OVERLAYGRAMMAR

my $parser = Parse::RecDescent->new($grammar);

sub doParse {
    my ($text) = @_;
    print '$parser->parse("';
    print $text;
    print "\")\n";

    my $res = $parser->parse($text);
    print Dumper($res);
}

doParse($ARGV[0]);