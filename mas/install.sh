#!/bin/bash

[[ "$(uname -s)" == "Darwin" ]] || { echo "Not OSX.  Bye" && exit 0; }

which brew &>/dev/null || { echo "Install homebrew first." && exit 1; }
which mas &>/dev/null || brew install mas;

# read -p "App Store Email: " email;
# mas signin "${email}";

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mas install $(cat ${BASEDIR}/packages.txt | awk '{print $1}');

