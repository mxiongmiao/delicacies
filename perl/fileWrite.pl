use strict;
use warnings;

use Path::Class;
use autodie; #die if problem reading or writing a file

sub witeFile{
	my $dir=dir('E:\perl\scripts\a');
	my $file=$dir->file('2.txt');
	
	# openw() 方法是覆盖写入， open('>>') 是追加写入
	#my $file_handle=$file->openw();
	my $file_handle=$file->open('>>');

	my @stuNames=('梁博','权震东','吉克隽逸');
	foreach my $next(@stuNames){
		$file_handle->print($next . "\n");
	}
	$file_handle->print("---------\n");
}

witeFile();

