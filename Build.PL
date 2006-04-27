#	$Id: Build.PL,v 1.6 2006-04-27 10:30:44 adam Exp $;

use Module::Build;

my @tests = qw(t/00-use.t t/01-basic.t t/02-write.t t/03-error.t);

if ($^O !~ /mswin32/i) {
    push @tests, 't/04-posix-write.t';
}

eval { require Test::Pod; };
push @tests, 't/90-pod.t' unless ($@);

eval { require Pod::Coverage; };
push @tests, 't/91-pod.t' unless ($@);

eval { require Test::Pod::Coverage; };
push @tests, 't/92-pod.t' unless ($@);

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
	test_files  => \@tests,
	requires    => {
		'perl'  => '5.6.1',
	},
	build-requires => {
		'Test'                => '0',
		'Test::Pod::Coverage' => '0',
		'Test::Pod'	          => '0',
        'Pod::Coverage'       => '0',
	},
);

$build->create_build_script;
