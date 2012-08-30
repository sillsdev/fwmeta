#!/bin/sh
# This file defines the FW git repos and where they belong to in the tree.
# It gets sourced into different other scripts.

# the locations of the git repos
declare -A locations=(
	[fwmeta]=.
	[FieldWorks]=fw
	[FwMovies]="fw/DistFiles/Language Explorer/Movies"
	[FwSampleProjects]="fw/DistFiles/ReleaseData"
	[FwDocumentation]="fw/Doc"
	[FwHelps]="fw/DistFiles/Helps"
	[FwDebian]="fw/debian"
	[FwInstaller]="fw/Installer"
	[FwSupportTools]="fw/SupportTools"
	[WorldPad]="WorldPad"
	[mono]=mono/mono
	[mono-basic]=mono/mono-basic
	[gtk-sharp]=mono/gtk-sharp
	[libgdiplus]=mono/libgdiplus
	[test]=test
)
