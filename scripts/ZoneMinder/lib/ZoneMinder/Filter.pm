# ==========================================================================
#
# ZoneMinder Filter Module, $Date$, $Revision$
# Copyright (C) 2001-2008  Philip Coombes
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
# This module contains the common definitions and functions used by the rest
# of the ZoneMinder scripts
#
package ZoneMinder::Filter;

use 5.006;
use strict;
use warnings;

require Exporter;
require ZoneMinder::Base;
require Date::Manip;

our @ISA = qw(Exporter ZoneMinder::Base);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration   use ZoneMinder ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = (
    'functions' => [ qw(
    ) ]
);
push( @{$EXPORT_TAGS{all}}, @{$EXPORT_TAGS{$_}} ) foreach keys %EXPORT_TAGS;

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = $ZoneMinder::Base::VERSION;

# ==========================================================================
#
# General Utility Functions
#
# ==========================================================================

use ZoneMinder::Config qw(:all);
use ZoneMinder::Logger qw(:all);
use ZoneMinder::Database qw(:all);

use POSIX;

sub new {
    my ( $parent, $id, $data ) = @_;

	my $self = {};
	bless $self, $parent;
    $$self{dbh} = $ZoneMinder::Database::dbh;
#zmDbConnect();
	if ( ( $$self{Id} = $id ) or $data ) {
#$log->debug("loading $parent $id") if $debug or DEBUG_ALL;
		$self->load( $data );
	}
	return $self;
} # end sub new

sub load {
	my ( $self, $data ) = @_;
	my $type = ref $self;
	if ( ! $data ) {
#$log->debug("Object::load Loading from db $type");
		$data = $$self{dbh}->selectrow_hashref( 'SELECT * FROM Filter WHERE Id=?', {}, $$self{Id} );
		if ( ! $data ) {
				Error( "Failure to load Filter record for $$self{Id}: Reason: " . $$self{dbh}->errstr );
		} else {
			Debug( 3, "Loaded Filter $$self{Id}" );	
		} # end if
	} # end if ! $data
	if ( $data and %$data ) {
		@$self{keys %$data} = values %$data;
	} # end if
} # end sub load

sub Name {
	if ( @_ > 1 ) {
		$_[0]{Name} = $_[1];
	}
	return $_[0]{Name};
} # end sub Path

sub find {
	shift if $_[0] eq 'ZoneMinder::Filter';
	my %sql_filters = @_;

	my $sql = 'SELECT * FROM Filters';
	my @sql_filters;
	my @sql_values;

    if ( exists $sql_filters{Name} ) {
        push @sql_filters , ' Name = ? ';
		push @sql_values, $sql_filters{Name};
    }

	$sql .= ' WHERE ' . join(' AND ', @sql_filters ) if @sql_filters;
	$sql .= ' LIMIT ' . $sql_filters{limit} if $sql_filters{limit};

	my $sth = $ZoneMinder::Database::dbh->prepare_cached( $sql )
        or Fatal( "Can't prepare '$sql': ".$ZoneMinder::Database::dbh->errstr() );
    my $res = $sth->execute( @sql_values )
            or Fatal( "Can't execute '$sql': ".$sth->errstr() );

	my @results;

	while( my $db_filter = $sth->fetchrow_hashref() ) {
		my $filter = new ZoneMinder::Filter( $$db_filter{Id}, $db_filter );
		push @results, $filter;
	} # end while
	return @results;
}

sub find_one {
	my @results = find(@_);
	return $results[0] if @results;
}

sub Execute {
	my $self = $_[0];

	my $sql = $self->Sql();

   if ( $self->{HasDiskPercent} )
    {
        my $disk_percent = getDiskPercent();
        $sql =~ s/zmDiskPercent/$disk_percent/g;
    }
    if ( $self->{HasDiskBlocks} )
    {
        my $disk_blocks = getDiskBlocks();
        $sql =~ s/zmDiskBlocks/$disk_blocks/g;
    }
    if ( $self->{HasSystemLoad} )
    {
        my $load = getLoad();
        $sql =~ s/zmSystemLoad/$load/g;
    }

    my $sth = $$self{dbh}->prepare_cached( $sql )
        or Fatal( "Can't prepare '$sql': ".$$self{dbh}->errstr() );
    my $res = $sth->execute();
    if ( !$res )
    {
        Error( "Can't execute filter '$sql', ignoring: ".$sth->errstr() );
        return;
    }
	my @results;

    while( my $event = $sth->fetchrow_hashref() ) {
		push @results, $event;
	}
	$sth->finish();
	return @results;
}

