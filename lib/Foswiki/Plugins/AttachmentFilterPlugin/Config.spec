# ---+ Extensions
# ---++ AttachmentFilterPlugin

# General Settings for the AttachmentFilterPlugin

# **SELECT block,allow**
# Please set the behaviour of the AttachmentFilterPlugin. Default behaviour is blocking the underlying FiletypeFilter list.
$Foswiki::cfg{Plugins}{AttachmentFilterPlugin}{Behaviour}="block";

# **STRING**
# Comma separated list of filetypes to be blocked or allowed to upload. 
$Foswiki::cfg{Plugins}{AttachmentFilterPlugin}{FiletypeFilter}="bmp";