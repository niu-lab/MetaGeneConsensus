#####
# Authors: Ruilin Li et al.
# This script changes from Dr. Weizhong Li's script of transforming ORFs to proteins.
#####

#!/usr/bin/perl

#my $script_dir = $0;
#   $script_dir =~ s/[^\/]+$//;
#   $script_dir = "./" unless ($script_dir);
#
#my $exe = $script_dir . "metagene";
my $input = shift; # fasta file
my $output_raw = shift; # in fact, the output_raw is the input file
my $output = shift;
die unless ($input and $output);
print "Fasta file: $output_raw\nInput ORFs: $input\nCorrected ORfs: $output\n";

my %genetic_code = (
  'UUU' => 'F',  'UCU' => 'S',  'UAU' => 'Y',  'UGU' => 'C',
  'UUC' => 'F',  'UCC' => 'S',  'UAC' => 'Y',  'UGC' => 'C',
  'UUA' => 'L',  'UCA' => 'S',  'UAA' => '*',  'UGA' => '*',
  'UUG' => 'L',  'UCG' => 'S',  'UAG' => '*',  'UGG' => 'W',

  'CUU' => 'L',  'CCU' => 'P',  'CAU' => 'H',  'CGU' => 'R',
  'CUC' => 'L',  'CCC' => 'P',  'CAC' => 'H',  'CGC' => 'R',
  'CUA' => 'L',  'CCA' => 'P',  'CAA' => 'Q',  'CGA' => 'R',
  'CUG' => 'L',  'CCG' => 'P',  'CAG' => 'Q',  'CGG' => 'R',

  'AUU' => 'I',  'ACU' => 'T',  'AAU' => 'N',  'AGU' => 'S',
  'AUC' => 'I',  'ACC' => 'T',  'AAC' => 'N',  'AGC' => 'S',
  'AUA' => 'I',  'ACA' => 'T',  'AAA' => 'K',  'AGA' => 'R',
  'AUG' => 'M',  'ACG' => 'T',  'AAG' => 'K',  'AGG' => 'R',

  'GUU' => 'V',  'GCU' => 'A',  'GAU' => 'D',  'GGU' => 'G',
  'GUC' => 'V',  'GCC' => 'A',  'GAC' => 'D',  'GGC' => 'G',
  'GUA' => 'V',  'GCA' => 'A',  'GAA' => 'E',  'GGA' => 'G',
  'GUG' => 'V',  'GCG' => 'A',  'GAG' => 'E',  'GGG' => 'G',
);



#my $output_raw = "$output.raw";
#my $cmd = `$exe $input > $output_raw`;
my $raw_format =<<EOD;
# gi|29839769|ref|NC_003361.3| Chlamydophila caviae GPIC, complete genome
# gc = 0.392229
# bacteria
57      1052    +       0       58.5929 complete
1068    2480    -       0       69.9334 complete
2502    2936    -       0       29.7579 complete
3048    5201    +       0       130.812 complete
EOD

my %raw_results = ();

open(RAW, $output_raw) || die;
if (1) {
  my $ll;
  my $id1;

  while ($ll=<RAW>) {
    if ($ll =~ /^#/) {
      chop($ll); $id1 = (split(/\s+/,$ll))[1];
      $ll=<RAW>; $ll=<RAW>;
      while($ll=<RAW>){
        last unless ($ll =~ /^\d/);
        if (not defined($raw_results{$id1})) {$raw_results{$id1}=[];}
        push(@{$raw_results{$id1}}, $ll);
      }
    }
  }
close(RAW);
} ########## END if (1)


open(FASTA, $input) || die;
open(OUT, "> $output") || die;

my $seq = "";
my $des = "";
my $ll;

while($ll=<FASTA>){
  if ($ll=~ /^>/){
    if ($seq) { process_this($des, $seq); }
    $des = $ll;
    $seq = "";
  }
  else {
    $ll =~ s/\W//g;
    $seq .= $ll;
  }
}
    if ($seq) { process_this($des, $seq); }
close(FASTA);
close(OUT);


sub process_this {
  my ($des, $seq) = @_;
  $seq = uc($seq); $seq =~ s/T/U/g;

  my $full_len = length($seq);
  my $id = (split(/\s+/, substr($des,1)))[0];

  return unless defined($raw_results{$id});
  my $ll;

  my $tid=1;
  foreach $ll (@{$raw_results{$id}}) {
    #my ($b, $e, $s, $f, $other) = split(/\s+/, $ll);
    my ($b, $e, $s, $f, $other) = split(/\s+/, $ll);
    my $prefix=join("\t", (split(/\s+/, $ll))[4..9]);
    if ($s eq "+") {$b += $f;}
    else           {$e -= $f;}

    while(1){
      my $len = $e-$b+1;
      last if ($len%3 == 0);
      if ($s eq "+") {$e--;}
      else           {$b++;}
    }

    my $modb = ($s eq "-") ? $full_len-$e : $b-1;
       $f = $modb %3; $f++;
    my $frame = ($s eq "+") ? $f : $s.$f;
    my $len = $e-$b+1;
print STDERR "Wrong length of ORF $ll\n" unless ( $len%3 == 0);
    my $subseq = substr($seq,$b-1,$len);
       $subseq = comp_strand($subseq) if ($s eq "-");
    my $prot = translate($subseq);
    my $lenp = length($prot); $lenp-- if ($prot =~ /\*$/);
       #$prot =~ s/(.{70})/$1\n/g;
       $prot .= "\n" unless ($prot =~ /\n$/);

    print OUT ">$id.$tid /source=$id /start=$b /end=$e /frame=$frame /length=$lenp|$prefix\n";
    print OUT $prot;
    $tid++;
  }

}########## END process_this


sub translate {
  my $seq = shift;
  my $prot = "";
  my $len = length($seq);
  my ($i, $c);

  for ($i=0; $i<$len; $i+=3) {
    $c = substr($seq,$i,3);
    $c = $genetic_code{$c};
    $c = "X" unless ($c);
    $prot .= $c;
  }
  return $prot;

}########## END translate

sub comp_strand {
  my $seq = shift;
     $seq = reverse($seq);
  my $comp_seq = "";
  my %comp_c = qw/A U U A C G G C/;
  my $len = length($seq);
  my ($i, $c);

  for ($i=0; $i<$len; $i++) {
    $c = substr($seq,$i,1);
    $c = $comp_c{$c};
    $c = "N" unless ($c);
    $comp_seq .= $c;
  }
  return $comp_seq;
}########## END comp_strand

