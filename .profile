#make sure we don't create pyc files
export PYTHONDONTWRITEBYTECODE=True
export PYTHONSTARTUP="${HOME}/.pythonrc";
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
export COPYFILE_DISABLE=true
export ANSIBLE_HOST_KEY_CHECKING=False
export VISUAL="subl -w";
export BASH_SILENCE_DEPRECATION_WARNING=1;
export EDITOR="$VISUAL";

export PATH="${HOME}/.private/.bin:${HOME}/.bin:${HOME}/.luaenv/bin:/usr/local/sbin:$PATH";
export STARSHIP_CONFIG="${HOME}/.starship.toml";
export SDKMAN_DIR="${HOME}/.sdkman";
