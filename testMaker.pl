#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use File::Path qw(make_path);
use File::Find;
use Getopt::Std;

my $opts = {};
getopts('f', $opts);

checkForModules() unless $opts->{f};

createTestBase();

find({wanted => \&wanted, no_chdir => 1}, 'lib');

sub checkForModules {
    # to require a module from a variable name we need to do some mucking about to
    # translate from :: to /
    for my $module (qw/Test::Class Test::More Class::Data::Inheritable/) {
        # Foo::Bar::Baz => Foo/Bar/Baz.pm
        (my $fn = "$module.pm") =~ s|::|/|g;
        eval {
            require $fn;
            1;
        };
        if ($@) {
            die "$module is required to run the tests created by this script and doesn't seem to be installed
should you wish to run it anyway please use the -f option to override this check
";
        }
    }
}

sub createTestBase {
    make_path('t')               unless -d 't';
    make_path('t/tests/My/Test') unless -d 't/tests/My/Test';

    makeRunFile();
    makeMyTestClass();
}

sub makeRunFile {
    my $runfile = 't/run.t';
    return if -f $runfile;

    open(my $fh, '>', $runfile);
    print $fh '#!/usr/bin/env perl

use Test::Class::Load qw<t/tests>;
Test::Class->runtests;';
}

sub makeMyTestClass {
    my $testClass = 't/tests/My/Test/Class.pm';
    return if -f $testClass;

    local $" = '';
    open(my $fh, '>', $testClass);
    my @content = <DATA>;
    print $fh "@content";
}

sub wanted {
    my $path = $File::Find::name;
    return unless -f $path;

    makeTestDir($path);
    makeTestFile($path);
}

sub makeTestDir {
    my ($libFile) = @_;

    my $testDir = testDir($libFile);
    make_path($testDir) unless -d $testDir;
}

sub testDir {
    my ($libFile) = @_;

    $libFile =~ s/\.pm//;
    $libFile =~ s!lib/!t/tests/Test/!;
    $libFile =~ s!(.*)/\w+$!$1!;
    return $libFile;
}

sub makeTestFile {
    my ($libFile) = @_;

    my $testFilePath = testDir($libFile) . "/" . testFile($libFile);
    return if -e $testFilePath;

    my $content = makeTestFileContent($libFile);

    open(my $testFH, '>', $testFilePath);
    print $testFH $content;
}

sub testFile {
    my ($libFile) = @_;

    $libFile =~ s!.*/(\w+\.pm)$!$1!;
    return $libFile;
}

sub makeTestFileContent {
    my ($libFile) = @_;

    my $testPackageName = testPackageName($libFile);
    my $content         = header($testPackageName);

    open(my $libfh, '<', $libFile);

    while (<$libfh>) {
        next unless $_ =~ /^\s*sub /;
        $content .= testSub($_);
    }
    $content .= "1;\n";

    return $content;
}

sub testPackageName {
    my ($libFile) = @_;

    $libFile =~ s/\.pm//;
    $libFile =~ s!lib/(.*)!Test::$1!;
    $libFile =~ s!/!::!g;
    return $libFile;
}

sub header {
    my ($package) = @_;

    return "package $package;

use strict;
use base 'My::Test::Class';
use Test::Most;

";
}

sub testSub {
    my ($sub) = @_;

    chomp($sub);
    $sub =~ s/\s*sub\s*(.*?) .*/$1/;

    next unless $sub;

    $sub = 'constructor' if $sub eq 'new';

    my $subDef = "sub $sub : Tests() {
    my \$test = shift;

    can_ok(\$test->class(), '$sub');
}

";
    return $subDef;
}

=pod

=head1 NAME

testMaker.pl

=head1 SYNOPSIS

./testMaker.pl

To be run in base dir of project

assuming existing structure:

=over 4

=item lib/My/Class.pm

=item lib/My/Class/Stuff.pm

=back

will create

=over 4

=item t/run.t

Test::Class test runner

=item t/tests/My/Test/Class.pm

Test::Class custom base class

=item t/tests/Test/My/Class.pm

A test class based on lib/My/Class.pm

=item t/tests/Test/My/Class/Stuff.pm

A test class based on lib/My/Class/Stuff.pm

=back

=head1 DESCRIPTION

If you have an existing structure of classes in /lib running this script
will create a skeleton Test::Class test class for each. Within that test
class each of the subs in you lib class will have a test sub created with
a can_ok test.

The test classes will contain test subs, with a use_ok for that sub. The
custom base test class, as parent, will make sure each child test class
on startup performs a use_ok for the lib class you are testing

The script expects to be run in the base of your project (eg the dir
which contains lib/ t/ and so on).

Should a Test::Class test runner not exist one will be created.

A custom base class will also be created if it does not exist, which all
test classes created by this script inherit from.

Once the script has been run, all being well, you will be able to run your
test suite from the base dir of your project using

C<prove -lv --merge>

This script performs a check for L<Test::Class>, L<Test::More> and
L<Class::Data::Inheritable> and will complain at you if they are not
installed. To go ahead and run the script anyway use the -f flag:

C<testMaker.pl -f>

=head1 CAVEATS

It currently does not play nicely with subs which have prototypes, L<which
you probably shouldn't be using anyway!|http://www.perlmonks.org/?node_id=861966>

It currently does not filter out any sub definitions which are contained
within pod sections of your class, and probably never will.

=head1 SEE ALSO

L<Test::Class>

L<Class::Data::Inheritable>

L<Test::More>

L<Test::Most>

=head1 VERSION

version 1.1

=head1 ACKNOWLEDGEMENTS

Based on the excellent tutorial on Test::Class by Curtis "Ovid" Poe,
<ovid at cpan.org> L<found here|http://www.modernperlbooks.com/mt/2009/03/organizing-test-suites-with-testclass.html>

=head1 AUTHOR

Tom Beresford <me at tomberesford dot co dot uk>

=head1 COPYRIGHT AND LICENSE

Copyright 2013 Tom Beresford, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

__DATA__
package My::Test::Class;

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
