package Test::TestMaker;

use strict;
use base 'My::Test::Class';
use Test::More;

sub constructor : Tests() {
    my $test = shift;

    can_ok($test->class(), 'new');
}

sub createTests : Tests() {
    my $test = shift;

    can_ok($test->class(), 'createTests');
}

sub _wanted : Tests() {
    my $test = shift;

    can_ok($test->class(), '_wanted');
}

sub checkForModules : Tests() {
    my $test = shift;

    can_ok($test->class(), 'checkForModules');
}

sub createTestBase : Tests() {
    my $test = shift;

    can_ok($test->class(), 'createTestBase');
}

sub _makeRunFile : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeRunFile');
}

sub _makeMyTestClass : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeMyTestClass');
}

1;
