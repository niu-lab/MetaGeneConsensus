MetaGeneConsensus
===========
Gene prediction is an important approach in analyzing metagenomic sequence data. There has been many gene prediction tools developed for metagenomic sequences. MetaGeneConsensus provides a software integration platform and as a foundation for software development of consensus based on multiple gene prediction tools.

Usage
-----

        Version 1.0
        Usage: ./mgc [options]

Options:

       -FragGeneScan        show the help of FragGeneScan
       -Prodigal            show the help of Prodigal
       -MetaGeneAnnotator   show the help of MetaGeneAnnotator
       -Orphelia            show the help of Orphelia
       -Glimmer3            show the help of Glimmer3
       -GeneMarkS-2         show the help of GeneMarkS-2

Install
-------

Environment configuration:

     x86_64-linux (Run "uname -a" to check.)
     gcc (GCC) 4.8+ (Run "gcc --version" to check.)
     perl 5.24+ (Run "perl --version" to check.)

Clone the gclust repos, and build the `gclust` binary:

     git clone https://github.com/niu-lab/MetaGeneConsensus
     cd MetaGeneConsensus

Make sure you have installed the following tools.

     1. FragGeneScan: https://github.com/COL-IU/FragGeneScan
     2. Prodigal: https://github.com/COL-IU/FragGeneScan
     3. MetaGeneAnnotator: http://metagene.cb.k.u-tokyo.ac.jp/metagene/download_mga.html
     4. Orphelia: http://orphelia.gobics.de/
     5. Glimmer3: http://ccb.jhu.edu/software/glimmer/index.shtml
     6. GeneMarkS-2: http://exon.gatech.edu/GeneMark/
     7. CD-HIT: https://github.com/weizhongli/cdhit/releases

To install this module, run the following commands:

        perl Makefile.PL
        make
        make test
        make install 

Support
--------
For user support please email lirl@sccas.cn

Citation
--------
LI Ruilin, SHANG Qiuming, HAN Xinyin, ZHANG Yu, ZHU Haidong, LI Weizhong, NIU Beifang*.Benchmarking of Gene Prediction Software for Metagenomic Long Fragments. Journal of Computer Applications (In Chinese),2018 (Retirement)

References
--------
    [1] Rho M, Tang H, Ye Y. FragGeneScan: predicting genes in short and error-prone reads. Springer US, 2015.
    [2] Hyatt D, Chen G, LoCascio PF, et al. Prodigal: prokaryotic gene recognition and translation initiation site identification. BMC Bioinformatics 2010;11:119.
    [3] Noguchi H, Taniguchi T,Itoh T. MetaGeneAnnotator: Detecting Species-Specific Patterns of Ribosomal Binding Site for Precise Gene Prediction in Anonymous Prokaryotic and Phage Genomes. DNA Research,15,6(2008-10-21) 2008;15:387-96.
    [4] Hoff KJ, Lingner T, Meinicke P, et al. Orphelia: predicting genes in metagenomic sequencing reads. Nucleic Acids Research 2009;37:101-5.
    [5] Delcher AL, Bratke KA, Powers EC, et al. Identifying bacterial genes and endosymbiont DNA with Glimmer. Bioinformatics 2007;23:673.
    [6] Lomsadze A, Gemayel K, Tang S, Borodovsky M. Modeling leaderless transcription and atypical genes results in more accurate gene prediction in prokaryotes. Genome Research 2018;28:1079.
    [7] FU L, NIU B, ZHU Z, , et al. CD-HIT: accelerated for clustering the next-generation sequencing data. Bioinformatics 2012;28:3150-2.
