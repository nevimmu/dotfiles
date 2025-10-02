if status is-interactive
	# Commands to run in interactive sessions can go here
	abbr p sudo pacman -S
	abbr pr sudo pacman -R
	abbr y yay -S
	abbr vim nvim
	abbr vi nvim
	abbr tt tree
	abbr cdp cd ~/Documents/projects/
end

set STARSHIP_CONFIG $STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source
fish_vi_key_bindings
zoxide init --cmd cd fish | source

function fish_greeting
	fastfetch
end

function ya
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# Created by `pipx` on 2025-05-29 15:36:18
set PATH $PATH /home/nev/.local/bin
set EDITOR $EDITOR nvim
