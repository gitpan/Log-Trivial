#	$Id: 01-basic.t,v 1.2 2005/10/14 21:12:32 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 4 }

use Log::Trivial;

ok(1);
ok($Log::Trivial::VERSION, "0.02");

my $logger = Log::Trivial->new;
ok(defined $logger);
ok($logger->isa('Log::Trivial'));

exit;
