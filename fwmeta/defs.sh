GERRIT="gerrit.lsdev.sil.org"
GERRITPORT=59418
GERRITGROUP="FW Release Manager"
FWMETAREPO=fwmeta
TOOLSDIR=fwmeta

gerritusername=$(git config --get fwinit.gerrituser || true)
origin=$(git config --get gitflow.origin || echo origin)
master=$(git config --get gitflow.branch.master || echo master)
develop=$(git config --get gitflow.branch.develop || echo develop)
