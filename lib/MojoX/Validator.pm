package MojoX::Validator;

use strict;
use warnings;

use base 'Mojo::Base';

use MojoX::Validator::Field;

__PACKAGE__->attr('current_field');
__PACKAGE__->attr('fields' => sub { {} });
__PACKAGE__->attr(has_errors => 0);
__PACKAGE__->attr(trim       => 1);

sub field {
    my $self = shift;
    my $name = shift;

    my $field = MojoX::Validator::Field->new(name => $name);

    $self->current_field($name);

    $self->fields->{$name} = $field;
}

sub errors {
    my ($self) = @_;

    my $errors = {};

    foreach my $field (values %{$self->fields}) {
        $errors->{$field->name} = $field->error if $field->error;
    }

    return $errors;
}

sub clear_errors {
    my ($self) = @_;

    foreach my $field (values %{$self->fields}) {
        $field->error('');
    }

    $self->has_errors(0);
}

sub trim_fields {
    my $self = shift;

    foreach my $field (values %{$self->fields}) {
        my $value = $field->value;
        next unless defined $value;

        $value =~ s/^\s+//;
        $value =~ s/\s+$//;
        $field->value($value);
    }
}

sub validate {
    my ($self) = shift;
    my $params = shift;

    $self->clear_errors;

    #$self->trim_fields if $self->trim;

    foreach my $field (values %{$self->fields}) {
        $field->clear_value;

        $field->value($params->{$field->name});

        $self->has_errors(1) unless $field->is_valid;
    }

    return !$self->has_errors ? 1 : 0;
}

sub values {
    my $self = shift;

    my $values = {};

    foreach my $field (values %{$self->fields}) {
        $values->{$field->name} = $field->value if defined $field->value;
    }

    return $values;
}

1;