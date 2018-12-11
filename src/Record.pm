#!/usr/bin/env perl

use strict;
use warnings;

package Record;

sub new {
  my (%data) = @_;
  use Data::Dumper;
  print Dumper(\%data);
}

1;
