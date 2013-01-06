use strict;
use warnings;

# FIXME Can't locate Spreadsheet/Read.pm in @INC (@INC contains:
use Spreadsheet::Read;

my $workbook=ReadData ('E:\perl\scripts\a\test.xls');

print $workbook->[1]{A1} . "\n";
print $workbook->[1]{B1} . "\n";