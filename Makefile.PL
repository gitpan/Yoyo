use inc::Module::Install;
name 'Yoyo';
all_from 'lib/Yoyo.pm';
build_requires 'Test::More';
build_requires 'File::Spec';
build_requires 'Parallel::ForkManager';
build_requires 'IPC::Shareable';
build_requires 'IO::All';

build_requires 'Test::More';
use_test_base;

install_script('script/yoyo.pl');
WriteAll;


