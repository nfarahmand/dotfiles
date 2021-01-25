#make sure we don't create pyc files
export PYTHONDONTWRITEBYTECODE=True
export PYTHONSTARTUP="${HOME}/.pythonrc";
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
export COPYFILE_DISABLE=true
export ANSIBLE_HOST_KEY_CHECKING=False
export VISUAL="code --wait --new-window";
export BASH_SILENCE_DEPRECATION_WARNING=1;
export EDITOR="$VISUAL";

export PATH="${HOME}/.bin:/usr/local/sbin:$PATH";
