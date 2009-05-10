use strict;
use warnings;
use POSIX qw(strftime);

use Yoyo;

use Test::More tests => 1;

my $hosts = Yoyo->new();

## test -> _look_datetime
{
    my $datetime = $hosts->_look_datetime();

    my $check_date = strftime( "%Y-%m-%d %H:%M:%S", localtime());
    is( $datetime, $check_date, 'check _look_datetime method01' );
}

1;


