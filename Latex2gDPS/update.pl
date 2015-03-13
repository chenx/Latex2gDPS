#!/usr/bin/perl 

#
# This script is used to update the io/*/*.o files.
# It calls ./pn on each of the io/*/*.i files to update the 
# corresponding *.o files.
#
# @author: Xin Chen
# @created on: 11/28/2007
# @last updated: 11/28/2007
#

use strict;

my $working_dir;
my $working_file;
my $dir_io = "io";
my $dir_ok = "testcase";
my $tmp = "$dir_ok/cmp.tmp";
my @files = ("COV", "ILP", "ILP2", "KS01", "LSP", "MCM", "SCP", "SPA", "SPC", "SPC2", "TSP", "WLV");
my $files_ct = @files;
my ($infile, $outfile, $testfile);

print "testing pn...\n";
print "compare out to testcase/out\n";

foreach (@files) {
  $working_dir = "./io/$_";
  $infile = "$working_dir/$_.i";
  if (! -e $infile) { print "error: $infile does not exist\n"; next; }
  $outfile = "$working_dir/$_.o";
  system("./pn $infile > $tmp");
  print "update $outfile ... ok\n"; 
}

1;

