#!/usr/bin/perl -w
use strict;
use warnings;

use Path::Class;
use autodie; #die if problem reading or writing a file

sub getIncomeAndPayPlayerNum{
	my $logDir=getLogDir();
	my $payFileName="Pay_" . yyyyMMdd() . ".log";
	my $payFile=$logDir->file($payFileName);
	my $fileHandle=$payFile->openr();
	
	my $income=0;
	my %hash=();
	while(my $line=$fileHandle->getline()){
		chomp($line);
		
		my @arrr=split(/,/, $line);
		my $paySuccess=$arrr[4];
		next if($paySuccess==0);

		my $playerId=$arrr[1];
		$hash{$playerId}=1;
		my $money=$arrr[3];
		$income+=$money;
	}
	
	my $payPlayerNum=keys %hash;
	my @ret=($payPlayerNum, $income);	
	return @ret;
}

sub getOnlinePlayerNum{
	my $logDir=getLogDir();
	my $onlineFileName="Online_" . yyyyMMdd() . ".log";
	my $onlineFile=$logDir->file($onlineFileName);
	my $fileHandle=$onlineFile->openr();
	
	my $onlineNum=0;
	while(my $line=$fileHandle->getline()){
		chomp($line);		
		my @arrr=split(/,/, $line);
		$onlineNum=$arrr[1];
		next if($line=~/\S/);
	}
	
	return $onlineNum;
}

sub getRegNum{
	my $logDir=getLogDir();
	my $partnerFileName="Partner_" . yyyyMMdd() . ".log";
	my $partnerFile=$logDir->file($partnerFileName);
	my $fileHandle=$partnerFile->openr();
	
	my %hash=();
	while(my $line=$fileHandle->getline()){
		chomp($line);
		my @arrr=split(/,/, $line);
		my $playerId=$arrr[1];
		$hash{$playerId}=1;
		next if($line=~/\S/);
	}
	my $regNum=keys %hash;
	
	return $regNum;
}

sub getLogDir{
	#FIXME 跑测试需要有相应日志文件
	my $rootPath="E:\\5alog_data\\";
	my $sid=$ARGV[0];
	my $logPath=$rootPath. "$sid\\log";
	my $logDir=dir($logPath);
	return $logDir;
}

sub yyyyMMdd{
	my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
	my $nowDate=join("", ($year+1900, $mon+1, $day));
	return $nowDate;
}

sub main{
	my @ret1=getIncomeAndPayPlayerNum();
	my $onlineNum=getOnlinePlayerNum();
	my $regNum=getRegNum();
	my @ret=(@ret1, $onlineNum, $regNum);
	
	print("<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />");
	print("player num:". $ret[0] . "\n");
	print("income: " . $ret[1] . "\n");
	print("now online player num: " . $ret[2] . "\n");
	print("reg player num: " . $ret[3] . "\n");
}

main();