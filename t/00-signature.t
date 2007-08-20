#   $Id: 00-signature.t,v 1.1 2007-08-07 17:42:58 adam Exp $

use Test::More;

BEGIN {
    eval ' use Test::Signature; ';

    if ($@) {
        plan( skip_all => 'Test::Signature not installed.' );
    }
    else {
        plan( tests => 1 );
    }
}
signature_ok();
