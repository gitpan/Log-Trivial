#	$Id: Trivial.pm,v 1.7 2005/10/20 19:44:03 adam Exp $

=head1 NAME

Log::Trivial - Very simple tool for writing very simple log files

=head1 SYNOPSIS

  use Log::Trivial;
  my $logger = Log::Trivial->new(log_file => "path/to/my/file.log");
  $logger->set_level(3);
  $logger->log(comment => "foo");

=head1 DESCRIPTION

Use this module when you want use "Yet Another" very simple, light
weight log file writer.

=cut

package Log::Trivial;

use 5.006;
use strict;
use warnings;
use Fcntl qw(:DEFAULT :flock :seek);
use Carp;

our $VERSION = "0.03";

#
#	NEW
#

=head1 METHODS

=head2 new

The constructor can be called empty or with a number of optional
parameters.

  $logger = Log::Trivial->new();

or

  $logger = Log::Trivial->new(
    log_file => "/my/config/file",
    log_level=> "2");

=cut

sub new {
	my $class = shift;
	my %args  = @_;
	my $object = bless {
		_file	=>	$args{log_file}  || "",					# The Log File
		_mode	=>  1,										# Set the file logging mode 1=multi thread, 0=single
		_handle =>  undef,									# File Handle if in single mode
		_level  =>  $args{log_level} || "3",				# Logging level
		_error_message => "",								# Store error messages here
		_debug  =>  undef,									# debug flag
	}, ref($class) || $class;

	return $object;
}


=head2 set_log_file

The log file can be set after the constructor has been called.
Simply set the path to the file you want to use as the log file.

  $logger->set_log_file("/path/to/log.file");

=cut

sub set_log_file {
	my $self = shift;
	my $log_file = shift;
	if ($self->_check_file($log_file)) {
		$self->{_file} = $log_file;
		$self->{_self} = 0;
		return $self;
	} else {
		return undef;
	}
}


=head2 set_log_mode

Log::Trivial runs in two modes. The default mode is Multi mode: in
this mode the file will be opened and closed for each log file write.
This may be slower but allows multiple applications to write to the log
file at the same time. The alternative mode is called single mode:
once you start to write to the log no other application honouring
flock will write to the log. Single mode is potentially faster, and
may be appropriate if you know that only one copy of your application
can should be writing to the log at any given point in time.

WARNING: Not all system honour flock.

  $logger->set_log_mode("multi");	# Sets multi mode (the default)

or

  $logger->set_log_mode("single");	# Sets single mode

=cut

sub set_log_mode {
	my $self = shift;
	my $mode = shift;

	if ($mode =~ /m/i) {
		$self->{_mode} = 1;
	} else {
		$self->{_mode} = 0;
	}

	return $self;
}


=head2 set_log_level

Log::Trivial uses very simple arbitrary logging level logic. Level 0
is the highest priority log level, the lowest is the largest number
possible in Perl on your platform. You set the global log level for
your application using this function, and only log events of this
level or higher priority will be logged. The default level is 3.

  $logger->set_log_level(4);

=cut

sub set_log_level {
	my $self = shift;
	my $level= shift;

	$self->{_level} = $level if defined $level;

	return $self;
}


=head2 write

Write a log file entry.

  $logger->write(
    comment => "My comment to be logged",
    level   => 3);

or

  $logger->write("My comment to be logged");

It will fail if the log file hasn't be defined, or isn't
writable. It will return the string written on success.

If you don't specify a log level, it will default to the current
log level and therefore log the event. Therefore if you always
wish to log something either specify a level of 0 or never
specify a log level.

Log file entries are time stamped and have a newline carriage
return added automatically.

=cut

sub write {
	my $self = shift;
	my $message;
	if (@_ > 1) {
		my %args = @_;
		my $level = $args{level} || $self->{_level};
		return undef if $self->{_level} < $level;
		$message = $args{comment} || "."
    } else {
		$message = shift;
		return $self->_raise_error("Nothing message sent to log") unless $message;
    }
    
	$message =  localtime() . "\t" . $message;
	my $file = $self->{_file};
	return $self->_raise_error("No Log file specified yet") unless $file;

	if (-e $file && ! -w $file) {
		return $self->_raise_error("Insufficient permissions to write to: $file");
	}

	if ($self->{_mode}) {
		my $log = $self->_open_log_file($file);

		$self->_write_log($log, $message);
		close $log;
	} else {
		my $log;
		if (! $self->{_handle}) {
			$log = $self->_open_log_file($file);
			$self->{_handle} = $log;
		}
		$self->_write_log($log, $message);
	}
 	return $message;
}

=head2 get_error

In normal operation the module should never die. All errors are
non-fatal. If an error occurs it will be stored internally within
the object and the method will return undef. The error can be read
with the get_error method. Only the most recent error is stored.

  $logger->write("Log this") || print $logger->get_error;

=cut

sub get_error {
	my $self = shift;
	return $self->{_error_message};
}



#
#	Private Stuff
#

sub _check_file {
	my $self = shift;
	my $file = shift;
	return $self->_raise_error("File error: No file name supplied") unless $file;
	return $self;
}

sub _open_log_file {
	my $self = shift;
	my $file = shift;
	sysopen my $log, $file, O_WRONLY | O_CREAT | O_SYNC | O_APPEND
		or return $self->_raise_error("Unable to open Log File: $file");
	flock $log, LOCK_EX;
	return $log;
}

sub _write_log {
	my $self   = shift;
	my $handle = shift;
	my $string = shift() . "\n";

	my $bytes  = length $string;
	sysseek $handle, 0, SEEK_END;
	syswrite $handle, $string, $bytes;
	return $self->_raise_error("Write Error") unless $bytes == length $string;
}

sub _raise_error {
	my $self    = shift;
	my $message = shift;
	carp $message if $self->{_debug};			# DEBUG:  warn with the message
	$self->{_error_message} = $message;			# NORMAL: set the message
	return undef;
}


1;

__END__

=head1 LOG FORMAT

The log file format is very simple and fixed:

Time & date [tab] Your log comment [carriage return new line]

=head2 Prerequisites

At the moment the module only uses core modules. The test suite optionally uses
C<Pod::Coverage>, C<Test::Pod::Coverage> and C<Test::Pod>, which will be skipped
if you don't have them.

=head2 History

See Changes file.

=head2 Defects and Limitations

Patches Welcome... ;-)

=head2 To Do

=over

=item *

Much better test suite.

=back

=head1 EXPORT

None.

=head1 AUTHOR

Adam Trickett, E<lt>atrickett@cpan.orgE<gt>

=head1 SEE ALSO

L<perl>, L<Log::Agent>, L<Log::Log4perl>, L<Log::Dispatch>, L<Log::Simple>

=head1 COPYRIGHT

C<Log::Trivial>, Copyright iredale consulting 2005

OSI Certified Open Source Software.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston,
MA  02111, USA.

=cut
