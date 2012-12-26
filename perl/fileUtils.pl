use strict;
use warnings;

use File::Find;
use autodie;

find(\&allFiles, 'E:\perl\scripts');
print("--------------------------------------\n");
find(\&allDirs, 'E:\perl\scripts');

sub allFiles{
	-f $_ && print("$File::Find::name" . "\n");	
}

sub allDirs{
	-d $_ && print("$File::Find::name" . "\n");
}