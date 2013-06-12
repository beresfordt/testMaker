package Test::TestMaker::TestClass;

use strict;
use base 'My::Test::Class';
use Test::More;

sub constructor : Tests() {
    my $test = shift;

    can_ok($test->class(), 'new');
}

sub libPath : Tests() {
    my $test = shift;

    can_ok($test->class(), 'libPath');
}

sub _validateLibPath : Tests() {
    my $test = shift;

    can_ok($test->class(), '_validateLibPath');
}

sub makeTestFile : Tests() {
    my $test = shift;

    can_ok($test->class(), 'makeTestFile');
}

sub _testFilePath : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testFilePath');
}

sub _makeTestDir : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeTestDir');
}

sub _testDir : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testDir');
}

sub _testFile : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testFile');
}

sub _makeTestFileContent : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeTestFileContent');
}

sub _tidySubName : Tests() {
    my $test = shift;

    can_ok($test->class(), '_tidySubName');
}

sub _testPackageName : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testPackageName');
}

sub _header : Tests() {
    my $test = shift;

    can_ok($test->class(), '_header');
}

1;