sub Sql {
	my $self = $_[0];
	if ( ! $$self{Sql} ) {
		my $filter_expr = ZoneMinder::General::jsonDecode( $self->{Query} );
        my $sql = "SELECT E.Id,
                          E.MonitorId,
                          M.Name as MonitorName,
                          M.DefaultRate,
                          M.DefaultScale,
                          E.Name,
                          E.Cause,
                          E.Notes,
                          E.StartTime,
                          unix_timestamp(E.StartTime) as Time,
                          E.Length,
                          E.Frames,
                          E.AlarmFrames,
                          E.TotScore,
                          E.AvgScore,
                          E.MaxScore,
                          E.Archived,
                          E.Videoed,
                          E.Uploaded,
                          E.Emailed,
                          E.Messaged,
                          E.Executed
                   FROM Events as E
                   INNER JOIN Monitors as M on M.Id = E.MonitorId
        ";
        $self->{Sql} = '';

        if ( $filter_expr->{terms} ) {
            for ( my $i = 0; $i < @{$filter_expr->{terms}}; $i++ ) {
                if ( exists($filter_expr->{terms}[$i]->{cnj}) ) {
                    $self->{Sql} .= " ".$filter_expr->{terms}[$i]->{cnj}." ";
                }
                if ( exists($filter_expr->{terms}[$i]->{obr}) ) {
                    $self->{Sql} .= " ".str_repeat( "(", $filter_expr->{terms}[$i]->{obr} )." ";
                }
                my $value = $filter_expr->{terms}[$i]->{val};
                my @value_list;
                if ( $filter_expr->{terms}[$i]->{attr} ) {
                    if ( $filter_expr->{terms}[$i]->{attr} =~ /^Monitor/ ) {
                        my ( $temp_attr_name ) = $filter_expr->{terms}[$i]->{attr} =~ /^Monitor(.+)$/;
                        $self->{Sql} .= "M.".$temp_attr_name;
                    } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'DateTime' ) {
                        $self->{Sql} .= "E.StartTime";
                    } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'Date' ) {
                        $self->{Sql} .= "to_days( E.StartTime )";
                    } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'Time' ) {
                        $self->{Sql} .= "extract( hour_second from E.StartTime )";
                    } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'Weekday' ) {
                        $self->{Sql} .= "weekday( E.StartTime )";
                    } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'DiskPercent' ) {
                        $self->{Sql} .= "zmDiskPercent";
                        $self->{HasDiskPercent} = !undef;
                    } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'DiskBlocks' ) {
                        $self->{Sql} .= "zmDiskBlocks";
                        $self->{HasDiskBlocks} = !undef;
                    } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'SystemLoad' ) {
                        $self->{Sql} .= "zmSystemLoad";
                        $self->{HasSystemLoad} = !undef;
                    } else {
                        $self->{Sql} .= "E.".$filter_expr->{terms}[$i]->{attr};
                    }

                    ( my $stripped_value = $value ) =~ s/^["\']+?(.+)["\']+?$/$1/;
                    foreach my $temp_value ( split( /["'\s]*?,["'\s]*?/, $stripped_value ) ) {
                        if ( $filter_expr->{terms}[$i]->{attr} =~ /^Monitor/ ) {
                            $value = "'$temp_value'";
                        } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'Name'
                                || $filter_expr->{terms}[$i]->{attr} eq 'Cause'
                                || $filter_expr->{terms}[$i]->{attr} eq 'Notes'
                        ) {
                            $value = "'$temp_value'";
                        } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'DateTime' ) {
                            $value = DateTimeToSQL( $temp_value );
                            if ( !$value ) {
                                Error( "Error parsing date/time '$temp_value', "
                                      ."skipping filter '$self->{Name}'\n" );
                                return;
                            }
                            $value = "'$value'";
                        } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'Date' ) {
                            $value = DateTimeToSQL( $temp_value );
                            if ( !$value ) {
                                Error( "Error parsing date/time '$temp_value', "
                                      ."skipping filter '$self->{Name}'\n" );
                                return;
                            }
                            $value = "to_days( '$value' )";
                        } elsif ( $filter_expr->{terms}[$i]->{attr} eq 'Time' ) {
                            $value = DateTimeToSQL( $temp_value );
                            if ( !$value ) {
                                Error( "Error parsing date/time '$temp_value', "
                                      ."skipping filter '$self->{Name}'\n" );
                                return;
                            }
                            $value = "extract( hour_second from '$value' )";
                        } else {
                            $value = $temp_value;
                        }
                        push( @value_list, $value );
                    } # end foreach temp_value
                } # end if has an attr
                if ( $filter_expr->{terms}[$i]->{op} ) {
                    if ( $filter_expr->{terms}[$i]->{op} eq '=~' ) {
                        $self->{Sql} .= " regexp $value";
                    } elsif ( $filter_expr->{terms}[$i]->{op} eq '!~' ) {
                        $self->{Sql} .= " not regexp $value";
                    } elsif ( $filter_expr->{terms}[$i]->{op} eq '=[]' ) {
                        $self->{Sql} .= " in (".join( ",", @value_list ).")";
                    } elsif ( $filter_expr->{terms}[$i]->{op} eq '!~' ) {
                        $self->{Sql} .= " not in (".join( ",", @value_list ).")";
                    } else {
                        $self->{Sql} .= " ".$filter_expr->{terms}[$i]->{op}." $value";
                    }
                } # end if has an operator
                if ( exists($filter_expr->{terms}[$i]->{cbr}) ) {
                    $self->{Sql} .= " ".str_repeat( ")", $filter_expr->{terms}[$i]->{cbr} )." ";
                }
            } # end foreach term
        } # end if terms

        if ( $self->{Sql} )
        {
            if ( $self->{AutoMessage} )
            {
                # Include all events, including events that are still ongoing
                # and have no EndTime yet
                $sql .= " and ( ".$self->{Sql}." )";
            }
            else
            {
                # Only include closed events (events with valid EndTime)
                $sql .= " where not isnull(E.EndTime) and ( ".$self->{Sql}." )";
            }
        }
        my @auto_terms;
        if ( $self->{AutoArchive} )
        {
            push( @auto_terms, "E.Archived = 0" )
        }
        if ( $self->{AutoVideo} )
        {
            push( @auto_terms, "E.Videoed = 0" )
        }
        if ( $self->{AutoUpload} )
        {
            push( @auto_terms, "E.Uploaded = 0" )
        }
        if ( $self->{AutoEmail} )
        {
            push( @auto_terms, "E.Emailed = 0" )
        }
        if ( $self->{AutoMessage} )
        {
            push( @auto_terms, "E.Messaged = 0" )
        }
        if ( $self->{AutoExecute} )
        {
            push( @auto_terms, "E.Executed = 0" )
        }
        if ( @auto_terms )
        {
            $sql .= " and ( ".join( " or ", @auto_terms )." )";
        }
        if ( !$filter_expr->{sort_field} )
        {
            $filter_expr->{sort_field} = 'StartTime';
            $filter_expr->{sort_asc} = 0;
        }
        my $sort_column = '';
        if ( $filter_expr->{sort_field} eq 'Id' )
        {
            $sort_column = "E.Id";
        }
        elsif ( $filter_expr->{sort_field} eq 'MonitorName' )
        {
            $sort_column = "M.Name";
        }
        elsif ( $filter_expr->{sort_field} eq 'Name' )
        {
            $sort_column = "E.Name";
        }
        elsif ( $filter_expr->{sort_field} eq 'StartTime' )
        {
            $sort_column = "E.StartTime";
        }
        elsif ( $filter_expr->{sort_field} eq 'Secs' )
        {
            $sort_column = "E.Length";
        }
        elsif ( $filter_expr->{sort_field} eq 'Frames' )
        {
            $sort_column = "E.Frames";
        }
        elsif ( $filter_expr->{sort_field} eq 'AlarmFrames' )
        {
            $sort_column = "E.AlarmFrames";
        }
        elsif ( $filter_expr->{sort_field} eq 'TotScore' )
        {
            $sort_column = "E.TotScore";
        }
        elsif ( $filter_expr->{sort_field} eq 'AvgScore' )
        {
            $sort_column = "E.AvgScore";
        }
        elsif ( $filter_expr->{sort_field} eq 'MaxScore' )
        {
            $sort_column = "E.MaxScore";
        }
        else
        {
            $sort_column = "E.StartTime";
        }
        my $sort_order = $filter_expr->{sort_asc}?"asc":"desc";
        $sql .= " order by ".$sort_column." ".$sort_order;
        if ( $filter_expr->{limit} )
        {
            $sql .= " limit 0,".$filter_expr->{limit};
        }
        Debug( "SQL:$sql\n" );
        $self->{Sql} = $sql;
	} # end if has Sql
	return $self->{Sql};
} # end sub Sql

