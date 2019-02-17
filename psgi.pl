use utf8;
use warnings;
use strict;
use lib "$ENV{'LAMBDA_TASK_ROOT'}/extlocal/lib/perl5";
use AWS::Lambda::PSGI;

my $app = require "$ENV{'LAMBDA_TASK_ROOT'}/formatter.psgi";
my $func = AWS::Lambda::PSGI->wrap($app);

sub handle {
    my $payload = shift;
    return $func->($payload);
}

1;
