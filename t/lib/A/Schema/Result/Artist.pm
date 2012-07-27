package A::Schema::Result::Artist;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('artist');

__PACKAGE__->load_components('FilterColumn::ByType');

__PACKAGE__->add_columns(
  id => {
    data_type => 'int',
    is_auto_increment => 1,
  },
  first_name => {
    data_type => 'varchar',
    size      => 256,
    is_nullable => 1,
  }, last_name => {
    data_type => 'text',
    size      => 256,
    is_nullable => 1,
  },
  counter => {
    data_type => 'int',
    is_nullable => 1,
    is_auto_increment => 0,
  },
);

__PACKAGE__->set_primary_key('id');

our $from_storage_ran = 0;
our $to_storage_ran = 0;

__PACKAGE__->load_components(qw(FilterColumn::ByType));
__PACKAGE__->filter_columns_by_type([qw/varchar text/] => {
  filter_from_storage => sub { $from_storage_ran++; $_[1] . '2' },
  filter_to_storage   => sub { $to_storage_ran++; $_[1] . '1' },
});

__PACKAGE__->filter_columns_by_type(int => {
  filter_to_storage   => sub { $to_storage_ran++; $_[1] + 10 },
});


1;
