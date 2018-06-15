#$HOME/.bash_aliases

# definitly swhich to nvim:
alias vim="nvim"
alias v="nvim"
alias vimdiff="nvim -d"

alias sshpi="ssh pi@192.168.1.3"

# ls aliases
alias ls="ls -I '*.pyc' --color=auto"
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -Al'
alias lt='ls -la --sort=time'

# grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# disk usage du alias
function _du() {
  du --max-depth=1 -k $1 | sort -n | awk '
        function human(x) {
            s="kMGTEPYZ";
            while (x>=1000 && length(s)>1)
                {x=x/1024; s=substr(s,2)}
                y = sprintf("%.1f", x)
            return y " " substr(s,1,1) "B"
        }
        {gsub(/^[0-9]+/, human($1)); print}'
}
alias du=_du
alias libclean="find . | grep -E '(__pycache__|\.pyc|\.pyo|\.orig$)' | xargs rm -rf"

function _sep() {
  echo $1 | sed 's/:/\n/g' |\
    sed 's/\/nix\/store\/................................-//g' |\
    sed 's/\/lib\/python...\/site-packages//g'
}
alias sep=_sep

# Latex :
latex_overview(){ $HOME/tools/latexmk/latexmk.pl -pdf -pvc -interaction=nonstopmode $1; }

# openVPN with Private Internet Access :
vpn_up(){ sudo openvpn --config /home/gjeusel/.pia/config/France.ovpn \
--ca /home/gjeusel/.pia/config/ca.rsa.2048.crt \
--crl-verify /home/gjeusel/.pia/config/crl.rsa.2048.pem \
--auth-user-pass /home/gjeusel/.pia/auth.txt ;}

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
fnix?(){ nix-env --file "/etc/nixpkgs/" --query --available --attr-path --status --description ".*$1.*";  }
nixgrep(){ grep --color=always --recursive "$1" "$(nix-instantiate --find-file --eval --expr nixpkgs)";}

# KDE plasma 5:
kde?(){ kcmshell5 --list |grep "$1";}
kde!(){ kcmshell5 "$1";}

# git-jump
alias git-jump="$waxCraft_PATH/tools/git-jump"
# hg-jump
alias hg-jump="$waxCraft_PATH/tools/hg-jump"
# ag-jump (vim with ag cml tool for grep)
alias ag="ag --ignore-dir build/"
alias ag-jump="$waxCraft_PATH/tools/ag-jump"
alias jag="ag-jump grep"

# mercurial (hg)
alias hl='hg pull'
alias hp='hg push'
alias hd='hg diff'
alias hc='hg commit'
alias hco='hg checkout'
alias hb='hg branch'
alias hs='hg status'
alias ha='hg add'

# git
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias ga='git add'
alias glog='git log --oneline --graph --decorate --all'


# env nix-shell :
alias load_env_clang="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-clang.nix"
alias load_env_GNU="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-GNU.nix"
alias load_env_scipy="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-scipy.nix"
alias load_env_intraday="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-intraday.nix"
alias load_env_machlearn="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-machlearn.nix"
alias load_env_deeproof="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-deepRoof.nix"
alias lml=load_env_machlearn
alias lmp=load_env_deeproof

alias le_stmarket="nix-shell $waxCraft_PATH/nix/nix-shell/nix-shell-stmarket.nix"

alias unproxy="source $waxCraft_PATH/tools/unset_proxy.py"
alias li="unproxy && cd ~/intraday/ && load_env_intraday"

alias ipy="ipython -i "
alias pt="pytest --log-level=DEBUG -x --pdb -k "

alias vimrc="vim ~/.vimrc*"
alias nvimrc="nvim $waxCraft_PATH/dotfiles/.config/nvim/init.vim"

# Spark aliases :
if hash ipython 2>/dev/null; then
  alias pyspark="PYSPARK_DRIVER_PYTHON=$(which ipython) pyspark"
fi

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

alias infogpu='nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l 5'

alias act='source activate'


dockerrun() {
    docker run \
        -e rsync_proxy=$rsync_proxy \
        -e https_proxy=$https_proxy \
        -e http_proxy=$https_proxy \
        -e no_proxy=$no_proxy \
        -e ftp_proxy=$ftp_proxy \
        --volume $(pwd):/data \
        -ti $1 \
        /bin/bash
}
