package WSDiscovery10::Types::Relationship;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(0);

sub get_xmlns { 'http://schemas.xmlsoap.org/ws/2004/08/addressing' };

our $XML_ATTRIBUTE_CLASS = 'WSDiscovery10::Types::Relationship::_Relationship::XmlAttr';

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use base qw(
    SOAP::WSDL::XSD::Typelib::ComplexType
    SOAP::WSDL::XSD::Typelib::Builtin::anyURI
);

package WSDiscovery10::Types::Relationship::_Relationship::XmlAttr;
use base qw(SOAP::WSDL::XSD::Typelib::AttributeSet);

{ # BLOCK to scope variables

my %RelationshipType_of :ATTR(:get<RelationshipType>);

__PACKAGE__->_factory(
    [ qw(
        RelationshipType
    ) ],
    {

        RelationshipType => \%RelationshipType_of,
    },
    {
        RelationshipType => 'SOAP::WSDL::XSD::Typelib::Builtin::QName',
    }
);

} # end BLOCK




1;


=pod

=head1 NAME

WSDiscovery10::Types::Relationship

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
Relationship from the namespace http://schemas.xmlsoap.org/ws/2004/08/addressing.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over



=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { value => $some_value },



=head2 attr

NOTE: Attribute documentation is experimental, and may be inaccurate.
See the correspondent WSDL/XML Schema if in question.

This class has additional attributes, accessibly via the C<attr()> method.

attr() returns an object of the class WSDiscovery10::Types::Relationship::_Relationship::XmlAttr.

The following attributes can be accessed on this object via the corresponding
get_/set_ methods:

=over

=item * RelationshipType



This attribute is of type L<SOAP::WSDL::XSD::Typelib::Builtin::QName|SOAP::WSDL::XSD::Typelib::Builtin::QName>.


=back




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

