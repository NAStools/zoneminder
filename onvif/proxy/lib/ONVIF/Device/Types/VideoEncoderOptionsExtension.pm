package ONVIF::Device::Types::VideoEncoderOptionsExtension;
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

my %JPEG_of :ATTR(:get<JPEG>);
my %MPEG4_of :ATTR(:get<MPEG4>);
my %H264_of :ATTR(:get<H264>);
my %Extension_of :ATTR(:get<Extension>);

__PACKAGE__->_factory(
    [ qw(        JPEG
        MPEG4
        H264
        Extension

    ) ],
    {
        'JPEG' => \%JPEG_of,
        'MPEG4' => \%MPEG4_of,
        'H264' => \%H264_of,
        'Extension' => \%Extension_of,
    },
    {
        'JPEG' => 'ONVIF::Device::Types::JpegOptions2',
        'MPEG4' => 'ONVIF::Device::Types::Mpeg4Options2',
        'H264' => 'ONVIF::Device::Types::H264Options2',
        'Extension' => 'ONVIF::Device::Types::VideoEncoderOptionsExtension2',
    },
    {

        'JPEG' => 'JPEG',
        'MPEG4' => 'MPEG4',
        'H264' => 'H264',
        'Extension' => 'Extension',
    }
);

} # end BLOCK








1;


=pod

=head1 NAME

ONVIF::Device::Types::VideoEncoderOptionsExtension

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
VideoEncoderOptionsExtension from the namespace http://www.onvif.org/ver10/schema.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * JPEG


=item * MPEG4


=item * H264


=item * Extension




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # ONVIF::Device::Types::VideoEncoderOptionsExtension
   JPEG =>  { # ONVIF::Device::Types::JpegOptions2
     BitrateRange =>  { # ONVIF::Device::Types::IntRange
       Min =>  $some_value, # int
       Max =>  $some_value, # int
     },
   },
   MPEG4 =>  { # ONVIF::Device::Types::Mpeg4Options2
     BitrateRange =>  { # ONVIF::Device::Types::IntRange
       Min =>  $some_value, # int
       Max =>  $some_value, # int
     },
   },
   H264 =>  { # ONVIF::Device::Types::H264Options2
     BitrateRange =>  { # ONVIF::Device::Types::IntRange
       Min =>  $some_value, # int
       Max =>  $some_value, # int
     },
   },
   Extension =>  { # ONVIF::Device::Types::VideoEncoderOptionsExtension2
   },
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

