#!/bin/bash
# This file defines the FW git repos and where they belong to in the tree.
# It gets sourced into different other scripts.

# the locations of the git repos
# columns separated by '#':
# 1. git repo name
# 2. (sub-)directory where git repo will end up on local machine
# 3. Platform: Windows, Linux, or empty (all platforms)
# 4. base URL of git repo (without trailing slash). Full name will be $URL/$REPONAME.git
locations="
fwmeta#.##git://github.com/sillsdev
FieldWorks#fw##git://github.com/sillsdev
FwMovies#fw/DistFiles/Language Explorer/Movies##git://github.com/sillsdev
FwSampleProjects#fw/DistFiles/ReleaseData##git://github.com/sillsdev
FwDocumentation#FwDocumentation##git://github.com/sillsdev
FwHelps#fw/DistFiles/Helps##git://github.com/sillsdev
FwDebian#fw/debian#Linux#git://github.com/sillsdev
FwInstaller#fw/Installer#Windows#git://github.com/sillsdev
FwLocalizations#fw/Localizations##git://github.com/sillsdev
FwSupportTools#FwSupportTools##git://github.com/sillsdev
WorldPad#WorldPad##git://github.com/sillsdev
mono#mono/mono#Linux#git://github.com/sillsdev
mono-basic#mono/mono-basic#Linux#git://github.com/sillsdev
gtk-sharp#mono/gtk-sharp#Linux#git://github.com/sillsdev
libgdiplus#mono/libgdiplus#Linux#git://github.com/sillsdev
libcom#libcom#Linux#git://github.com/sillsdev
test#test##git://github.com/sillsdev"
