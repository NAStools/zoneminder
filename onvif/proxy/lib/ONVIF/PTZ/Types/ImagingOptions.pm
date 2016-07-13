package ONVIF::PTZ::Types::ImagingOptions;
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

my %BacklightCompensation_of :ATTR(:get<BacklightCompensation>);
my %Brightness_of :ATTR(:get<Brightness>);
my %ColorSaturation_of :ATTR(:get<ColorSaturation>);
my %Contrast_of :ATTR(:get<Contrast>);
my %Exposure_of :ATTR(:get<Exposure>);
my %Focus_of :ATTR(:get<Focus>);
my %IrCutFilterModes_of :ATTR(:get<IrCutFilterModes>);
my %Sharpness_of :ATTR(:get<Sharpness>);
my %WideDynamicRange_of :ATTR(:get<WideDynamicRange>);
my %WhiteBalance_of :ATTR(:get<WhiteBalance>);

__PACKAGE__->_factory(
    [ qw(        BacklightCompensation
        Brightness
        ColorSaturation
        Contrast
        Exposure
        Focus
        IrCutFilterModes
        Sharpness
        WideDynamicRange
        WhiteBalance

    ) ],
    {
        'BacklightCompensation' => \%BacklightCompensation_of,
        'Brightness' => \%Brightness_of,
        'ColorSaturation' => \%ColorSaturation_of,
        'Contrast' => \%Contrast_of,
        'Exposure' => \%Exposure_of,
        'Focus' => \%Focus_of,
        'IrCutFilterModes' => \%IrCutFilterModes_of,
        'Sharpness' => \%Sharpness_of,
        'WideDynamicRange' => \%WideDynamicRange_of,
        'WhiteBalance' => \%WhiteBalance_of,
    },
    {
        'BacklightCompensation' => 'ONVIF::PTZ::Types::BacklightCompensationOptions',
        'Brightness' => 'ONVIF::PTZ::Types::FloatRange',
        'ColorSaturation' => 'ONVIF::PTZ::Types::FloatRange',
        'Contrast' => 'ONVIF::PTZ::Types::FloatRange',
        'Exposure' => 'ONVIF::PTZ::Types::ExposureOptions',
        'Focus' => 'ONVIF::PTZ::Types::FocusOptions',
        'IrCutFilterModes' => 'ONVIF::PTZ::Types::IrCutFilterMode',
        'Sharpness' => 'ONVIF::PTZ::Types::FloatRange',
        'WideDynamicRange' => 'ONVIF::PTZ::Types::WideDynamicRangeOptions',
        'WhiteBalance' => 'ONVIF::PTZ::Types::WhiteBalanceOptions',
    },
    {

        'BacklightCompensation' => 'BacklightCompensation',
        'Brightness' => 'Brightness',
        'ColorSaturation' => 'ColorSaturation',
        'Contrast' => 'Contrast',
        'Exposure' => 'Exposure',
        'Focus' => 'Focus',
        'IrCutFilterModes' => 'IrCutFilterModes',
        'Sharpness' => 'Sharpness',
        'WideDynamicRange' => 'WideDynamicRange',
        'WhiteBalance' => 'WhiteBalance',
    }
);

} # end BLOCK








1;


=pod

=head1 NAME

ONVIF::PTZ::Types::ImagingOptions

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
ImagingOptions from the namespace http://www.onvif.org/ver10/schema.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * BacklightCompensation


=item * Brightness


=item * ColorSaturation


=item * Contrast


=item * Exposure


=item * Focus


=item * IrCutFilterModes


=item * Sharpness


=item * WideDynamicRange


=item * WhiteBalance




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # ONVIF::PTZ::Types::ImagingOptions
   BacklightCompensation =>  { # ONVIF::PTZ::Types::BacklightCompensationOptions
     Mode => $some_value, # WideDynamicMode
     Level =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
   },
   Brightness =>  { # ONVIF::PTZ::Types::FloatRange
     Min =>  $some_value, # float
     Max =>  $some_value, # float
   },
   ColorSaturation =>  { # ONVIF::PTZ::Types::FloatRange
     Min =>  $some_value, # float
     Max =>  $some_value, # float
   },
   Contrast =>  { # ONVIF::PTZ::Types::FloatRange
     Min =>  $some_value, # float
     Max =>  $some_value, # float
   },
   Exposure =>  { # ONVIF::PTZ::Types::ExposureOptions
     Mode => $some_value, # ExposureMode
     Priority => $some_value, # ExposurePriority
     MinExposureTime =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     MaxExposureTime =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     MinGain =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     MaxGain =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     MinIris =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     MaxIris =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     ExposureTime =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     Gain =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     Iris =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
   },
   Focus =>  { # ONVIF::PTZ::Types::FocusOptions
     AutoFocusModes => $some_value, # AutoFocusMode
     DefaultSpeed =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     NearLimit =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     FarLimit =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
   },
   IrCutFilterModes => $some_value, # IrCutFilterMode
   Sharpness =>  { # ONVIF::PTZ::Types::FloatRange
     Min =>  $some_value, # float
     Max =>  $some_value, # float
   },
   WideDynamicRange =>  { # ONVIF::PTZ::Types::WideDynamicRangeOptions
     Mode => $some_value, # WideDynamicMode
     Level =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
   },
   WhiteBalance =>  { # ONVIF::PTZ::Types::WhiteBalanceOptions
     Mode => $some_value, # WhiteBalanceMode
     YrGain =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
     YbGain =>  { # ONVIF::PTZ::Types::FloatRange
       Min =>  $some_value, # float
       Max =>  $some_value, # float
     },
   },
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

