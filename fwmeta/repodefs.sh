#!/bin/bash
# This file defines the FW git repos and where they belong to in the tree.
# It gets sourced into different other scripts.

# the locations of the git repos
locations="
FieldWorks:fw:
FwMovies:fw/DistFiles/Language Explorer/Movies:
FwSampleProjects:fw/DistFiles/ReleaseData:
FwDocumentation:fw/Doc:
FwHelps:fw/DistFiles/Helps:
FwDebian:fw/debian:Linux
FwInstaller:fw/Installer:Windows
FwSupportTools:fw/SupportTools:
WorldPad:WorldPad:
mono:mono/mono:Linux
mono-basic:mono/mono-basic:Linux
gtk-sharp:mono/gtk-sharp:Linux
libgdiplus:mono/libgdiplus:Linux
test:test:"
