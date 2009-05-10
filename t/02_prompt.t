use strict;
use warnings;

use Yoyo::Prompt;

use Test::More tests => 2;

my $yoyo = Yoyo::Prompt->new();

## test -> look_help
{
    my $result = $yoyo->show_help();

    my $help_string = "\n========================================\n";
    $help_string .= "<Yo-yo Help menu>\n";
    $help_string .= "\n(Command)\t\t: (Meaning)\n";
    $help_string .= "show config\t\t: show this module setting\n";
    $help_string .= "set config ( option )\t: fix this module setting\n";
    $help_string .= "( command )\t: show hosts setting\n";
    $help_string .= "exit | quit\t\t: this module exit\n";

    is( $result, $help_string, 'check method look_help' );
}

## test -> show_config
{
    my $result = $yoyo->show_config('nothing');

    my $view = "\n========================================\n";
    $view .= "<Show Now Config>\n";
    $view .= "Last Update\t=> \n";
    $view .= "Hosts\t\t=> \n";
    $view .= "Perl Modules\t=> \n";
    $view .= "Dump Directory\t=> \n";

    is( $result, $view, 'check method show_config' );

}

1;

