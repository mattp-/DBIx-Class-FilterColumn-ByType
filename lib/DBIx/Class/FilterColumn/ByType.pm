package DBIx::Class::FilterColumn::ByType;
# ABSTRACT: Apply FilterColumn by type instead of name
BEGIN {
# VERSION
}

use strict;
use warnings;

use base qw/DBIx::Class::FilterColumn/;

use namespace::clean;

sub filter_columns_by_type {
  my ($self, @args) = @_;

  while (my ($types, $hash) = splice @args, 0, 2) {
    # flatten
    for my $type (map { (ref) ? @$_ : $_ } $types) {
      # find matching columns
      my $cols = $self->columns_info;
      while (my ($col, $attrs) = each %$cols) {
        next unless $attrs->{data_type} eq $type;

        # pass through to filter_columns. let validation happen there
        $self->filter_column($col => $hash);
      }
    }
  }
}

1;

__END__

=pod

=encoding utf-8

=head1 SYNOPSIS

In your Schema or DB class add "FilterColumn::ByType" to the top of the component list.

  __PACKAGE__->load_components(qw( FilterColumn::ByType ... ));

Set up filters for the column types you want to convert.

 __PACKAGE__->filter_columns_by_type( [qw/varchar text/] => {
     filter_to_storage => 'to_pennies',
     filter_from_storage => 'from_pennies',
 });

 sub to_pennies   { $_[1] * 100 }

 sub from_pennies { $_[1] / 100 }

 1;

=head1 DESCRIPTION

This module is a subclass of L<DBIx::Class::FilterColumn>, which allows you to attach filters
by column type, as well as by column name. You should look at L<DBIx::Class::FilterColumn>
documentation for a full explanation of how that works.

=head1 METHODS

=head2 filter_column_by_type

 __PACKAGE__->filter_column( coltype => { ... })

 __PACKAGE__->filter_column( [qw/coltype/] => { ... })

This method takes two arguments. The first, coltype, can be either an array of
scalars, or a scalar that describe the type(s) the filters will be attached to.
The second argument is passed straight through to FilterColumn::filter_column()
without modifcation. All Filter functionality is inherited directly from
FilerColumn, so if you looking there for a more indepth explanation of
functionality would be a good start.

=head1 SEE ALSO

L<DBIx::Class>, L<DBIx::Class::FilterColumn>
