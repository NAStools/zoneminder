<?php
require_once( 'database.php' );
require_once( 'Event.php' );

class Frame {
  public function __construct( $IdOrRow ) {
    $row = NULL;
    if ( $IdOrRow ) {
      if ( is_integer( $IdOrRow ) or is_numeric( $IdOrRow ) ) {
        $row = dbFetchOne( 'SELECT * FROM Frames WHERE Id=?', NULL, array( $IdOrRow ) );
        if ( ! $row ) {
          Error("Unable to load Frame record for Id=" . $IdOrRow );
        }
      } elseif ( is_array( $IdOrRow ) ) {
        $row = $IdOrRow;
      } else {
        Error("Unknown argument passed to Frame Constructor ($IdOrRow)");
        return;
      }
    } # end if isset($IdOrRow)

    if ( $row ) {
      foreach ($row as $k => $v) {
        $this->{$k} = $v;
      }
    } else {
      Error("No row for Frame " . $IdOrRow );
    }
  } // end function __construct
  public function Storage() {
    return $this->Event()->Storage();
  }
  public function Event() {
    return new Event( $this->{'EventId'} );
  }
  public function __call( $fn, array $args){
    if(isset($this->{$fn})){
      return $this->{$fn};
#array_unshift($args, $this);
#call_user_func_array( $this->{$fn}, $args);
    }
  }

  public function Path() {
    $Storage = $this->Storage();
    return $Storage->Path().'/'.$this->Relative_Path();
  }
  public function Relative_Path() {
    $event_path = "";

    if ( ZM_USE_DEEP_STORAGE )
    {
      $event_path = 
        $this->{'MonitorId'}
      .'/'.strftime( "%y/%m/%d/%H/%M/%S",
          $this->Time()
          )
        ;
    }
    else
    {
      $event_path = 
        $this->{'MonitorId'}
      .'/'.$this->{'Id'}
      ;
    }

    return( $event_path );

  }

  public function getImageSrc( ) {
    return $_SERVER['PHP_SELF'].'?view=image&fid='.$this->{'Id'};
  } // end function getImageSrc

	public static function find( $parameters = array(), $limit = NULL ) {
		$sql = 'SELECT * FROM Frames';
		$values = array();
		if ( sizeof($parameters) ) {
			$sql .= ' WHERE ' . implode( ' AND ', array_map( 
				function($v){ return $v.'=?'; }, 
				array_keys( $parameters ) 
				) );
			$values = array_values( $parameters );
		}
		if ( $limit ) {
			$sql .= ' LIMIT ' . $limit;
		}
		$results = dbFetchAll( $sql, NULL, $values );
		if ( $results ) {
		  return array_map( function($id){ return new Frame($id); }, $results );
		}
	}

	public static function find_one( $parameters = array() ) {
	  $results = Frame::find( $parameters, 1 );
	  if ( ! sizeof( $results ) ) {
		  return;
	  }
	  return $results[0];
	}
} # end class
?>
