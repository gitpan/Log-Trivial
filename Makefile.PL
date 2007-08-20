# $Id: Makefile.PL,v 1.8 2007-08-20 15:43:36 adam Exp $

use ExtUtils::MakeMaker;
use strict;
use 5.006;

if ($^O !~ /linux/i) {
    print <<"WARNING";

################################################
# This module uses the POSIX open O_SYNC flag. #
# This flag is not supported on all systems.   #
################################################

WARNING
}

WriteMakefile(
    'NAME'          => 'Log::Trivial',
    'VERSION_FROM'  => 'lib/Log/Trivial.pm',
    'PREREQ_PM'     => {},
    'PL_FILES'      => {},
     dist           => {
       COMPRESS      => 'gzip -9f',
       SUFFIX        => 'gz'
       },
      ($] >= 5.005 ?
      (ABSTRACT_FROM => 'lib/Log/Trivial.pm',
       AUTHOR     => 'Dr A. J. Trickett <atrickett@cpan.org>') : ()),
);
