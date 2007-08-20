#    $Id: 01-basic.t,v 1.9 2007-08-18 20:28:15 adam Exp $

use strict;
use Test::More tests => 4;

BEGIN { use_ok( 'Log::Trivial' ); }

is( $Log::Trivial::VERSION, '0.30', 'Version Check' );

my $logger = Log::Trivial->new;
ok( defined $logger, 'Object is defined' );
isa_ok( $logger, 'Log::Trivial',  'Oject/Class Check' );

exit;
