#	$Id: 90-pod.t,v 1.1.1.1 2005/10/14 15:31:05 adam Exp $

use strict;
use Test::More tests => 1;
use Test::Pod;

pod_file_ok("./lib/Log/Trivial.pm", "Valid POD file" );

