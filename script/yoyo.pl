use strict;
use warnings;
use Term::ReadLine;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Yoyo::Prompt;

my $prompt = "\nYo-yo> ";
my $term   = new Term::ReadLine('Yo-yo');
my $out    = $term->OUT || \*STDOUT;

while ( defined( my $command = $term->readline($prompt) ) ) {

    next if $command =~ m/^\s*$/;
    last if $command =~ m/^exit$|^quit$/;

    $term->addhistory($command);

    ## check dump_option
    my $dump_flag = 0;
    if( $command =~ m/\s+\--dump\s*(.*)/g){
        $dump_flag++;
    }

    my $prompt = Yoyo::Prompt->new();
    if( $command eq 'help' ){
        print $prompt->show_help;
    } elsif( $command eq 'show config' ){
        print $prompt->show_config;
    } elsif( $command =~ /set config (\w+\=+\S+)/ ){
        print $prompt->set_config($1); 
    } elsif( $command =~ /(\w+\_*\w+)/ ){
        print $prompt->command($1,$dump_flag); 
    }
}

1;

__END__

=head1 SYNOPSIS

  Usage: yoyo.pl 
         yoyo.pl --dump  

  * When yoyo.pl is carried out, prompt starts.

  Yo-yo> 
 

=head1 DESCRIPTION

The prompt which refers to a command result to each host.

=head1 OPTIONS

=over 1 

=item --dump

It's possible to extract a command result in a designation file.

=back

=head1 EXAMPLE

You can refer to the kind of commands possible by the help command. 

    Yo-yo> help


The present module setting is confirmed.

    Yo-yo> show config


The present module setting is changed.

    Yo-yo> set config hosts=hostname1;hostname2

    Yo-yo> set config perlmod=HTML::Template;Class::Accessor::Fast


The following command should be carried out to confirm the host's setting.

    Yo-yo> disk_size

    Yo-yo> memory_size

    Yo-yo> load_avg

    Yo-yo> perlmod 

    Yo-yo> grep


head1 AUTHORS

kazuhiko yamakura E<lt>yamakura@cpan.orgE<gt>


