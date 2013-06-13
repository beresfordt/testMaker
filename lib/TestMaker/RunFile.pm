package TestMaker::RunFile;

# ABSTRACT: Class to hold test class runner definition

use strict;

sub fileData {
    return '#!/usr/bin/env perl

use Test::Class::Load qw<t/tests>;
Test::Class->runtests;
';
}

1;
