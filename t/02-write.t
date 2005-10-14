#	$Id: 02-write.t,v 1.1.1.1 2005/10/14 15:31:05 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 19 }

use Log::Trivial;

my $logfile="./t/test.log";
ok(1);

#	2-4
my $logger = Log::Trivial->new;
ok($logger);
ok($logger->set_log_file($logfile));				# Set the test file to read
ok($logger->{_file}, $logfile);

#	5-6
ok($logger->set_log_mode("m"));						# Set to multi/slow mode
ok($logger->{_mode}, 1);

#	7-9
ok($logger->{_level}, 3);							# Check the default level 3
ok($logger->set_log_level(2));						# Set the logging level to 2
ok($logger->{_level}, 2);							# Check it's set

#	10-13
ok(! -e $logfile);										# There should be no file there now
ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
ok($logger->write(comment => "Test-m", level => 1));	# Write Test to the log, should be written
ok(-e $logfile);										# Now there should be a file

#	14-15
ok($logger->set_log_mode("s"));							# Set to single/fast mode
ok($logger->{_mode}, 0);

#	16-17
ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
ok($logger->write(comment => "Test-s", level => 1));	# Write Test to the log, should be written

#	18-19
ok(unlink $logfile); 
ok(! -e $logfile);
