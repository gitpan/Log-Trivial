#	$Id: 02-write.t,v 1.4 2006-04-27 10:31:14 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 40 }

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

#	21-23
ok(! $logger->write(comment => "Test", level => 3));	# Write Test to the log, shouldn't be written
ok($logger->write(comment => "Test-s", level => 1));	# Write Test to the log, should be written
ok($logger->write(comment => "Test-s2", level => 1));	# Write Test to the log, should be written

#   24-25
$logger = Log::Trivial->new(log_file => $logfile);
ok($logger->{_file}, $logfile);

$logger = Log::Trivial->new(log_level => 5);
ok($logger->{_level}, 5);

#   25-36
$logger = Log::Trivial->new(
    log_tag  => 'test_tag',
    log_file => $logfile);
ok ($logger);
ok ($logger->write('tagged entry'));

if (-e $logfile) {
    open my $test_log, "<", $logfile || die "Unable to read test log file: $logfile";
    ok ($test_log);

    my $line = <$test_log>;
# print STDERR $line;
    ok($line =~ /Test/);

    $line = <$test_log>;
# print STDERR $line;
    ok($line =~ /Test/);

    $line = <$test_log>;
# print STDERR $line;
    ok($line =~ /Test-m/);

    $line = <$test_log>;
# print STDERR $line;
    ok($line =~ /./);

    $line = <$test_log>;
# print STDERR $line;
    ok($line =~ /Test-2-m/);

    $line = <$test_log>;
# print STDERR $line;
    ok($line =~ /Test-s/);
# print STDERR $line;
    $line = <$test_log>;

    ok($line =~ /Test-s2/);

    $line = <$test_log>;
# print STDERR $line;
    ok($line =~ /test_tag/);
    ok($line =~ /tagged entry/);

    close $test_log;
}
else {
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
    skip("Log file does not exist, skipping this test...");
}


#	37-38
ok(unlink $logfile); 
ok(! -e $logfile);
