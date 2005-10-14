#	$Id: 91-pod.t,v 1.1.1.1 2005/10/14 15:31:05 adam Exp $

use strict;
use Test;
use Pod::Coverage;

plan tests => 1;

my $pc = Pod::Coverage->new(package => 'Log::Trivial');
ok($pc->coverage == 1);
