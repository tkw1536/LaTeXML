# /=====================================================================\ #
# |  LaTeXML::Post::BiBTeX::Cmd::bibtexmlr                              | #
# | bibtexmlr entry point                                               | #
# |=====================================================================| #
# | Part of LaTeXML                                                     | #
# |---------------------------------------------------------------------| #
# | Tom Wiesing <tom.wiesing@gmail.com>                                 | #
# \=====================================================================/ #
## no critic (Subroutines::RequireArgUnpacking InputOutput::RequireCheckedOpen BuiltinFunctions::ProhibitStringyEval);

package LaTeXML::Post::BiBTeX::Cmd::bibtexmlr;

use strict;
use warnings;

use Getopt::Long qw(GetOptionsFromArray);

use LaTeXML::Post::BiBTeX::Runner;
use LaTeXML::Post::BiBTeX::Common::Utils qw(slurp);
use LaTeXML::Post::BiBTeX::Runtime::Utils qw(fmtLogMessage);

sub main {
  shift(@_);    # remove the first argument
  my ($output, $macro, $cites, $wrap, $help) = (undef, undef, "*", 0, 0);
  GetOptionsFromArray(
    \@_,
    "destination=s" => \$output,
    "macro=s"       => \$macro,
    "cites=s"       => \$cites,
    "wrap"          => \$wrap,
    "help"          => \$help,
  ) or return usageAndExit(1);
  # if we requested help, or we had a wrong number of arguments, exit
  return usageAndExit(0) if $help;
  return usageAndExit(1) if scalar(@_) == 0;
  # parse arguments
  my ($input, @bibfiles) = @_;
  # read the the compiled code
  my $compiled = eval slurp($input);
  unless (ref $compiled eq 'CODE') {
    print STDERR "Compilation error: Expected CODE but got '" . ref $compiled . "'";
    return 3; }
  # create a reader for the bib files
  my $reader;
  my (@bibreaders);
  foreach my $bibfile (@bibfiles) {
    $reader = LaTeXML::Post::BiBTeX::Common::StreamReader->newFromFile($bibfile);
    unless (defined($reader)) {
      print STDERR "Unable to find bibfile $bibfile\n";
      return 4; }
    push(@bibreaders, $reader); }
  # prepare the output file
  my $ofh;
  if (defined($output)) {
    open($ofh, ">", $output); }
  else {
    $ofh = *STDOUT; }
  unless (defined($ofh)) {
    print STDERR "Unable to find $output";
    return 5; }
  # create a run
  my @citations = split(/,/, $cites);
  my $runcode = createRun(
    $compiled,
    [@bibreaders],
    [@citations],
    $macro,
    sub { print STDERR fmtLogMessage(@_) . "\n"; },
    $ofh,
    $wrap);
  # and run the code
  my ($rstatus) = &{$runcode}();
  return $rstatus; }

# helper function to print usage information and exit
sub usageAndExit {
  my ($code) = @_;
  print STDERR
'bibtexmlr [--help] [--wrap] [--destination $DEST] [--cites $CITES] [--macro $MACRO] $COMPILED_BST $BIBFILE [$BIBFILE ...]'
    . "\n";
  return $code; }

1;