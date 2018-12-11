#!/usr/bin/env perl

use lib 'src';

use strict;
use warnings;

use Email::MIME;
use XML::Twig;

use Report;

my $message = "";

while (<STDIN>) {
  $message .= $_;
}

sub unpack_zip {
  my $parsed = Email::MIME->new($_[0]);

  my $xml;

  $parsed->walk_parts(sub {
    my ($part) = @_;
    return if $part->subparts or $xml; # multipart or found

    if ( $part->content_type =~ m[application/zip]i ) {
      $xml = $part->body;
    }
  });

  die 'No zip found.' if !$xml;

  $xml =~ s/^[^<]*//;
  $xml =~ s/[^>]*$//;

  return $xml
}

sub parse_xml {
  my ($xml) = @_;
  my $t = XML::Twig->new();
  $t->parse($xml);
  my $root = $t->root;

  die 'Root element is not <feedback>' if $root->tag cmp 'feedback';

  my %data = (
    'report_metadata' => $root->first_child('report_metadata')->simplify(),
    'policy_published' => $root->first_child('policy_published')->simplify(),
    'records' => [],
  );

  # Iterate over all records
  foreach my $child ($root->children('record')) {
    push @{ $data{'records'} }, $child->simplify()
  }

  return %data;
}

my $xml = unpack_zip($message);
my %data = parse_xml($xml);

Report->new(\%data);
