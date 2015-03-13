#!/usr/bin/perl 

use strict;

my $working_dir;
my $working_file;
my $dir_io = "io";
my $dir_ok = "testcase";
my $tmp = "$dir_ok/cmp.tmp";
my @files = ("BST", "COV", "ILP", "ILP2", "KS01", "LSP", "ODP", "MCM", "SCP", "SPA", "SPC", "SPC2", "TSP");
my $files_ct = @files;
my ($infile, $outfile, $testfile);

print "testing pn...\n";
print "compare out to testcase/out\n";

foreach (@files) {
  $working_dir = "./io/$_";
  $infile = "$working_dir/$_.test.i";
  if (! -e $infile) { print "error: $infile does not exist\n"; next; }
  $outfile = "$working_dir/$_.test.o";
  $testfile = "$dir_ok/$_.test.o";
  system("./pn $infile > $tmp");
  system("diff $outfile $testfile");
  system("diff $outfile $testfile > $tmp");
  if (-s $tmp > 0) { print "test $outfile ... err\n"; }
  else { print "test $outfile ... ok\n"; }
}

1;

