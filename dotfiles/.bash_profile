# Print shell and version
echo $SHELL $BASH_VERSION

# Add Homebrew sbin to the `$PATH`
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Shell options (Bash 4+)
# nocaseglob - case-insensitive globbing
# histappend - append to history file instead of overwriting
# cdspell/dirspell - autocorrect typos in paths
# autocd - cd to directory by typing its name
# globstar - recursive globbing with **
# cmdhist - save multi-line commands as one entry
for option in nocaseglob histappend cdspell dirspell autocd globstar cmdhist; do
	shopt -s "$option" 2>/dev/null || true
done

# History sharing across terminals
# - Append to history file after each command (preserves history on crash)
# - Merge and deduplicate history on shell exit
_historymerge() {
	history -n  # read new lines from history file
	history -w  # write history (triggers erasedups)
	history -c  # clear in-memory history
	history -r  # reload from file
}
trap _historymerge EXIT
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Add tab completion for many Bash commands
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
	if command -v brew &>/dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
		# Ensure existing Homebrew v1 completions continue to work
		export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
		source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion;
	fi;
fi

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

# Tool integrations - use this pattern for new tools:
#   if command -v TOOL &>/dev/null; then
#       eval "$(TOOL init bash)"
#   fi

# Add eksctl completion
if command -v eksctl &>/dev/null; then
	. <(eksctl completion bash)
fi

# Add direnv
if command -v direnv &>/dev/null; then
	eval "$(direnv hook bash)"
fi

# Starship
if command -v starship &>/dev/null; then
	eval "$(starship init bash)"
fi

# gcloud
gcloud_dir="$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
if [ -e "$gcloud_dir" ]; then
	source "$gcloud_dir/path.bash.inc"
	source "$gcloud_dir/completion.bash.inc"
fi
unset gcloud_dir

# Add pyenv
if command -v pyenv &>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"

	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	command -v pyenv-virtualenv-init &>/dev/null && eval "$(pyenv virtualenv-init -)"
fi

# Vagrant
if command -v vagrant &>/dev/null; then
	vagrant_completion=$(find /opt/vagrant/embedded/gems -name "completion.sh" 2>/dev/null | head -1)
	[ -n "$vagrant_completion" ] && . "$vagrant_completion"
	export CONTAINER_HOST=ssh://vagrant@127.0.0.1:2222/run/podman/podman.sock
fi

# local bin
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$PATH:$HOME/.local/bin"
fi

# bazel
if [ -f "$HOME/.bazelenv" ]; then
	source "$HOME/.bazelenv"
fi

# fnm
if command -v fnm &>/dev/null; then
	eval "$(fnm env)"
fi

# orbstack
if [ -f "$HOME/.orbstack/shell/init.bash" ]; then
	source "$HOME/.orbstack/shell/init.bash" 2>/dev/null || :
fi

# Add cargo
if [ -d "$HOME/.cargo/bin" ]; then
	export PATH="$PATH:$HOME/.cargo/bin"
fi

# bazel@7
if [ -d "/opt/homebrew/opt/bazel@7/bin" ]; then
	export PATH="/opt/homebrew/opt/bazel@7/bin:$PATH"
fi

# java
if /usr/libexec/java_home -v 11 &>/dev/null; then
	export JAVA_HOME="$(/usr/libexec/java_home -v 11)"
	export PATH="$JAVA_HOME/bin:$PATH"
fi
