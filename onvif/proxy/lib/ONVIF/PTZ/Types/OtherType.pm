package ONVIF::PTZ::Types::OtherType;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'http://www.onvif.org/ver10/schema' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %Type_of :ATTR(:get<Type>);
my %Likelihood_of :ATTR(:get<Likelihood>);

__PACKAGE__->_factory(
    [ qw(        Type
        Likelihood

    ) ],
    {
        'Type' => \%Type_of,
        'Likelihood' => \%Likelihood_of,
    },
    {
        'Type' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'Likelihood' => 'SOAP::WSDL::XSD::Typelib::Builtin::float',
    },
    {

        'Type' => 'Type',
        'Likelihood' => 'Likelihood',
    }
);

} # end BLOCK








1;


=pod

=head1 NAME

ONVIF::PTZ::Types::OtherType

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
OtherType from the namespace http://www.onvif.org/ver10/schema.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * Type


=item * Likelihood




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # ONVIF::PTZ::Types::OtherType
   Type =>  $some_value, # string
   Likelihood =>  $some_value, # float
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

