# .bashrc must NOT output anything

[[ -e ~/.private ]] && for rcfile in ~/.private/*rc; do . "${rcfile}" &>/dev/null; done;

# [[ "$(uname -s)" == "Darwin" ]] && alias ls='ls -laFG' || alias ls='ls -laF --color'
[[ -e "/Applications/iTunes.app" ]] && alias ls='ls -laFG' || alias ls='ls -laF --color'
alias nonascii='pcregrep --color=auto -n "[\x80-\xFF]"'
alias git='hub'
alias grep='ggrep --color=auto'
alias sed='gsed'
alias awk='gawk'
alias elasticsearch='elasticsearch -Enetwork.host=0.0.0.0'
alias cerebro='docker run --rm --name cerebro -it -p9000:9000 yannart/cerebro'
alias dockerps='docker ps --format "{{json .}}" | jq';
alias dockerpsa='docker ps -a --format "{{json .}}" | jq';
alias dockerimages='docker images --format "{{json .}}" | jq';
function dockerinspect { image="$1"; shift; docker inspect $image --format "{{json .}}" | jq $@; }
alias jwt='/usr/local/bin/jwt';
alias scalaenvinit='eval "$(scalaenv init -)" && eval "$(sbtenv init -)"';
alias goenvinit='eval "$(goenv init -)"';
alias rbenvinit='eval "$(rbenv init -)"';

# Only if this is a login shell
if [[ $- = *i* ]]
then
    [[ -e ~/.liquidprompt/liquidprompt ]] && source ~/.liquidprompt/liquidprompt
    [[ -e ~/.git-completion ]] && source ~/.git-completion
    which pyenv &>/dev/null && eval "$(pyenv init - --no-rehash)";
    which pyenv-virtualenv-init &>/dev/null && eval "$(pyenv virtualenv-init - --no-rehash)";
    which nodenv &>/dev/null && eval "$(nodenv init - --no-rehash)";
    which jenv &>/dev/null && eval "$(jenv init - --no-rehash)";
    # which rbenv &>/dev/null && eval "$(rbenv init - --no-rehash)";
    # which goenv &>/dev/null && eval "$(goenv init - --no-rehash)";
    # which scalaenv &>/dev/null && eval "$(scalaenv init - --no-rehash)";
    # which sbtenv &>/dev/null && eval "$(sbtenv init - --no-rehash)";
fi
