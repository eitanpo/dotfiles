export DOTFILES=~/.dotfiles

for file in $DOTFILES/source/*[!.].[!.]*; do
    source "$file"
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
#shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
#shopt -s cdspell;

#curl -4 http://wttr.in/Tel%20Aviv
