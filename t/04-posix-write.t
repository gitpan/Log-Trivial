#	$Id: 02-write.t,v 1.2 2005/10/15 20:10:54 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 22 }

use Log::Trivial;

my $logfile="./t/test.log";
ok(1);

#	2-6
my $logger = Log::Trivial->new;
ok($logger->set_write_mode('s'));
ok($logger->{_o_sync},1);

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

#	10-14
ok(! -e $logfile);										# There should be no file there now
ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
ok($logger->write(comment => "Test-m", level => 1));	# Write Test to the log, should be written
ok($logger->write("Test-2-m"));							# Write without a level
ok(-e $logfile);										# Now there should be a file

#	15-16
ok($logger->set_log_mode("s"));							# Set to single/fast mode
ok($logger->{_mode}, 0);

#	17-18
ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
ok($logger->write(comment => "Test-s", level => 1));	# Write Test to the log, should be written

#	19-20
ok(unlink $logfile); 
ok(! -e $logfile);
