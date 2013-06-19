# NAME

TestMaker - Create test class classes from your existing lib/

# VERSION

version 1.1

# SYNOPSIS

testMaker

To be run in base dir of project

assuming existing structure:

- lib/My/Class.pm
- lib/My/Class/Stuff.pm

will create

- t/run.t

    Test::Class test runner

- t/tests/My/Test/Class.pm

    Test::Class custom base class

- t/tests/Test/My/Class.pm

    A test class based on lib/My/Class.pm

- t/tests/Test/My/Class/Stuff.pm

    A test class based on lib/My/Class/Stuff.pm

# DESCRIPTION

If you have an existing structure of classes in /lib running this script
will create a skeleton Test::Class test class for each. Within that test
class each of the subs in you lib class will have a test sub created with
a can\_ok test.

The test classes will contain test subs, with a use\_ok for that sub. The
custom base test class, as parent, will make sure each child test class
on startup performs a use\_ok for the lib class you are testing

The script expects to be run in the base of your project (eg the dir
which contains lib/ t/ and so on).

Should a Test::Class test runner not exist one will be created.

A custom base class will also be created if it does not exist, which all
test classes created by this script inherit from.

Once the script has been run, all being well, you will be able to run your
test suite from the base dir of your project using

`prove -lv --merge`

This script performs a check for [Test::Class](http://search.cpan.org/perldoc?Test::Class), [Test::More](http://search.cpan.org/perldoc?Test::More) and
[Class::Data::Inheritable](http://search.cpan.org/perldoc?Class::Data::Inheritable) and will complain at you if they are not
installed. To go ahead and run the script anyway use the -f flag:

`testMaker.pl -f`

# CAVEATS

It currently does not filter out any sub definitions which are contained
within pod sections of your class, and probably never will.

# SEE ALSO

[Test::Class](http://search.cpan.org/perldoc?Test::Class)

[Class::Data::Inheritable](http://search.cpan.org/perldoc?Class::Data::Inheritable)

[Test::More](http://search.cpan.org/perldoc?Test::More)

[Test::Most](http://search.cpan.org/perldoc?Test::Most)

# ACKNOWLEDGEMENTS

Based on the excellent tutorial on Test::Class by Curtis "Ovid" Poe,
<ovid at cpan.org> [found here](http://www.modernperlbooks.com/mt/2009/03/organizing-test-suites-with-testclass.html)

# AUTHOR

Tom Beresford <me at tomberesford dot co dot uk>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Tom Beresford.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
