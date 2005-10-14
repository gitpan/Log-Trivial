#	$Id: 01-basic.t,v 1.1.1.1 2005/10/14 15:31:05 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 4 }

use Log::Trivial;

ok(1);
ok($Log::Trivial::VERSION, "0.01");

my $logger = Log::Trivial->new;
ok(defined $logger);
ok($logger->isa('Log::Trivial'));

exit;