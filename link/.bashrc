export DOTFILES=~/.dotfiles

for file in $DOTFILES/source/.[!.]*; do
    source "$file"
done;
unset file;
