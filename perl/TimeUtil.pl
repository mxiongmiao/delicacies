use strict;
use warnings;

sub getTimeStr{
	my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
	my $nowDate=join("-", ($year+1900, $mon+1, $day));
	my $nowTime=join(":", ($hour, $min, $sec));
	my $timeStr=$nowDate . " " . $nowTime;
	return $timeStr;
}

sub yyyyMMdd{
	my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
	my $nowDate=join("-", ($year+1900, $mon+1, $day));
	return $nowDate;
}

sub getTimeMillions{
	return time;
}

print(getTimeMillions() . "\n");

print(getTimeStr() . "\n");