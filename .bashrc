# .bashrc must NOT output anything

[[ -e ~/.private ]] && source /dev/stdin <<<"$(cat ~/.private/*rc 2>/dev/null)";

# [[ "$(uname -s)" == "Darwin" ]] && alias ls='ls -laFG' || alias ls='ls -laF --color'
[[ -e "/Applications/iTunes.app" ]] && alias ls='ls -laFG' || alias ls='ls -laF --color'
[[ -e "/usr/local/bin/exa" ]] && alias ls='exa -laF'

function urlWaitSpin {
    url="${1}";
    expectedStatus="${2:-200}";
    openUrl="${3:-false}";
    timeout=300;
    sp="⣾⣽⣻⢿⡿⣟⣯⣷";
    i=0;
    until [[ $(curl -o /dev/null -sw "%{http_code}" "${url}") == "${expectedStatus}" && ${timeout} -gt 0 ]]
    do
        [[ "${BASH_VERSION}" != "" ]] && printf "\b${sp:i++%${#sp}:1}"
        if [[ "${ZSH_VERSION}" != "" ]]
        then
            ((i%=${#sp}));
            ((i+=1));
            printf "\b${${(@z)sp}[$i]//\"}"
        fi
        sleep .1
        ((timeout-=1))
        [[ ${timeout} -le 0 ]] && printf "\b \b" && return 1;
    done
    printf "\b \b";
    [[ "${openUrl}" == "true" ]] && open "${url}";
    return 0;

}

alias nonascii='pcregrep --color=auto -n "[\x80-\xFF]"'
alias git='hub'
alias grep='ggrep --color=auto'
alias sed='gsed'
alias awk='gawk'
alias elasticsearch='elasticsearch -Enetwork.host=0.0.0.0'
alias cerebro='docker run -d --rm $([[ -e ${HOME}/.cerebro/application.conf ]] && echo "-v ${HOME}/.cerebro/application.conf:/opt/cerebro/conf/application.conf") --name cerebro -it -p9000:9000 yannart/cerebro && urlWaitSpin http://localhost:9000 200 true && docker attach cerebro';
alias swagger='docker run -d --rm --name swagger -it -p8888:8080 swaggerapi/swagger-editor && urlWaitSpin http://localhost:8888 200 true && docker attach swagger';
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
