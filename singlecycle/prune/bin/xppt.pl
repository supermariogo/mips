#!/usr/bin/perl -w
use strict;
use Getopt::Long;
#use Smart::Comments;

my $src_dir = ".";
my $tar_dir = ".";
my $start_num = 0; # starts from 0.out
my $trace_num = 1;
my $hier_num = 2;

GetOptions(
    'src=s'     =>  \$src_dir,
    'tar=s'     =>  \$tar_dir,
    'snum=i'    =>  \$start_num,
    'tnum=i'    =>  \$trace_num,
    'hnum=i'    =>  \$hier_num
);

#
# Main programme begin
#
my $start=time;
my $stop_num=$start_num+$trace_num;
my $num;

my $step=&get_step("$src_dir/$start_num.out");

for($num=$start_num;$num<$stop_num;$num++)
{
    &out2txt($src_dir."/$num.out",">".$tar_dir."/$num.txt",$hier_num,$step);
}

#
# Main programme end
#
my $seconds=time-$start;
print("\n$trace_num traces post-processing takes $seconds seconds!!!\n\n");


#
# Sub programme declaration
#
sub out2txt
{
    my ($rfile,$wfile,$part,$step)=@_;
    open(SRC,$rfile)||die("Open $rfile failed\n");
    open(TAR,$wfile)||die("Open $wfile failed\n");
    my $voltage;
    my $time=0;
    my $rep_sum;
    my $i;
    open(SRC,$rfile)||die("open $rfile failed\n");
    print("Processing $rfile\n");
    while (<SRC>)
    {
        chomp;
        if(/^(\d+)$/)
        {
            $rep_sum=($1-$time)/$step;
            for($i=0;$i<$rep_sum;$i++)
            {
                printf TAR "%-12d\t\t%s\n", $time, $voltage;
                $time+=$step;
            }
        }
        elsif(/^$part\s+(.*)$/)
        {
            $voltage=$1;
        }
        else
        {
            next;
        }
    }
    printf TAR "%-12d\t\t%s\n", $time, $voltage;
    close(SRC);
    close(TAR);
}

sub get_step
{
    my ($ref_file)=@_;
    my $pre_time;
    my $line_num=0;   
    my $step=10000000;

    open(SRC,"$ref_file")||die("Open $ref_file failed\n");
    while(<SRC>)
    {
        chomp;
        if(/^(\d+)$/)
        {
            $line_num++;
            if($line_num==1)
    	    {
    	        $pre_time=$1;
    	    }
    	    else
    	    {
    	        if(($1-$pre_time<$step)&&($1-$pre_time!=0))
    	        {
    	    	$step=$1-$pre_time;
    	        }
    	        $pre_time=$1;
    	    } 
        }
        #print("$step\n");
    }
    close(SRC);
    $step;
}

