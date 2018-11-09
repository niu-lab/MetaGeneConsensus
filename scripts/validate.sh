#####################################################
#
#  Purpose: Identify whether a gene is true or false. 
#  Usage:
#     1. Please replace the "your.output.faa.clstr" with the actual clustering output of cd-hit in "Step1";
#     2. Please replace the "cd-hit.input.faa" with the actual clustering input of cd-hit in "Step3";
#
######################################################

# step1: Classification for the output of cd-hit
cat your.output.faa.clstr | perl -ne 'BEGIN{%hh; $pre_key; } chomp; if(/^>Cluster/){$pre_key=$_; $hh{$_}="";}else{ $hh{$pre_key}=$hh{$pre_key}.$_."|";}  END{ foreach $k(sort keys %hh){ $hh{$k}=~s/\|$//;;  @aa=split(/\|/, $hh{$k}); $count=$#aa+1; $flag_ref=0; $flag_orf=0;  map{ unless(/NODE/){$flag_ref=1;} }@aa;  map{ if(/NODE/){$flag_orf=1;} }@aa;   if($count>1 && $flag_ref && $flag_orf ){map{ print "true\t".$_."\n";  }@aa;  }elsif($count>1){ map{ print "false\t".$_."\n";  }@aa; }else{print "false\t".$hh{$k}."\n"; }   }   } ' > output.faa.clstr.class

# Step2: Change formatting
cat output.faa.clstr.class | perl -ne 'chomp; $_=~/(^\w+)\s\d.*/; $tmp=$1;    $_=~/,\s+(.*)\.\.\..*/; print $tmp."\t".$1."\n";' > output.faa.clstr.class_v2

# Step3: Got all the protein sequences' title including predicted and real proteins 
grep '>' cd-hit.input.faa > result.tmp

# Step4: Got discriminant results
cat result.tmp | perl -ne 'BEGIN{ %hh; map{ chomp; @aa=split/\t/; $hh{$aa[1]}=$aa[0]; }`cat output.faa.clstr.class_v2`; } chomp; @aa=split; if($hh{$aa[0]}){ print $hh{$aa[0]}."\t".$aa[0]."\n";}else{ print "NA"."\t".$aa[0]."\n"; }'  > result

# Step5: Compute the sensitivity and specificity for predicted ORFs
cat result | perl -ne 'BEGIN{$cc=0; $cn=0; $cf=0; } chomp; if(/NODE/){ @aa=split/\t/; if($aa[0] eq "true"){ $cc++;}elsif($aa[0] eq "NA"){$cn++;}else{$cf++;} } END{ print "The statistical output is as follows: \n"; print "1. predicted ORFs\nTrue=".$cc.", NA=".$cn.", False=".$cf."\n"; $tmp=$cc+$cn+$cf; print "The total number of ORFs is: ".$tmp."\n";}'

# Step6: Compute the sensitivity and specificity for real proteins
cat result | perl -ne 'BEGIN{$cc=0; $cn=0; $cf=0; } chomp; unless(/NODE/){ @aa=split/\t/; if($aa[0] eq "true"){ $cc++;}elsif($aa[0] eq "NA"){$cn++;}else{$cf++;} } END{ print "\n2.real proteins\nTrue=".$cc.", NA=".$cn.", False=".$cf."\n"; $tmp=$cc+$cn+$cf; print "The total number of real proteins: ".$tmp."\n";}'

# Step7: Delete all intermediate files
rm output.faa.clstr.class output.faa.clstr.class_v2 result.tmp result

# Note for step5-6: if the distinguishing mark between the predicted ORFs and the real proteins is not "NODE", you need to rewrite the script to compute the sensitivity or specificity.
