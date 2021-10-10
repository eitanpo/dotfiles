# Add Homebrew sbin to the `$PATH`
export PATH="/usr/local/sbin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if [ -f "`which brew`" ] && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Add eksctl completion
if command -v eksctl 1>/dev/null 2>&1; then
	. <(eksctl completion bash)
fi

# Add direnv
if command -v direnv 1>/dev/null 2>&1; then
	eval "$(direnv hook bash)"
fi

# Starship
if command -v starship 1>/dev/null 2>&1; then
	eval "$(starship init bash)"
fi

# gcloud
if [ -e "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]; then
	# add gcloud to path
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
	# gcloud completion
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
fi

# Add pyenv
if command -v pyenv 1>/dev/null 2>&1; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"

	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# Vagrant
if [ -f "/opt/vagrant/embedded/gems/2.2.16/gems/vagrant-2.2.16/contrib/bash/completion.sh" ]; then
	. /opt/vagrant/embedded/gems/2.2.16/gems/vagrant-2.2.16/contrib/bash/completion.sh
else
	echo "Missing /opt/vagrant/embedded/gems/2.2.16/gems/vagrant-2.2.16/contrib/bash/completion.sh"
fi
