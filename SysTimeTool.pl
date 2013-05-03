#! /usr/bin/perl

use Time::Local;

my $command = "";
#my @logFiles = ("/var/log/boot.log", "/var/log/cron", "/var/log/maillog", "/var/log/message");
my @logFiles = ("/var/log/auth.log", "/var/log/messages");
my @logEntry; #hold all of the entries in the logfile
my @logTimes; #hold the times from a given logfile
my @timeGap; #hold the position of any time gap errors
my @timeReverse; #hold the position of any reverse time errors
my $userGap = 10; #hold the user defined time gap

#concatinate @ARGV into the full command
foreach(@ARGV) {
  $command = $command." $_";
}

#check if formatting is correct
die "loggin: Invalid format: loggin -t hh:mm:ss"
	if ( $command !~ m/^\s+\-t\s+\d\d\:\d\d\:\d\d$/ && $command !~ m/^\s+\-a$/ );

#convert month to number
sub convMon {
	if ( $_[0] =~ "Jan" ) { return 1; }
	elsif ( $_[0] =~ "Feb" ) { return 2; }
	elsif ( $_[0] =~ "Mar" ) { return 3; }
	elsif ( $_[0] =~ "Apr" ) { return 4; }
	elsif ( $_[0] =~ "May" ) { return 5; }
	elsif ( $_[0] =~ "Jun" ) { return 6; }
	elsif ( $_[0] =~ "Jul" ) { return 7; }
	elsif ( $_[0] =~ "Aug" ) { return 8; }
	elsif ( $_[0] =~ "Sep" ) { return 9; }
	elsif ( $_[0] =~ "Oct" ) { return 10; }
	elsif ( $_[0] =~ "Nov" ) { return 11; }
	elsif ( $_[0] =~ "Dec" ) { return 12; }
}

sub calcTime() {
	my @time = split(/\:/, $ARGV[1]);
	my ($hr, $min, $sec) = @time;
	my $epoch = 0;
	$epoch = $epoch + ($hr*60*60);
	$epoch = $epoch + ($min*60);
	$epoch = $epoch + $sec;
	$userGap = $epoch
}


#populate logEntries and logTimes
sub readLog
{
	#clear arrays
	@logEntries = ();
	@logTimes = ();
	@timeGap = ();
	@timeReverse = ();
	
	open(LOGFILE, $_[0]);
	while(<LOGFILE>) 
	{
		chomp $_;
		push (@logEntries, $_);
		
		#parse out times
		my @column = split(/\s+/, $_);
		my ($sec, $min, $hour, $day, $month, $year) = localtime(time);
		my @time = split(/\:/, $column[2]);
		my $t = timelocal($time[2], $time[1], $time[0], $column[1], convMon($column[0]), $year);
		push (@logTimes, $t);
	}
}

#check times for errors
sub checkTimes()
{
	my $total = @logTimes;
	for (my $i = 0; $i < ($total - 1); $i++)
	{
		#check for time gaps
		if ((@logTimes[$i + 1] - @logTimes[$i]) > $userGap)
		{
			push (@timeGap, $i);
		}
		
		#check for reverse times
		if (@logTimes[$i] > @logTimes[$i + 1])
		{
			push (@timeReverse, $i);
		}
	}
}

#display any errors
sub displayResults
{
	my $gapTotal = @timeGap;
	my $reverseTotal = @timeReverse;
	
	print "$_[0]\n";
	print "-----------------\n";
	print "Reverse Time Errors - $reverseTotal errors\n";
	
	if (@timeReverse == ())
	{
		print "-no errors found";
	}
	else
	{
		foreach $error (@timeReverse)
		{
			print "---\n";
			print "@logEntries[$error]\n";
			print "@logEntries[$error + 1]\n";
		}
	}
	print "\n";
	print "-----------------\n";
	print "Time Gap Errors - $gapTotal errors\n";
	
	if (@timeGap == ())
	{
		print "-no errors found";
	}
	else
	{
		foreach $error (@timeGap)
		{
			print "---\n";
			print "@logEntries[$error]\n";
			print "@logEntries[$error + 1]\n";
		}
	}
	
	print "\n\n";
	
	@logEntries = ();
	@logTimes = ();
	@timeGap = ();
	@timeRerverse = ();
}

# main prog
if ($command =~ m/-t/) {
	calcTime();

	foreach $log (@logFiles)
	{
		readLog($log);
		checkTimes();
		displayResults($log);
	}
}
elsif ($command =~ m/-a/) {
	system("cat /var/log/auth.log | grep failure");
}
