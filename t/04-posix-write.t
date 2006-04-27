#	$Id: 02-write.t,v 1.2 2005/10/15 20:10:54 adam Exp $

use strict;
use Test;
use Fcntl qw(:DEFAULT);
BEGIN { plan tests => 24 }

use Log::Trivial;

my $logfile = "./t/test.log";
my $o_sync  = "./t/o_sync";
ok(1);

#	2-6
my $logger = Log::Trivial->new;
ok($logger->set_write_mode('s'));
ok($logger->{_o_sync},1);

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

eval {
    sysopen my $log, $o_sync, O_WRONLY | O_CREAT | O_SYNC | O_APPEND;
};
if ($@ =~ /Your vendor has not defined Fcntl macro O_SYNC/) {
print STDERR <<"WARNING";

#################################################
# This module uses the POSIX open O_SYNC flag.  #
# This flag is not supported on this system.    #
# You may still use this module, but not in     #
# O_SYNC mode, please see the docs for details. #
#################################################

WARNING

skip("Non POSIX Platform");
skip("Non POSIX Platform");
skip("Non POSIX Platform");
skip("Non POSIX Platform");
skip("Non POSIX Platform");
skip("Non POSIX Platform");
skip("Non POSIX Platform");
skip("Non POSIX Platform");
skip("Non POSIX Platform");

} else {
    ok(unlink $o_sync);
    ok($logger->write(comment => "Test-m", level => 1)); 	# Write Test to the log, should be written

    ok($logger->write("Test-2-m"));							# Write without a level
    ok(-e $logfile);										# Now there should be a file

    #	17-18
    ok($logger->set_log_mode("s"));							# Set to single/fast mode
    ok($logger->{_mode}, 0);

    #	19-20
    ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
    ok($logger->write(comment => "Test-s", level => 1));	# Write Test to the log, should be written

    #	21-22
    ok(unlink $logfile);
};
ok(! -e $logfile);
ok(! -e $o_sync);
