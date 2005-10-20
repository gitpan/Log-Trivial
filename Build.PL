#	$Id: Build.PL,v 1.2 2005/10/19 20:40:54 adam Exp $;

use Module::Build;

my @tests = qw(t/00-use.t t/01-basic.t t/02-write.t t/03-error.t);

eval { require Test::Pod; };
push @tests, 't/90-pod.t' unless ($@);

eval { require Pod::Coverage; };
push @tests, 't/91-pod.t' unless ($@);

eval { require Test::Pod::Coverage; };
push @tests, 't/92-pod.t' unless ($@);

my $build = Module::Build->new(
	module_name => 'Log::Trivial',
	license     => 'gpl',
	test_files  => \@tests,
	requires    => {
		'perl'  => '5.6.1',
	},
	build-requires => {
		'test'  => '0',
	},
);

$build->create_build_script;
