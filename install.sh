#!/bin/bash

git submodule init && git submodule update;

TIME="$(date +%Y%m%d%H%M%S)";
BASEDIRS=( "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" "$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../privatedotfiles && pwd )" );

CLEANUPFILE="$(mktemp)";

# ensure brew runs first
echo "${BASEDIRS[0]}/brew/install.sh ${CLEANUPFILE}";
"${BASEDIRS[0]}/brew/install.sh" "${CLEANUPFILE}";

for BASEDIR in ${BASEDIRS[@]};
do
    find "${BASEDIR}" -name '.*' -maxdepth 1 -mindepth 1 | egrep -ve '.DS_Store|.gitignore|.git$' | awk -F'/' '{print $NF}' | while read dotfile
    do
        [[ -e "${HOME}/${dotfile}" ]] && mv "${HOME}/${dotfile}" "${HOME}/${dotfile}.dotfilebak.${TIME}" && echo "${HOME}/${dotfile}.dotfilebak.${TIME}" >> "${CLEANUPFILE}";
        echo -e "Linking ${HOME}/${dotfile} -> ${BASEDIR}/${dotfile}";
        ln -sf "${BASEDIR}/${dotfile}" "${HOME}/${dotfile}";
    done

    find "${BASEDIR}" -name install.sh -maxdepth 2 -mindepth 2 | grep -v brew/install.sh | while read INSTALLSCRIPT;
    do
        echo "${INSTALLSCRIPT} ${CLEANUPFILE}";
        "${INSTALLSCRIPT}" "${CLEANUPFILE}";
    done
done

echo "Setting up iTerm2 defaults..."

defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string ${HOME}/.iterm
defaults write com.googlecode.iterm2.plist SUEnableAutomaticChecks -bool false
defaults read com.googlecode.iterm2.plist >/dev/null
defaults read -app iTerm >/dev/null

# Prevent iTunes from hijacking the play key, but only if not on High Sierra
which launchctl &>/dev/null && defaults read loginwindow SystemVersionStampAsString | egrep "10.1(3|4)" &>/dev/null || launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

# Prevent Cisco AnyConnect from launching at startup
[[ -e /Library/LaunchAgents/com.cisco.anyconnect.gui.plist ]] &>/dev/null && launchctl unload -w /Library/LaunchAgents/com.cisco.anyconnect.gui.plist

# PIA Installer
if [[ ! -e "/Applications/Private Internet Access.app" ]]
then
    find /usr/local/Caskroom/private-internet-access -name "Private Internet Access Installer.app" | sort -n | tail -1 | while read line; do open "${line}"; done;
fi

if [[ -s "${CLEANUPFILE}" ]]
then
	read -p "Would you like to clean up backed up files? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
    	cat "${CLEANUPFILE}" | sed -E s/dotfilebak.+/dotfilebak/g | while read line
    	do
    		echo -e "Removing ${line}.*";
    		rm "${line}".*;
    	done
    fi
fi

