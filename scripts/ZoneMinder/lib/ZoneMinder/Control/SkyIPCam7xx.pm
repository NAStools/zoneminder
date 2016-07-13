# ==========================================================================
#
# ZoneMinder Airlink SkyIPCam AICN747/AICN747W Control Protocol Module, $Date: 2008-09-13 17:30:29 +0000 (Sat, 13 Sept 2008) $, $Revision: 2229 $
# Copyright (C) 2008  Brian Rudy (brudyNO@SPAMpraecogito.com) 
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# ==========================================================================
#
# This module contains the implementation of the Airlink SkyIPCam 
# AICN747/AICN747W, TrendNet TV-IP410/TV-IP410W and other OEM versions of the 
# Fitivision CS-130A/CS-131A camera control protocol.
#
package ZoneMinder::Control::SkyIPCam7xx;

use 5.006;
use strict;
use warnings;

require ZoneMinder::Base;
require ZoneMinder::Control;

our @ISA = qw(ZoneMinder::Control);

# ==========================================================================
#
#  Airlink SkyIPCam AICN747/AICN747W Control Protocol
#
# ==========================================================================

use ZoneMinder::Logger qw(:all);
use ZoneMinder::Config qw(:all);

use Time::HiRes qw( usleep );

sub new
{
    my $class = shift;
    my $id = shift;
    my $self = ZoneMinder::Control->new( $id );
    bless( $self, $class );
    srand( time() );
    return $self;
}

our $AUTOLOAD;

sub AUTOLOAD
{
    my $self = shift;
    my $class = ref($self) || croak( "$self not object" );
    my $name = $AUTOLOAD;
    $name =~ s/.*://;
    if ( exists($self->{$name}) )
    {
        return( $self->{$name} );
    }
    Fatal( "Can't access $name member of object of class $class" );
}

sub open
{
    my $self = shift;

    $self->loadMonitor();

    use LWP::UserAgent;
    $self->{ua} = LWP::UserAgent->new;
    $self->{ua}->agent( "ZoneMinder Control Agent/".ZoneMinder::Base::ZM_VERSION );

    $self->{state} = 'open';
}

sub close
{
    my $self = shift;
    $self->{state} = 'closed';
}

sub printMsg
{
    my $self = shift;
    my $msg = shift;
    my $msg_len = length($msg);

    Debug( $msg."[".$msg_len."]" );
}

sub sendCmd
{
    my $self = shift;
    my $cmd = shift;

    my $result = undef;

    printMsg( $cmd, "Tx" );

	my $url;
	if ( $self->{Monitor}->{ControlAddress} =~ /^http/ ) {
		$url = $self->{Monitor}->{ControlAddress}.$cmd;
	} else {
		$url = 'http://'.$self->{Monitor}->{ControlAddress}.$cmd;
	} # en dif
	my $req = HTTP::Request->new( GET=>$url );

    my $res = $self->{ua}->request($req);

    if ( $res->is_success )
    {
        $result = !undef;
    }
    else
    {
        Error( "Error check failed: '".$res->status_line()."'" );
    }

    return( $result );
}

sub reset
{
    my $self = shift;
    Debug( "Camera Reset" );
    my $cmd = "/admin/ptctl.cgi?move=reset";
    $self->sendCmd( $cmd );
}

sub moveMap
{
    my $self = shift;
    my $params = shift;
    my $xcoord = $self->getParam( $params, 'xcoord' );
    my $ycoord = $self->getParam( $params, 'ycoord' );

    my $hor = $xcoord * 100 / $self->{Monitor}->{Width};
    my $ver = $ycoord * 100 / $self->{Monitor}->{Height};

    my $maxver = 8;
    my $maxhor = 30;
    
    my $horDir = "right";
    my $verDir = "up";
    my $horSteps = 0;
    my $verSteps = 0;

    # Horizontal movement
    if ($hor < 50) {
    	# left
	$horSteps = ((50 - $hor) / 50) * $maxhor;
	$horDir = "left";
    }
    elsif ($hor > 50) {
	# right
 	$horSteps = (($hor - 50) / 50) * $maxhor;
	$horDir = "right";
    }
   
    # Vertical movement
    if ($ver < 50) {
	# up
	$verSteps = ((50 - $ver) / 50) * $maxver;
	$verDir = "up";
    }
    elsif ($ver > 50) {
	# down
	$verSteps = (($ver - 50) / 50) * $maxver;
	$verDir = "down";
    }

    my $v = int($verSteps);
    my $h = int($horSteps);

    Debug( "Move Map to $xcoord,$ycoord, hor=$h $horDir, ver=$v $verDir");
    my $cmd = "/cgi/admin/ptctrl.cgi?action=movedegree&Cmd=$horDir&Degree=$h";
    $self->sendCmd( $cmd );
    $cmd = "/cgi/admin/ptctrl.cgi?action=movedegree&Cmd=$verDir&Degree=$v";
    $self->sendCmd( $cmd );
}

sub moveRelUp
{
    my $self = shift;
    my $params = shift;
    my $step = $self->getParam( $params, 'tiltstep' );
    Debug( "Step Up $step" );
    my $cmd = "/admin/ptctl.cgi?move=up";
    $self->sendCmd( $cmd );
}

sub moveRelDown
{
    my $self = shift;
    my $params = shift;
    my $step = $self->getParam( $params, 'tiltstep' );
    Debug( "Step Down $step" );
    my $cmd = "/admin/ptctl.cgi?move=down";
    $self->sendCmd( $cmd );
}

sub moveRelLeft
{
    my $self = shift;
    my $params = shift;
    my $step = $self->getParam( $params, 'panstep' );
    Debug( "Step Left $step" );
    my $cmd = "/admin/ptctl.cgi?move=left";
    $self->sendCmd( $cmd );
}

sub moveRelRight
{
    my $self = shift;
    my $params = shift;
    my $step = $self->getParam( $params, 'panstep' );
    Debug( "Step Right $step" );
    my $cmd = "/admin/ptctl.cgi?move=right";
    $self->sendCmd( $cmd );
}

sub presetClear
{
    my $self = shift;
    my $params = shift;
    my $preset = $self->getParam( $params, 'preset' );
    Debug( "Clear Preset $preset" );
    #my $cmd = "/axis-cgi/com/ptz.cgi?removeserverpresetno=$preset";
    #$self->sendCmd( $cmd );
}

sub presetSet
{
    my $self = shift;
    my $params = shift;
    my $preset = $self->getParam( $params, 'preset' );
    Debug( "Set Preset $preset" );
    my $cmd = "/admin/ptctl.cgi?position=" . ($preset - 1) . "&positionname=zm$preset";
    $self->sendCmd( $cmd );
}

sub presetGoto
{
    my $self = shift;
    my $params = shift;
    my $preset = $self->getParam( $params, 'preset' );
    Debug( "Goto Preset $preset" );
    my $cmd = "/admin/ptctl.cgi?move=p" . ($preset - 1);
    $self->sendCmd( $cmd );
}

sub presetHome
{
    my $self = shift;
    Debug( "Home Preset" );
    my $cmd = "/admin/ptctl.cgi?move=h";
    $self->sendCmd( $cmd );
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

ZoneMinder::Database - Perl extension for blah blah blah

=head1 SYNOPSIS

  use ZoneMinder::Database;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for ZoneMinder, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Philip Coombes, E<lt>philip.coombes@zoneminder.comE<gt>
Brian Rudy, E<lt>brudyNO@SPAMpraecogito.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Brian Rudy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
