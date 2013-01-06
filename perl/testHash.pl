use strict;
use warnings;

#key/value
my %hashs=(
	"maxm"=>"bei jing",
	"lfj"=>"cheng du"
);

#print($hashs{"maxm"} . "\n");
#print($hashs{"lfj"} . "\n");

# 打印 所有的 key
for(keys %hashs){
	print("$_" . "\n");
}

# 打印 所有的 value
for(keys %hashs){
	print("$hashs{$_}" . "\n");
}