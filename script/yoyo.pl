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

    $ yoyo.pl 
    
=head1 DESCRIPTION

#####

=head1 AUTHORS

kazuhiko yamakura E<lt>yamakura@cpan.orgE<gt>


