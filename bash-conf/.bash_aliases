#$HOME/.bash_aliases

# ls aliases
alias ls='ls --color'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -Al'
alias lt='ls -la --sort=time'

# grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# disk usage du alias
alias du='du --max-depth=1 -h -a'

# Wine :
alias hearthstone="wine /home/gjeusel/.wine/drive_c/Program\ Files/Battle.net/Battle.net.exe "
alias IHT="wine /home/gjeusel/.wine/drive_c/Program\ Files/Interactive\ Heat\ Transfer/IHT32.exe"
alias ageofmythology="WINEARCH=win32 WINEPREFIX=$HOME/.wine-AgeOf/ wine ~/.wine-AgeOf/drive_c/Program\ Files/Microsoft\ Games/Age\ of\ Mythology/aomx.exe"

# NixOS aliases
#function _nix_which_() {
#ls $(ls -la $(which $1) |grep --only-matching "/nix/store/.*")
#}
#alias nwhich=_nix_which_
nwhich(){ readlink $(which $1);}

# Nixpkgs
nix?(){ nix-env --query --available --attr-path --status --description ".*$1.*";  }
nixgrep(){ grep --color=always --recursive "$1" "$(nix-instantiate --find-file --eval --expr nixpkgs)";}

# git-jump
alias git-jump="$waxCraft_PATH/tools/git-jump"

alias load_env_clang="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-clang.nix"
alias load_env_GNU="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-GNU.nix"
alias load_env_scipy="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-scipy.nix"

# Modules aliases
alias maa='module avail 2>&1 |grep -i'
alias ma='module avail 2>&1'
alias ml='module list 2>&1'
alias mll='module load'
alias ms='module swap'
alias mss='module show'
alias mh='module help'
alias mw='module whatis'

#PrgEnv
function _load_pgi_env() {
module swap $(module list 2>&1 |grep --only-matching PrgEnv.*) PrgEnv-pgi

ml
}

alias pgi='_load_pgi_env'