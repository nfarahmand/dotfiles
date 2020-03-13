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

function getFreePort {
    local port="";
    until [[ "${port}" != "" ]]
    do
        port="$(jot -r 1 1024 65535)"
        netstat -an | grep tcp4 | grep LISTEN | awk '{print $4}' | awk -F"." '{print $NF}' | /usr/bin/grep -e "^${port}$" &>/dev/null;
        [[ $? -eq 0 ]] && port="";
    done
    echo ${port};
}

alias nonascii='pcregrep --color=auto -n "[\x80-\xFF]"'
alias git='hub'
alias grep='ggrep --color=auto'
alias sed='gsed'
alias awk='gawk'
alias elasticsearch='elasticsearch -Enetwork.host=0.0.0.0'
alias cerebro='docker run -d --rm $([[ -e ${HOME}/.cerebro/application.conf ]] && echo "-v ${HOME}/.cerebro/application.conf:/opt/cerebro/conf/application.conf") --name cerebro -it -p9000:9000 yannart/cerebro && urlWaitSpin http://localhost:9000 200 true && docker attach cerebro';
alias swagger='docker run -d --rm --name swagger -it -p8889:8080 swaggerapi/swagger-editor && urlWaitSpin http://localhost:8889 200 true && docker attach swagger';
alias openapi='docker run -d --rm --name openapi -it -p3000:3000 mermade/openapi-gui && urlWaitSpin http://localhost:3000 200 true && docker attach openapi';
alias es='docker run -d --rm --name elasticsearch -it -p9200:9200 -p9300:9300 -v /usr/share/elasticsearch/data elasticsearch:6.8.1 && urlWaitSpin http://localhost:9200 200 true && docker attach elasticsearch';
alias ff='docker run -d --rm --name=firefox -p5800:5800 -v "${HOME}/.firefox-container":/config --shm-size 2g jlesage/firefox && urlWaitSpin http://localhost:5800 200 true && docker attach firefox';
alias ubuntu='PORT="$(getFreePort)" && docker run -d --rm --name=ubuntu -p${PORT}:80 --shm-size 2g dorowu/ubuntu-desktop-lxde-vnc:bionic && urlWaitSpin http://localhost:${PORT} 200 true && docker attach ubuntu';
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
alias jenvinit='eval "$(jenv init -)"';
alias nodenvinit='eval "$(nodenv init -)"';
alias pyenvinit='eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init init -)"'

# Only if this is a login shell
if [[ $- = *i* ]]
then
    [[ -e "${HOME}/.git-completion" ]] && source ~/.git-completion 2>/dev/null;
    [[ -e "/usr/local/bin/starship" ]] && eval "$(starship init ${SHELL})";
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh";
fi
