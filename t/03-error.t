#	$Id: 03-error.t,v 1.3 2006-02-27 20:49:46 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 9 };
use Log::Trivial;

my $logger = Log::Trivial->new();
ok($logger);

ok(! $logger->write("This shouldn't log"));
ok($logger->get_error(), "No Log file specified yet");

ok(! $logger->write());
ok($logger->get_error(), "Nothing message sent to log");

ok(! $logger->set_log_file());
ok($logger->get_error(), "File error: No file name supplied");

ok($logger->set_log_level());
ok($logger->{_level}, 3);

