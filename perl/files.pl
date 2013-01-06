use strict;
use warnings;

use Path::Class;

getFiles();

#获取一目录下所有文件
sub getFiles{
	my $dir=dir('E:\perl\scripts');

	while(my $file=$dir->next){
		#如果是目录, 跳过
		next if $file->is_dir();
		
		#打印文件路径和名称, 感觉就向 toString()
		print $file->stringify() . " 名称：" . "$_" . "\n";
	}		
}