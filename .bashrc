# .bashrc must NOT output anything

[[ -e ~/.private ]] && source /dev/stdin <<<"$(cat ~/.private/*rc 2>/dev/null)";

# [[ "$(uname -s)" == "Darwin" ]] && alias ls='ls -laFG' || alias ls='ls -laF --color'
[[ -e "/Applications/iTunes.app" ]] && alias ls='ls -laFG' || alias ls='ls -laF --color'
[[ -e "/usr/local/bin/exa" ]] && alias ls='exa -laF'
alias nonascii='pcregrep --color=auto -n "[\x80-\xFF]"'
alias git='hub'
alias grep='ggrep --color=auto'
alias sed='gsed'
alias awk='gawk'
alias elasticsearch='elasticsearch -Enetwork.host=0.0.0.0'
alias cerebro='docker run -d --rm $([[ -e ${HOME}/.cerebro/application.conf ]] && echo "-v ${HOME}/.cerebro/application.conf:/opt/cerebro/conf/application.conf") --name cerebro -it -p9000:9000 yannart/cerebro; until [[ $(curl -o /dev/null -sw "%{http_code}" http://localhost:9000/) == "200" ]]; do; sleep 0.1; done; open http://localhost:9000; docker attach cerebro'
function diff { [[ $# -ge 2 ]] && fleft="$(realpath ${1})" && fright="$(realpath ${2})" && subl --command "sublimerge_compare_paths {\"paths\": [\"${fleft}\", \"${fright}\"]}"; }
alias dockerps='docker ps --format "{{json .}}" | jq';
alias dockerpsa='docker ps -a --format "{{json .}}" | jq';
alias dockerimages='docker images --format "{{json .}}" | jq';
function dockerinspect { image="$1"; shift; docker inspect $image --format "{{json .}}" | jq $@; }
alias jwt='/usr/local/bin/jwt';
alias sha256='openssl dgst -sha256';
alias scalaenvinit='eval "$(scalaenv init -)" && eval "$(sbtenv init -)"';
alias goenvinit='eval "$(goenv init -)"';
alias rbenvinit='eval "$(rbenv init -)"';

# Only if this is a login shell
if [[ $- = *i* ]]
then
    # [[ -e ~/.liquidprompt/liquidprompt ]] && source ~/.liquidprompt/liquidprompt
    [[ -e /usr/local/bin/starship ]] && eval "$(starship init ${SHELL})";
    [[ -e ~/.git-completion ]] && source ~/.git-completion 2>/dev/null;
    which pyenv &>/dev/null && eval "$(pyenv init - --no-rehash)";
    which pyenv-virtualenv-init &>/dev/null && eval "$(pyenv virtualenv-init - --no-rehash)";
    which nodenv &>/dev/null && eval "$(nodenv init - --no-rehash)";
    which jenv &>/dev/null && eval "$(jenv init - --no-rehash)";
    # which rbenv &>/dev/null && eval "$(rbenv init - --no-rehash)";
    # which goenv &>/dev/null && eval "$(goenv init - --no-rehash)";
    # which scalaenv &>/dev/null && eval "$(scalaenv init - --no-rehash)";
    # which sbtenv &>/dev/null && eval "$(sbtenv init - --no-rehash)";
fi
