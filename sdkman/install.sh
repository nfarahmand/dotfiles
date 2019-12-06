#!/bin/bash

[[ "$(uname -s)" == "Darwin" ]] || { echo "Not OSX.  Bye" && exit 0; }

[[ -e "${HOME}/.sdkman/bin/sdkman-init.sh" ]] &>/dev/null || curl -s "https://get.sdkman.io" | bash

