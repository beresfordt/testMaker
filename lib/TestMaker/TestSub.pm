package TestMaker::TestSub;

use strict;
use warnings;

sub new {
    my ($class, $args) = @_;

    die "subName not defined" unless $args->{subName};

    my $self = {};
    bless $self, $class;

    $self->subName($args->{subName});
    $self->testSubName($args->{subName});

    return $self;
}

sub subName {
    my ($self, $subName) = @_;

    if (defined $subName) {
        chomp($subName);
        die "Bad subName" unless $self->_validateSubName($subName);
        $self->{subName} = $subName;
    }
    return $self->{subName};
}

sub testSubName {
    my ($self, $subName) = @_;

    if (defined $subName) {
        chomp($subName);
        die "Bad subName" unless $self->_validateSubName($subName);
        if($subName eq 'new') {
            $self->{testSubName} = 'constructor';
        }
        else{
            $self->{testSubName} = $subName;
        }
    }
    return $self->{testSubName};
}

sub _validateSubName {
    my ($self, $subName) = @_;

    unless(defined $subName){
        warn "Invalid subName: Not defined";
        return 0;
    }

    unless($subName){
        warn "Invalid subName: $subName does not evalute to true";
        return 0;
    }

    if($subName eq 'sub'){
        warn "Invalid subName: cannot use subName sub";
        return 0;
    }

    return 1;
}

sub testSubDefinition {
    my ($self) = @_;

    die "subName not defined" unless $self->subName();

    my $subDef .= q!sub ! . $self->testSubName() . q! : Tests() {
    my $test = shift;

    can_ok($test->class(), '! . $self->subName() . q!');
}

!;
    return $subDef;
}

1;
