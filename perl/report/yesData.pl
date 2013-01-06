use strict;
use warnings;

use File::Find;
use autodie;

sub add{
	my $ret=shift @_;
	foreach(@_){
		$ret=$ret+$_;
	}
	return $ret;
}

sub add2{
	my @input=@_;
	my $ret=0;
	foreach(@input){
		$ret=$ret+$_;
	}
	return $ret;
}

sub get{
	my $input=$_[0];
	return $input;
}

print(add(5, 6, 7, 8) . "\n");
print(add2(5, 6, 7, 8) . "\n");
print(get("hello") . "\n");