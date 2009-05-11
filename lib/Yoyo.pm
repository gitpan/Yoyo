package Yoyo;

use strict;
use warnings;
use base qw( Class::Accessor::Fast );

use POSIX qw( strftime );
use Yoyo::Command;

our $VERSION = '0.00001_01';

sub execute_command {
    my $self   = shift;
    my $params = shift;

    my $cmd = Yoyo::Command->new();
    my $result = $cmd->do_command( $params );
}

sub _validate {
    my $self = shift;
    my $data = shift;

    ## nothing case
    if ( !$data->{type} ) {
        return 'The command is a uninput.';
    }
}

sub _look_datetime {
    my $self = shift;
    return strftime( "%Y-%m-%d %H:%M:%S", localtime() );
}


1;
__END__

=head1 NAME

Yoyo - It is a tool that confirms the command result to various hosts connected with ssh. 

=head1 SYNOPSIS

  package MyPackage;
  use Yoyo;

  my $yoyo = Yoyo->new();
  my $args = {
    command => 'disk_size',
    target => {
        hosts => ['host1', 'host2' ],
        perlmod => [ 'strict', 'warnings' ]
    }
  };
  my $result = execute_command( $args );

=head1 DESCRIPTION

Yoyo is a tool that confirms the command result to various hosts connected with ssh.

* The kind of the command that you can confirm is as follows. 
  disk_size
  memory_size
  load_avg
  grep
  perlmod

=head1 METHODS

=head2 execute_command

=head1 AUTHOR

kazuhiko yamakura E<lt>yamakura@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
