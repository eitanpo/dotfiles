# cp ~dotfiles/.bash_profile ~/.bash_profile
# mv ~/dotfiles/ ~/.dotfiles/

for file in ~/.dotfiles/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
