use strict;
use warnings;

use Yoyo::Prompt;

use Test::More tests => 2;

my $yoyo = Yoyo::Prompt->new();

## test -> look_help
{
    my $result = $yoyo->show_help();

    my $help_string = "\n========================================\n";
    $help_string .= "<Yo-yo Help menu> \n";
    $help_string .= "Usage : \n";
    $help_string .= "disk_size\t: confirm disk size\n";
    $help_string .= "memory_size\t: confirm memory size\n";
    $help_string .= "load_avg\t: confirm load average\n";
    $help_string .= "perlmod\t\t: confirm perl module version.\n\n";
    $help_string .= "show config\t: The setting is confirmed.\n\n";
    $help_string .= "set config hosts=(VALUE;)\t: set host names\n";
    $help_string .= "set config perlmod=(VALUE;)\t: set perl module name\n";
    $help_string .= "set config grep_target=(VALUE;)\t: set grep target file\n";
    $help_string .= "set config grep_pattern=(VALUE;): set grep target pattern\n";
    $help_string .= "set config dumpdir=(VALUE;)\t: set dump directory\n\n";
    $help_string .= "exit | quit\t: this module exit\n";


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

