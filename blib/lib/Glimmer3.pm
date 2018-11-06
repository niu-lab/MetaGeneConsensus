package Glimmer3;

use 5.006;
use strict;
use warnings;

use Carp;
use Getopt::Long;
use IO::File;
use FileHandle;
our $VERSION = '1.0';

sub new {
	my $class = shift;
	my $this = {};
	bless $this, $class;
	$this->process();
	return $this;
}


sub process {
	my $this = shift;
	my ( $help, $options );
	unless ( @ARGV ) { die $this->help_text(); }
	$options = GetOptions(
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: 

    packages/glimmer3.02/bin/[options]  -- To run Prodigal in the current directory.
    
    Options:
        long-orfs
        extrac
        build_icm
        glimmer3

HELP

}
1;
