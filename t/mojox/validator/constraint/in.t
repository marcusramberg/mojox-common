use strict;
use Test::More tests => 4;

use MojoX::Validator::Constraint::In;

my $constraint = MojoX::Validator::Constraint::In->new(args => [1, 5, 7]);

ok($constraint);

is($constraint->is_valid(1), 1);

is($constraint->is_valid(7), 1);

is($constraint->is_valid(2), 0);
