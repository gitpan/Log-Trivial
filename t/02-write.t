#	$Id: 02-write.t,v 1.3 2006-02-27 20:49:46 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 27 }

use Log::Trivial;

my $logfile="./t/test.log";
ok(1);

#	2-6
my $logger = Log::Trivial->new;
ok($logger->set_write_mode('a'));
ok($logger->{_o_sync}, 0);

ok($logger);
ok($logger->set_log_file($logfile));				# Set the test file to read
ok($logger->{_file}, $logfile);

#	7-8
ok($logger->set_log_mode("m"));						# Set to multi/slow mode
ok($logger->{_mode}, 1);

#	9-11
ok($logger->{_level}, 3);							# Check the default level 3
ok($logger->set_log_level(2));						# Set the logging level to 2
ok($logger->{_level}, 2);							# Check it's set

#	12-17
ok(! -e $logfile);										# There should be no file there now
ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
ok($logger->write(comment => "Test", level => undef));  # Uses default level so should write
$logger->{_level} = undef;                              # set to undef
ok($logger->write(comment => "Test", level => undef));  # Uses default level so should write which is also undef
$logger->{_level} = 2;                                  # Put level back
ok($logger->write(comment => "Test-m", level => 1));	# Write Test to the log, should be written
ok($logger->write(level => 1));                         # Should write a dot
ok($logger->write("Test-2-m"));							# Write without a level
ok(-e $logfile);										# Now there should be a file

#	18-19
ok($logger->set_log_mode("s"));							# Set to single/fast mode
ok($logger->{_mode}, 0);

#	20-21
ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
ok($logger->write(comment => "Test-s", level => 1));	# Write Test to the log, should be written

#   22-23
$logger = Log::Trivial->new(log_file => $logfile);
ok($logger->{_file}, $logfile);

$logger = Log::Trivial->new(log_level => 5);
ok($logger->{_level}, 5);

#	24-25
ok(unlink $logfile); 
ok(! -e $logfile);
