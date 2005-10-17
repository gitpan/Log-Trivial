#	$Id: 92-pod.t,v 1.1 2005/10/14 21:02:49 adam Exp $

use strict;
use Test::Pod::Coverage tests=>1;
pod_coverage_ok( "Log::Trivial", "Log::Trivial is covered" );