sub getDiskPercent
{
    my $command = "df .";
    my $df = qx( $command );
    my $space = -1;
    if ( $df =~ /\s(\d+)%/ms )
    {
        $space = $1;
    }
    return( $space );
}
sub getDiskBlocks
{
    my $command = "df .";
    my $df = qx( $command );
    my $space = -1;
    if ( $df =~ /\s(\d+)\s+\d+\s+\d+%/ms )
    {
        $space = $1;
    }
    return( $space );
}
sub getLoad
{
    my $command = "uptime .";
    my $uptime = qx( $command );
    my $load = -1;
    if ( $uptime =~ /load average:\s+([\d.]+)/ms )
    {
        $load = $1;
        Info( "Load: $load" );
    }
    return( $load );
}

#
# More or less replicates the equivalent PHP function
#
sub strtotime
{
    my $dt_str = shift;
    return( Date::Manip::UnixDate( $dt_str, '%s' ) );
}

#
# More or less replicates the equivalent PHP function
#
sub str_repeat
{
    my $string = shift;
    my $count = shift;
    return( ${string}x${count} );
}

# Formats a date into MySQL format
sub DateTimeToSQL
{
    my $dt_str = shift;
    my $dt_val = strtotime( $dt_str );
    if ( !$dt_val )
    {
        Error( "Unable to parse date string '$dt_str'\n" );
        return( undef );
    }
    return( strftime( "%Y-%m-%d %H:%M:%S", localtime( $dt_val ) ) );
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

ZoneMinder::Database - Perl extension for blah blah blah

=head1 SYNOPSIS

  use ZoneMinder::Filter;
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

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2001-2008  Philip Coombes

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
