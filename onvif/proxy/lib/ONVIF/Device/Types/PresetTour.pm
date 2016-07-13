package ONVIF::Device::Types::PresetTour;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'http://www.onvif.org/ver10/schema' };

our $XML_ATTRIBUTE_CLASS = 'ONVIF::Device::Types::PresetTour::_PresetTour::XmlAttr';

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %Name_of :ATTR(:get<Name>);
my %Status_of :ATTR(:get<Status>);
my %AutoStart_of :ATTR(:get<AutoStart>);
my %StartingCondition_of :ATTR(:get<StartingCondition>);
my %TourSpot_of :ATTR(:get<TourSpot>);
my %Extension_of :ATTR(:get<Extension>);

__PACKAGE__->_factory(
    [ qw(        Name
        Status
        AutoStart
        StartingCondition
        TourSpot
        Extension

    ) ],
    {
        'Name' => \%Name_of,
        'Status' => \%Status_of,
        'AutoStart' => \%AutoStart_of,
        'StartingCondition' => \%StartingCondition_of,
        'TourSpot' => \%TourSpot_of,
        'Extension' => \%Extension_of,
    },
    {
        'Name' => 'ONVIF::Device::Types::Name',
        'Status' => 'ONVIF::Device::Types::PTZPresetTourStatus',
        'AutoStart' => 'SOAP::WSDL::XSD::Typelib::Builtin::boolean',
        'StartingCondition' => 'ONVIF::Device::Types::PTZPresetTourStartingCondition',
        'TourSpot' => 'ONVIF::Device::Types::PTZPresetTourSpot',
        'Extension' => 'ONVIF::Device::Types::PTZPresetTourExtension',
    },
    {

        'Name' => 'Name',
        'Status' => 'Status',
        'AutoStart' => 'AutoStart',
        'StartingCondition' => 'StartingCondition',
        'TourSpot' => 'TourSpot',
        'Extension' => 'Extension',
    }
);

} # end BLOCK




package ONVIF::Device::Types::PresetTour::_PresetTour::XmlAttr;
use base qw(SOAP::WSDL::XSD::Typelib::AttributeSet);

{ # BLOCK to scope variables

my %token_of :ATTR(:get<token>);

__PACKAGE__->_factory(
    [ qw(
        token
    ) ],
    {

        token => \%token_of,
    },
    {
        token => 'ONVIF::Device::Types::ReferenceToken',
    }
);

} # end BLOCK




1;


=pod

=head1 NAME

ONVIF::Device::Types::PresetTour

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
PresetTour from the namespace http://www.onvif.org/ver10/schema.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * Name


=item * Status


=item * AutoStart


=item * StartingCondition


=item * TourSpot


=item * Extension




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # ONVIF::Device::Types::PresetTour
   Name => $some_value, # Name
   Status =>  { # ONVIF::Device::Types::PTZPresetTourStatus
     State => $some_value, # PTZPresetTourState
     CurrentTourSpot =>  { # ONVIF::Device::Types::PTZPresetTourSpot
       PresetDetail =>        { # ONVIF::Device::Types::PTZPresetTourPresetDetail
         # One of the following elements.
         # No occurance checks yet, so be sure to pass just one...
         PresetToken => $some_value, # ReferenceToken
         Home =>  $some_value, # boolean
         PTZPosition =>  { # ONVIF::Device::Types::PTZVector
           PanTilt => ,
           Zoom => ,
         },
         TypeExtension =>  { # ONVIF::Device::Types::PTZPresetTourTypeExtension
         },
       },
       Speed =>  { # ONVIF::Device::Types::PTZSpeed
         PanTilt => ,
         Zoom => ,
       },
       StayTime =>  $some_value, # duration
       Extension =>  { # ONVIF::Device::Types::PTZPresetTourSpotExtension
       },
     },
     Extension =>  { # ONVIF::Device::Types::PTZPresetTourStatusExtension
     },
   },
   AutoStart =>  $some_value, # boolean
   StartingCondition =>  { # ONVIF::Device::Types::PTZPresetTourStartingCondition
     RecurringTime =>  $some_value, # int
     RecurringDuration =>  $some_value, # duration
     Direction => $some_value, # PTZPresetTourDirection
     Extension =>  { # ONVIF::Device::Types::PTZPresetTourStartingConditionExtension
     },
   },
   TourSpot =>  { # ONVIF::Device::Types::PTZPresetTourSpot
     PresetDetail =>      { # ONVIF::Device::Types::PTZPresetTourPresetDetail
       # One of the following elements.
       # No occurance checks yet, so be sure to pass just one...
       PresetToken => $some_value, # ReferenceToken
       Home =>  $some_value, # boolean
       PTZPosition =>  { # ONVIF::Device::Types::PTZVector
         PanTilt => ,
         Zoom => ,
       },
       TypeExtension =>  { # ONVIF::Device::Types::PTZPresetTourTypeExtension
       },
     },
     Speed =>  { # ONVIF::Device::Types::PTZSpeed
       PanTilt => ,
       Zoom => ,
     },
     StayTime =>  $some_value, # duration
     Extension =>  { # ONVIF::Device::Types::PTZPresetTourSpotExtension
     },
   },
   Extension =>  { # ONVIF::Device::Types::PTZPresetTourExtension
   },
 },



=head2 attr

NOTE: Attribute documentation is experimental, and may be inaccurate.
See the correspondent WSDL/XML Schema if in question.

This class has additional attributes, accessibly via the C<attr()> method.

attr() returns an object of the class ONVIF::Device::Types::PresetTour::_PresetTour::XmlAttr.

The following attributes can be accessed on this object via the corresponding
get_/set_ methods:

=over

=item * token

 Unique identifier of this preset tour.



This attribute is of type L<ONVIF::Device::Types::ReferenceToken|ONVIF::Device::Types::ReferenceToken>.


=back




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

