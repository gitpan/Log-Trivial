#	$Id: 01-basic.t,v 1.6 2006-04-27 10:31:13 adam Exp $

use strict;
use Test;
BEGIN { plan tests => 4 }

use Log::Trivial;

ok(1);
ok($Log::Trivial::VERSION, '0.20');

my $logger = Log::Trivial->new;
ok(defined $logger);
ok($logger->isa('Log::Trivial'));

exit;
