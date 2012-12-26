use strict;
use warnings;

print(1, 2, 3, 4, 5, 6);
print("1\n", "2\n", "3\n", "4\n", "5\n", "6\n");

my @names=("maxm ", "lfj", "china");
foreach my $ele(@names){
	print($ele);
	print("\n");
}

my $index=0;
print(("a","b","c","d")[$index]);
print("\n");

#array
my @arr;
@arr=qw("nihao", "wohao");
print(@arr[0] . "\n");
print(@arr);
print("\n");

my $one;
my $two;
($one, $two)=(0, 1);
print(@arr[$one, $two]);
print("\n");

print(1 .. 7);
print("\n");
print (reverse(1 .. 7));
print("\n");