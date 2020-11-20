# .bashrc must NOT output anything

[[ -e ~/.private ]] && source /dev/stdin <<<"$(cat ~/.private/*rc 2>/dev/null)";

# Only if this is a login shell
if [[ $- = *i* ]]
then
    source ${HOME}/.functions
    source ${HOME}/.aliases
    [[ -e "${HOME}/.git-completion" ]] && source "${HOME}/.git-completion" 2>/dev/null;
    # [[ -e "/usr/local/bin/kubectl" ]] && source <(kubectl completion $(basename ${SHELL}))
    [[ -e "/usr/local/bin/direnv" ]] && eval "$(direnv hook ${SHELL})"
    #[[ -e "/usr/local/bin/starship" ]] && eval "$(starship init ${SHELL})";
fi
