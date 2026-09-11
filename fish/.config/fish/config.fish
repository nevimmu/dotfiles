source /usr/share/cachyos-fish-config/cachyos-config.fish

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

starship init fish | source
fish_vi_key_bindings
zoxide init --cmd cd fish | source

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
