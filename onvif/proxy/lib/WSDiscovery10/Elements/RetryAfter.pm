
package WSDiscovery10::Elements::RetryAfter;
use strict;
use warnings;

{ # BLOCK to scope variables

sub get_xmlns { 'http://schemas.xmlsoap.org/ws/2004/08/addressing' }

__PACKAGE__->__set_name('RetryAfter');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref();
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    WSDiscovery10::Types::RetryAfterType
);

}

1;


=pod

=head1 NAME

WSDiscovery10::Elements::RetryAfter

=head1 DESCRIPTION

Perl data type class for the XML Schema defined element
RetryAfter from the namespace http://schemas.xmlsoap.org/ws/2004/08/addressing.







=head1 METHODS

=head2 new

 my $element = WSDiscovery10::Elements::RetryAfter->new($data);

Constructor. The following data structure may be passed to new():

 { value => $some_value },

=head1 AUTHOR

Generated by SOAP::WSDL

=cut

