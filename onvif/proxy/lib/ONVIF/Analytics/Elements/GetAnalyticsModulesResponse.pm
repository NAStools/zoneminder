
package ONVIF::Analytics::Elements::GetAnalyticsModulesResponse;
use strict;
use warnings;

{ # BLOCK to scope variables

sub get_xmlns { 'http://www.onvif.org/ver20/analytics/wsdl' }

__PACKAGE__->__set_name('GetAnalyticsModulesResponse');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref();

use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %AnalyticsModule_of :ATTR(:get<AnalyticsModule>);

__PACKAGE__->_factory(
    [ qw(        AnalyticsModule

    ) ],
    {
        'AnalyticsModule' => \%AnalyticsModule_of,
    },
    {
        'AnalyticsModule' => 'ONVIF::Analytics::Types::Config',
    },
    {

        'AnalyticsModule' => 'AnalyticsModule',
    }
);

} # end BLOCK







} # end of BLOCK



1;


=pod

=head1 NAME

ONVIF::Analytics::Elements::GetAnalyticsModulesResponse

=head1 DESCRIPTION

Perl data type class for the XML Schema defined element
GetAnalyticsModulesResponse from the namespace http://www.onvif.org/ver20/analytics/wsdl.







=head1 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * AnalyticsModule

 $element->set_AnalyticsModule($data);
 $element->get_AnalyticsModule();





=back


=head1 METHODS

=head2 new

 my $element = ONVIF::Analytics::Elements::GetAnalyticsModulesResponse->new($data);

Constructor. The following data structure may be passed to new():

 {
   AnalyticsModule =>  { # ONVIF::Analytics::Types::Config
     Parameters =>  { # ONVIF::Analytics::Types::ItemList
       SimpleItem => ,
       ElementItem =>  {
       },
       Extension =>  { # ONVIF::Analytics::Types::ItemListExtension
       },
     },
   },
 },

=head1 AUTHOR

Generated by SOAP::WSDL

=cut
