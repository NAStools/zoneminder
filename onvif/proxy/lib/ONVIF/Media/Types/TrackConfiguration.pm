package ONVIF::Media::Types::TrackConfiguration;
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

my %TrackType_of :ATTR(:get<TrackType>);
my %Description_of :ATTR(:get<Description>);

__PACKAGE__->_factory(
    [ qw(        TrackType
        Description

    ) ],
    {
        'TrackType' => \%TrackType_of,
        'Description' => \%Description_of,
    },
    {
        'TrackType' => 'ONVIF::Media::Types::TrackType',
        'Description' => 'ONVIF::Media::Types::Description',
    },
    {

        'TrackType' => 'TrackType',
        'Description' => 'Description',
    }
);

} # end BLOCK








1;


=pod

=head1 NAME

ONVIF::Media::Types::TrackConfiguration

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
TrackConfiguration from the namespace http://www.onvif.org/ver10/schema.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * TrackType


=item * Description




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # ONVIF::Media::Types::TrackConfiguration
   TrackType => $some_value, # TrackType
   Description => $some_value, # Description
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

