#!/usr/bin/env perl

use strict;
use warnings;

use Record;

package Report;

sub new {
  my ($data) = @_;
  use Data::Dumper;
  # print Dumper(@_);
  print Dumper($data);

  # foreach my $record (@{$data{'Report'}{'records'}}) {
  #   Record->new($record);
  # }
}

1;
