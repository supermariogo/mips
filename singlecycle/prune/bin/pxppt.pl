#!/usr/bin/perl -w
use strict;
use Getopt::Long;

#
#   help hint 
#
my $usage   =  <<USAGEEND;

Usage:
    pxppt.pl start_text_num total_num start_time end_time

USAGEEND

my $snum;    # start text number, started from 0
my $tnum;    # total number
my $stime;   # start time
my $etime;   # end time

#
# Pass the paramter from terminal to perl program
# If terminal input arguments are wrong, then print help information
#
if ( @ARGV != 4 )
{
    print $usage;
    exit 1;
}
else
{
    ($snum,$tnum,$stime,$etime)=@ARGV;
}

#
# Generate new file named like "./1"
# Then rename new file from the format "./1" to "./1.txt" 
#
my $file_num=$snum;
while($tnum--)
{ 
    my $file_name=$file_num.".txt";
    print("Processing $file_name\n");
    &pxppt($file_name,$file_num,$stime,$etime);
    rename($file_num,$file_name);
    $file_num=$file_num+1;
}

sub pxppt {
    my ($souce_file,$target_file,$start_time,$end_time)=@_;
    open(RD,$souce_file)||die("Open $souce_file error");
    open(WR,'>'.$target_file)||die("Open $target_file error");
    
    my $time;
    my $value;
    while(<RD>)
    {
        chomp;
        if(m/([\d+\-.eE]+)\s+([\d+\-.eE]+)/)
        {
            $time=$1;
            $value=$2;
            if(($time>=$start_time)&&($time<=$end_time))
            {
                print(WR "$_\n");
            }
        }
    }
    close(RD);
    close(WR);
}

