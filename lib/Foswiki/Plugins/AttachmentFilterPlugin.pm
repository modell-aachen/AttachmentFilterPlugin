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
 

$VERSION           = '$Rev$';
$RELEASE           = '1.0.2';
$SHORTDESCRIPTION =
'This plugin filters attachment by their content type and allows to block specific attachments';
$NO_PREFS_IN_TOPIC = 1;

# Modac : CodeReview : Brauchen wir das noch?
$pluginName = 'AttachmentFilterPlugin';

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

# Modac : CodeReview : Brauchen wir das noch?
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
	my $mime_type = $magic->checktype_filehandle($fh);
	my $web = $meta->web;
	my $topic = $meta->topic;
	
	# Modac : Testausgabe
	# print STDERR $mime_type;
	
	# Modac : Muss ich den Handle schließen oder Ähnliches tun?

    # Modac : Filter Behaviour (block, allow)
    my $type = $Foswiki::cfg{Plugins}{AttachmentFilterPlugin}{Behaviour} || 'block';
    
    # Modac : Allow ohne Filter blockiert alles, Block ohne Filter lässt alles passieren
    my $fileTypes =
      $Foswiki::cfg{Plugins}{AttachmentFilterPlugin}{FiletypeFilter} || '';
    $fileTypes = join('|', map { ("$_\$", "^$_\$") } split(/,/, $fileTypes));
    $fileTypes = '//' if $fileTypes eq '';
    
    # print STDERR $fileTypes;
    if ( ($mime_type =~ m/$fileTypes/ && $type eq 'block') || ($mime_type !~ m/$fileTypes/ && $type eq 'allow') ) {
        
    	# forbidden filetype
    	# Modac : ToDo : Ausgabe für den CKEditor!
        throw Foswiki::OopsException(
            'attention',
            def    => "generic",
            web    => $web,
            topic  => $topic,
            keep   => 1,
            params => [
                    'You cannot upload this attachment: '
                  . $attrs->{'attachment'}
                  . ". The type($mime_type) is forbidden, please ask your administrator for further informations"
            ]
        );
    }
}

1;
