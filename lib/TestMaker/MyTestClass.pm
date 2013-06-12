package TestMaker::MyTestClass;

use strict;

sub fileData {
    return q!package My::Test::Class;

use Test::More;
use base qw<Test::Class Class::Data::Inheritable>;

BEGIN {
    __PACKAGE__->mk_classdata('class');
}

sub startup : Tests( startup => 1 ) {
    my $test = shift;

    (my $class = ref $test) =~ s/^Test:://;
    return ok 1, "$class loaded" if $class eq __PACKAGE__;
    use_ok $class or die;
    $test->class($class);
}

1;
!;
}

1;
