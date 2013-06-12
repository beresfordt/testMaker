package Test::TestMaker::TestSub;

use strict;
use base 'My::Test::Class';
use Test::Most;

sub constructor : Tests() {
    my $test = shift;

    can_ok($test->class(), 'new');

    dies_ok {
        $test->class->new()
    } '.... dies with no args';

    dies_ok {
        $test->class->new({subName => undef})
    } '.... dies with subName undef';

    lives_ok {
        $test->class->new({subName => 'new'})
    } '.... lives with subName as new';
}

sub subName : Tests() {
    my $test = shift;

    can_ok($test->class(), 'subName');

    my $testSub = $test->testSubFactory('blah');
    is($testSub->subName(), 'blah', '.... we return the expected subName after construction');

    dies_ok {
        $testSub->subName(undef)
    } '.... dies if we try and set subName to undef';
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

sub testSubFactory {
    my ($test, $subName) = @_;
    if ($subName) {
        return $test->class->new({subName => $subName});
    }
    else {
        return $test->class->new({subName => 'testSub'});
    }
}

1;
