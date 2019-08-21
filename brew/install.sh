#!/bin/bash

[[ "$(uname -s)" == "Darwin" ]] || { echo "Not OSX.  Bye" && exit 0; }

which brew &>/dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while read tap
do
	brew tap "${tap}";
done < ${BASEDIR}/taps.txt

while read cask
do
    brew cask install "${cask}";
done < ${BASEDIR}/casks.txt

while read package
do
    brew install "${package}";
done < ${BASEDIR}/packages.txt

# only install mas on high sierra
defaults read loginwindow SystemVersionStampAsString | grep "10.13" &>/dev/null && brew install mas;

# Sonos for some reason isn't installable without using brew cask
# brew cask install sonos;

# Sublime convenience script
ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "/usr/local/bin/subl";

# Little Snitch
if [[ ! -e "/Applications/Little Snitch Configuration.app" ]]
then
	LITTLESNITCH_VERSION="$(/bin/ls -1 /usr/local/Caskroom/little-snitch/ | sort | tail -1)";
	LITTLESNITCH_INSTALLER="/usr/local/Caskroom/little-snitch/${LITTLESNITCH_VERSION}/LittleSnitch-${LITTLESNITCH_VERSION}.dmg";
	open "${LITTLESNITCH_INSTALLER}";
fi

# Configure homebrew permissions to allow multiple users on MAC OSX.
# Any user from the admin group will be able to manage the homebrew and cask installation on the machine.
for brewdir in "/usr/local/Cellar" "/usr/local/Caskroom" "/Library/Caches/Homebrew"
do
	sudo mkdir -p "${brewdir}" &>/dev/null;
	sudo chgrp -R admin "${brewdir}";
	sudo chmod -R g+w "${brewdir}";
done
