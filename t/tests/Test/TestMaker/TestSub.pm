package Test::TestMaker::TestSub;

use strict;
use base 'My::Test::Class';
use Test::Most;

sub constructor : Tests() {
    my $test = shift;

    can_ok($test->class(), 'new');
}

sub subName : Tests() {
    my $test = shift;

    can_ok($test->class(), 'subName');
}

sub testSubName : Tests() {
    my $test = shift;

    can_ok($test->class(), 'testSubName');
}

sub _validateSubName : Tests() {
    my $test = shift;

    can_ok($test->class(), '_validateSubName');
}

sub testSubDefinition : Tests() {
    my $test = shift;

    can_ok($test->class(), 'testSubDefinition');
}

1;
