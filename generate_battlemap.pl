#!/usr/bin/perl -w

######################################################################
#   generate_battlemap.pl - Generate an svg file of a 1"
#                           battlemap suitable for use in
#                           tabletop games like D&D.
#
######################################################################

#############
## includes
#############

use strict;
use warnings;
use Getopt::Long;

#############
## vars
#############

my ($opt_output_file, $opt_page_size);
my $opt_random_skew			= 0;
my $opt_help				= 0;

#############
## main
#############

## get options from the cli
GetOptions  (   'output-file=s'		=> \$opt_output_file,		# file to output to (aotherwise print to STDOUT)
                'page-size=s'		=> \$opt_page_size,		# Size of page, should be a4|a3|a2|a1|a0
                'random-skew'		=> \$opt_random_skew,		# Put a spin on a traditional map
                'help|?'		=> \$opt_help			# need help?
            );

## check options and preceed accordingly
usage() if (!defined($opt_page_size) || $opt_help == 1);


print &random_int . "\t" . &random_int(11) . "\n";

#############
## subs
#############


sub random_int
{
    ## var
    my $range               = $_[0];
    
    ## do
    if (!defined($range))
    {
        $range              = '10000';
    }

    return(int(rand($range)));
}

sub usage
{
    print STDERR <<EOM;
    
Usage: generate_battlemap.pl [OPTION]...
Generate an svg of a 1" battlemap suitable for use in atabletop games like D&D.

Mandatory arugments to long options are mandatory to short options too.
    -o, --output-file           File name to outout to (if not specified, print to STDOUT).
    -p, --page-size             Size of map to generate (A4, A3, A2, A1, A0).
    -r, --random-skew           Put a small spin on the traditional map.
    -h, -?, --help              Show this information.
    
EOM
    exit(0);
}
