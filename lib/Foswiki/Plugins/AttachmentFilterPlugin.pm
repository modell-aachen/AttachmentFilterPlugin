# This script Copyright (c) 2008 Impressive.media
# and distributed under the GPL (see below)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::AttachmentFilterPlugin;

use strict;

use Foswiki::OopsException;
use File::MMagic;
use vars
  qw( $VERSION $RELEASE $SHORTDESCRIPTION $debug $pluginName $NO_PREFS_IN_TOPIC );

our $VERSION           = '$Rev$';
our $RELEASE           = '1.0';
our $SHORTDESCRIPTION  = 'Preventing Uploads with blocked mime types';
our $NO_PREFS_IN_TOPIC = 1;

$SHORTDESCRIPTION =
'This plugin filters attachment by their content type and allows to block specific attachments';
$NO_PREFS_IN_TOPIC = 1;

$pluginName = 'AttachmentFilterPlugin';

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 1.026 ) {
        Foswiki::Func::writeWarning(
            "Version mismatch between $pluginName and Plugins.pm");
        return 0;
    }
    return 1;
}

sub beforeUploadHandler {

    my ( $attrs, $meta ) = @_;
    
    my $magic      = new File::MMagic;    # use internal magic file
	my $fh = $attrs->{stream};
	my $mime_type = $magic->checktype_filehandle($fh)
	
	# Modac : Muss ich hier den Handle schließen oder Ähnliches tun?

    # Modac : Logik sowohl für Allowed als auch denied erstellen
    my $allowedTypes =
      $Foswiki::cfg{Plugins}{AttachmentFilterPlugin}{AllowedFiletypes} || '';
      
    my $blockedTypes = 
      $Foswiki::cfg{Plugins}{AttachmentFilterPlugin}{BlockedFiletypes} || '';

    if ( $blockedTypes =~ m/$fileType/  ) {
        
        # Modac : Hier muss eine durch den CKEditor lesbare Response kommen! JSON ?
    	# forbidden filetype
        throw Foswiki::OopsException(
            'attention',
            def    => "generic",
            web    => $web,
            topic  => $topic,
            keep   => 1,
            params => [
                    'You cannot upload this attachment: '
                  . $attribs->{'attachment'}
                  . ". The type($fileType) is forbidden, please ask your administrator for further informations"
            ]
        );
    }
    
    elsif  ( !( $allowedTypes =~ m/$fileType/ ) || $allowedTypes == '' ) {
    	
    	# Modac : Hier muss eine durch den CKEditor lesbare Response kommen! JSON ?
    	# forbidden filetype
        throw Foswiki::OopsException(
            'attention',
            def    => "generic",
            web    => $web,
            topic  => $topic,
            keep   => 1,
            params => [
                    'You cannot upload this attachment: '
                  . $attribs->{'attachment'}
                  . ". The type($fileType) is forbidden, please ask your administrator for further informations"
            ]
        );
    	
    }
    else {   
    	
    	# everything is ok 
    	
    }
}

1;
