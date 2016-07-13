package ONVIF::Device::Types::NetworkInterface;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'http://www.onvif.org/ver10/schema' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}


use base qw(ONVIF::Device::Types::DeviceEntity);
# Variety: sequence
use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %Enabled_of :ATTR(:get<Enabled>);
my %Info_of :ATTR(:get<Info>);
my %Link_of :ATTR(:get<Link>);
my %IPv4_of :ATTR(:get<IPv4>);
my %IPv6_of :ATTR(:get<IPv6>);
my %Extension_of :ATTR(:get<Extension>);

__PACKAGE__->_factory(
    [ qw(        Enabled
        Info
        Link
        IPv4
        IPv6
        Extension

    ) ],
    {
        'Enabled' => \%Enabled_of,
        'Info' => \%Info_of,
        'Link' => \%Link_of,
        'IPv4' => \%IPv4_of,
        'IPv6' => \%IPv6_of,
        'Extension' => \%Extension_of,
    },
    {
        'Enabled' => 'SOAP::WSDL::XSD::Typelib::Builtin::boolean',
        'Info' => 'ONVIF::Device::Types::NetworkInterfaceInfo',
        'Link' => 'ONVIF::Device::Types::NetworkInterfaceLink',
        'IPv4' => 'ONVIF::Device::Types::IPv4NetworkInterface',
        'IPv6' => 'ONVIF::Device::Types::IPv6NetworkInterface',
        'Extension' => 'ONVIF::Device::Types::NetworkInterfaceExtension',
    },
    {

        'Enabled' => 'Enabled',
        'Info' => 'Info',
        'Link' => 'Link',
        'IPv4' => 'IPv4',
        'IPv6' => 'IPv6',
        'Extension' => 'Extension',
    }
);

} # end BLOCK








1;


=pod

=head1 NAME

ONVIF::Device::Types::NetworkInterface

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
NetworkInterface from the namespace http://www.onvif.org/ver10/schema.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * Enabled


=item * Info


=item * Link


=item * IPv4


=item * IPv6


=item * Extension




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # ONVIF::Device::Types::NetworkInterface
   Enabled =>  $some_value, # boolean
   Info =>  { # ONVIF::Device::Types::NetworkInterfaceInfo
     Name =>  $some_value, # string
     HwAddress => $some_value, # HwAddress
     MTU =>  $some_value, # int
   },
   Link =>  { # ONVIF::Device::Types::NetworkInterfaceLink
     AdminSettings =>  { # ONVIF::Device::Types::NetworkInterfaceConnectionSetting
       AutoNegotiation =>  $some_value, # boolean
       Speed =>  $some_value, # int
       Duplex => $some_value, # Duplex
     },
     OperSettings =>  { # ONVIF::Device::Types::NetworkInterfaceConnectionSetting
       AutoNegotiation =>  $some_value, # boolean
       Speed =>  $some_value, # int
       Duplex => $some_value, # Duplex
     },
     InterfaceType => $some_value, # IANA-IfTypes
   },
   IPv4 =>  { # ONVIF::Device::Types::IPv4NetworkInterface
     Enabled =>  $some_value, # boolean
     Config =>  { # ONVIF::Device::Types::IPv4Configuration
       Manual =>  { # ONVIF::Device::Types::PrefixedIPv4Address
         Address => $some_value, # IPv4Address
         PrefixLength =>  $some_value, # int
       },
       LinkLocal =>  { # ONVIF::Device::Types::PrefixedIPv4Address
         Address => $some_value, # IPv4Address
         PrefixLength =>  $some_value, # int
       },
       FromDHCP =>  { # ONVIF::Device::Types::PrefixedIPv4Address
         Address => $some_value, # IPv4Address
         PrefixLength =>  $some_value, # int
       },
       DHCP =>  $some_value, # boolean
     },
   },
   IPv6 =>  { # ONVIF::Device::Types::IPv6NetworkInterface
     Enabled =>  $some_value, # boolean
     Config =>  { # ONVIF::Device::Types::IPv6Configuration
       AcceptRouterAdvert =>  $some_value, # boolean
       DHCP => $some_value, # IPv6DHCPConfiguration
       Manual =>  { # ONVIF::Device::Types::PrefixedIPv6Address
         Address => $some_value, # IPv6Address
         PrefixLength =>  $some_value, # int
       },
       LinkLocal =>  { # ONVIF::Device::Types::PrefixedIPv6Address
         Address => $some_value, # IPv6Address
         PrefixLength =>  $some_value, # int
       },
       FromDHCP =>  { # ONVIF::Device::Types::PrefixedIPv6Address
         Address => $some_value, # IPv6Address
         PrefixLength =>  $some_value, # int
       },
       FromRA =>  { # ONVIF::Device::Types::PrefixedIPv6Address
         Address => $some_value, # IPv6Address
         PrefixLength =>  $some_value, # int
       },
       Extension =>  { # ONVIF::Device::Types::IPv6ConfigurationExtension
       },
     },
   },
   Extension =>  { # ONVIF::Device::Types::NetworkInterfaceExtension
     InterfaceType => $some_value, # IANA-IfTypes
     Dot3 =>  { # ONVIF::Device::Types::Dot3Configuration
     },
     Dot11 =>  { # ONVIF::Device::Types::Dot11Configuration
       SSID => $some_value, # Dot11SSIDType
       Mode => $some_value, # Dot11StationMode
       Alias => $some_value, # Name
       Priority => $some_value, # NetworkInterfaceConfigPriority
       Security =>  { # ONVIF::Device::Types::Dot11SecurityConfiguration
         Mode => $some_value, # Dot11SecurityMode
         Algorithm => $some_value, # Dot11Cipher
         PSK =>  { # ONVIF::Device::Types::Dot11PSKSet
           Key => $some_value, # Dot11PSK
           Passphrase => $some_value, # Dot11PSKPassphrase
           Extension =>  { # ONVIF::Device::Types::Dot11PSKSetExtension
           },
         },
         Dot1X => $some_value, # ReferenceToken
         Extension =>  { # ONVIF::Device::Types::Dot11SecurityConfigurationExtension
         },
       },
     },
     Extension =>  { # ONVIF::Device::Types::NetworkInterfaceExtension2
     },
   },
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

