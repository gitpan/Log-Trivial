#    $Id: Build.PL,v 1.8 2007-08-07 17:42:52 adam Exp $;

use Module::Build;

if ($^O !~ /linux/i) {
    print <<"WARNING";

################################################
# This module uses the POSIX open O_SYNC flag. #
# This flag is not supported on all systems.   #
################################################

WARNING
}

my $build = Module::Build->new(
    module_name => 'Log::Trivial',
    license     => 'gpl',
    requires    => {
        'perl'  => '5.6.1',
    },
    build-requires => {
        'Test'                => '0',
        'Test::Pod::Coverage' => '0',
        'Test::Pod'           => '0',
        'Test::More'          => '0',
        'Pod::Coverage'       => '0',
    },
);

$build->create_build_script;
