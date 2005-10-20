#	$Id: 01-basic.t,v 1.4 2005/10/20 19:44:15 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 4 }

use Log::Trivial;

ok(1);
ok($Log::Trivial::VERSION, "0.03");

my $logger = Log::Trivial->new;
ok(defined $logger);
ok($logger->isa('Log::Trivial'));

exit;
