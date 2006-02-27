#	$Id: 01-basic.t,v 1.5 2006-02-11 23:08:38 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 4 }

use Log::Trivial;

ok(1);
ok($Log::Trivial::VERSION, "0.10");

my $logger = Log::Trivial->new;
ok(defined $logger);
ok($logger->isa('Log::Trivial'));

exit;
