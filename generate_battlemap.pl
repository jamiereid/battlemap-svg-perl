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
use Switch;

#############
## vars
#############

my ($opt_output_file, $opt_page_size);
my $opt_random_skew			= 0;
my $opt_help				= 0;
use constant ZZ             => 0.01;

#############
## main
#############

## get options from the cli
GetOptions  (   'output-file=s'		=> \$opt_output_file,		# file to output to (aotherwise print to STDOUT)
                'page-size=s'		=> \$opt_page_size,		    # Size of page, should be a4|a3|a2|a1|a0
                'random-skew'		=> \$opt_random_skew,		# Put a spin on a traditional map
                'help|?'            => \$opt_help			    # need help?
            );

## check options and preceed accordingly
usage() if (!defined($opt_page_size) || $opt_help == 1);

my ($page_width, $page_height)      = &page_dimensions($opt_page_size);

&generate_page;

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

sub random_float
{
    ## var
    my $return;
    
    ## do
    #$return         = sprintf("%.2f",rand());
    $return         = rand();
    return($return)
}

sub page_dimensions
{
    ## vars
    my $page_size             = lc($_[0]);
    
    ##do
    switch ($page_size)
    {
        # return (height, width)
        case 'a0'       { return(int(46.81),int(33.11)) }
        case 'a1'       { return(int(33.11),int(23.39)) }
        case 'a2'       { return(int(23.39),int(16.54)) }
        case 'a3'       { return(int(16.54),int(11.69)) }
        case 'a4'       { return(int(11.69),int(8.27)) }
        else            { print("!! No page size specified, defaulting to A4\n"); return(&dimensions("a4")) }
    }
}

sub generate_page
{
    ## vars
    
    ## do
    print("<?xml version='1.0' encoding='UTF-8' ?><!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN' 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>\n");
            
    print("<svg\n");
    print("    xmlns:svg='http://www.w3.org/2000/svg'\n");
    print("    xmlns='http://www.w3.org/2000/svg'\n");
    print("    xmlns:xlink='http://www.w3.org/1999/xlink'\n");
    print("    version='1.1'\n");
    print("    width='" . $page_width . "in'\n");
    print("    height='" . $page_height . "in'\n");
    print("  viewBox='0 0 " . $page_width . " " . $page_height . "'\n");
    print("  >	\n");
    
    print("<g stroke='#808080' stroke-width='.007'>\n");
    for (my $x = 0; $x < $page_width; $x++)
    {
        #print("!! $x && $page_width !!\n");
        for (my $y = 0; $y < $page_height; $y++)
        {
            ## do
            print("<svg x='" . $x . "' y='" . $y . "'>");
            
            my $xx2     = 1 + $x % 2 * 2;
            my $xx1     = 3 - $x % 2 * 2;
            my $yy2     = 1 + $y % 2 * 2;
            my $yy1     = 3 - $y % 2 * 2;
           
            my $x1      = &z0($xx1);
            my $y1      = &z1(1);
            
            print("<path" 
                        . " fill='none'" 
                        . " d='M " . $x1 . " " . $y1
                        . " C " 
                        . &z0($xx1) . " " . &z2($yy2) . " " 
                        . &z0($xx1) . " " . &z2($yy2) . " " 
                        . &z1(1) . " " . &z2($yy2)
                        . " S " 
                        . &z2($xx2) . " " . &z2($yy2) . " " 
                        . &z2($xx2) . " " . &z1(1)
                        . " S " 
                        . &z2($xx2) . " " . &z0($yy1) . " " 
                        . &z1(1) . " " . &z0($yy1) 
                        . " S " 
                        . &z0($xx1) . " " . &z0($yy1) . " " 
                        . $x1 . " " . $y1
                        . " z'/>");
                print("</svg>\n");

            }
            #print ($x ."\n");
        }
        print("</g>\n");
        print("<g stroke='black' stroke-width='.014'>\n");
        
        for (my $dex = 1; $dex <= $page_width; $dex += 2)
        {
		#print ("$dex\n");
            for (my $yex = 1; $yex <= $page_height; $yex += 2)
            {
                print("<line x1='" . ($dex - 0.05) . "' y1='" . $yex . "' x2='" . ($dex + 0.05) . "' y2='" . $yex . "' />\n");
                print("<line x1='" . $dex . "' y1='" . ($yex - 0.05) . "' x2='" . $dex . "' y2='" . ($yex + 0.05) . "' />\n");
            }
        }
            
        print("</g>\n");
        print("</svg>\n");
}

sub z0
{
    ## vars
    my $return;
    my $blee;
    
    ## do
    if ( &random_int(10) eq 0 )
    {
        $blee   = &ZZ;
    }
    else
    {
        $blee   = &ZZ * 3;
    }
    $return     = &ZZ + &random_float * $blee;
    return($return);
}

sub z1
{
    #  return .5 - ZZ + rnd.nextDouble() *  (rnd.nextInt(10)==0?ZZ:ZZ*3) * 2;
    ## vars
    my $return;
    my $blee;
    
    ## do
    if ( &random_int(10) eq 0 )
    {
        $blee   = &ZZ;
    }
    else
    {
        $blee   = &ZZ * 3;
    }
    $return     = 0.5 - &ZZ + &random_float * $blee * 2;
    return($return);
}

sub z2
{
    # return 1 - ZZ - rnd.nextDouble() *  (rnd.nextInt(10)==0?ZZ:ZZ*3);
    ## vars
    my $return;
    my $blee;
    
    ## do
    if ( &random_int(10) eq 0 )
    {
        $blee   = &ZZ;
    }
    else
    {
        $blee   = &ZZ * 3;
    }
    $return     = 1 - &ZZ + &random_float * $blee;
    return($return);
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
