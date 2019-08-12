#!/bin/bash

TIME="$(date +%Y%m%d%H%M%S)";
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLEANUPFILE="${1}";
[[ -z $CLEANUPFILE ]] && CLEANUPFILE="/dev/null";

pushd "${BASEDIR}";

# set -x

find . -name '.*' -maxdepth 1 -mindepth 1 | egrep -ve '.DS_Store|.gitignore|.git$' | awk -F'/' '{print $2}' | while read dotfile
do
	[[ -e "${HOME}/${dotfile}" ]] && mv "${HOME}/${dotfile}" "${HOME}/${dotfile}.dotfilebak.${TIME}" && echo "${HOME}/${dotfile}.dotfilebak.${TIME}" >> "${CLEANUPFILE}";
	echo -e "Linking ${HOME}/${dotfile} -> ${BASEDIR}/${dotfile}";
	ln -sf "${BASEDIR}/${dotfile}" "${HOME}/${dotfile}";
done
