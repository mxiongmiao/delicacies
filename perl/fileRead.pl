use strict;
use warnings;

use Path::Class;
use autodie; #die if problem reading or writing a file

sub getTheLastLine{
	my $dir=dir('E:\5alog_data\x05\log');
	my $file=$dir->file('Online_20120915.log');

	# read in the entire contents of a file
	# my $content=$file->slurp();
	
	#openr() returns an IO:File object to read from
	my $file_handle=$file->openr();
	my $last;
	while(my $line=$file_handle->getline()){
		$last=$line;
	}
	
	return $last;
}

sub getNowOnlinePlayerNum{
	my $line=getTheLastLine();
	my @arrr=split(/,/, $line);
	my $num=$arrr[1];
	return $num;
}

my $lastLine=getTheLastLine();
print("last record : " . $lastLine . "\n");

my $num=getNowOnlinePlayerNum();
print("now online player num : " . $num . "\n");