package Yoyo::Command;

use strict;
use warnings;

use base qw( Yoyo );

use File::Spec;
use Parallel::ForkManager;
use IPC::Shareable;

use Data::Dumper;

sub do_command {
    my $self = shift;
    my $params = shift;

    my $command_line = $self->_make_command_line( $params );

    my $result = $self->_enforce_command( $command_line, $params ); 
    
    return( $result );
}

sub _enforce_command {
    my $self = shift;
    my $command_line = shift;
    my $params = shift;

    my $hosts = $params->{target}->{hosts};
    my $command = $params->{command};
    my $perlmods = $params->{target}->{perlmod};

    my $handle = tie my $all_result, 'IPC::Shareable', undef, { destroy => 1 };
    my $pm = Parallel::ForkManager->new(10);

    $all_result = {};
    foreach my $host_name ( @$hosts ) {
        my $pid;
        $pid = $pm->start && next;
        $handle->shlock;

        my $host_result = [];

        my $mycommand_line = $command_line;
        $mycommand_line =~ s/{host}/$host_name/g;

        if( $command eq 'perlmod' ){

            my $version_result = {};
            foreach my $module_name (@$perlmods) {

                $mycommand_line =~ s/{module}/$module_name/g;

                ## STDERR is not display.
                open( STDERR, '> ' . File::Spec->devnull() );
                open( CMD, "$mycommand_line  |" );
                my $version = <CMD>;
                close(CMD);
                chomp($version);
                $version = 'not_install' if ( !$version );

                ## set module_version
                $version_result->{$module_name} = $version;
            }
            $host_result = $version_result;
        } else {
            open( CMD, "$mycommand_line  |" );
            my @result = <CMD>;
            close(CMD);

            foreach (@result) {
                my @list = split( /\s+/, $_ );
                my $data = '';

                if ( $command eq 'load_avg' ) {
                    $data .= "avg(1min)\tavg(5min)\tavg(15min)\n";
                    foreach ( $list[8], $list[9], $list[10] ) {
                        $_ =~ s/,//g;
                        $data .= $_ . "\t\t";
                    }
                }
                else {
                    foreach (@list) {
                        $data .= $_ . "\t";
                    }
                }
                chop($data);
                push( @$host_result, $data );
            }
        }

        $all_result->{$host_name} = $host_result;
        $handle->shunlock;
        $pm->finish;
    }
    $pm->wait_all_children;
    return ($all_result);
} 

sub _make_command_line {
    my $self      = shift;
    my $params = shift;

    my $command = $params->{command};
    my $grep_target = $params->{target}->{grep_target};
    my $grep_pattern = $params->{target}->{grep_pattern};

    my $put_cmd = '';
    $put_cmd = ' free'   if ( $command eq 'memory_size' );
    $put_cmd = ' df -h'  if ( $command eq 'disk_size' );
    $put_cmd = ' uptime' if ( $command eq 'load_avg' );

    my $counter = 1;
    if( $command eq 'grep'){
        foreach (@$grep_pattern ){
            if( $counter == 1 ){
                $put_cmd = " grep \'$_\' $grep_target->[0]";
            } else {
                $put_cmd .= " \| grep \'$_\'";
            }
            $counter ++;
        }
    }

    if( $command eq 'perlmod'){
        $put_cmd = ' perl -e ';
        $put_cmd .= '\\\'use ' . '{module}' . '\;';
        $put_cmd .= ' print ' . '{module}' . '\-\>VERSION\\\'';
    }

    my $cmd = 'ssh -A ' . '{host}' . $put_cmd;
    return $cmd;
}

1;

__END__

=head1 NAME

Yoyo::Command - The command statement is executed to two or more hosts.  


=head1 DESCRIPTION

In this module, the command to each host is executed, and the result is acquired. 

=head1 METHODS

=head2 do_command()

=head1 AUTHOR

kazuhiko yamakura E<lt>yamakura@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut






