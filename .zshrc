ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)
source ~/.zplug/init.zsh
zplug "zplug/zplug", hook-build:"zplug --self-manage"
# zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/gitfast", from:oh-my-zsh
# ZSH_TMUX_AUTOSTART=true
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/tmuxinator", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "themes/simple", from:oh-my-zsh, as:theme
# zplug "djui/alias-tips"
zplug "zsh-users/zsh-completions"

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

export EDITOR="nvim"
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR

export TERM=xterm-256color

# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_COMMAND='rg  --colors "match:fg:cyan" --colors "path:fg:green" --files --smart-case --hidden --follow --sort-files --glob "!.git/*"'

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
export GOPATH="$HOME/go"
export LGOBIN="$HOME/go/bin"
export FZF_BIN_PATH="$HOME/.fzf/bin"
export PATH=$PATH:~/.config/composer/vendor/bin:~/bin:$LGOBIN:$FZF_BIN_PATH
export NVIM_TUI_ENABLE_CURSOR_SHAPE=0
export TMP=/tmp
export TMPDIR=/tmp

# Increase Bash history size. Allow 32³ entries; the default is 500.
HISTSIZE='32768';
HISTFILESIZE="${HISTSIZE}";
HISTFILE="$HOME/.zsh_history"
SAVEHIST=5000
HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

alias sdn='sudo shutdown now -h'
alias update='sudo apt-fast update && sudo apt-fast upgrade'
alias agi='sudo apt-fast install'
alias vu='vagrant up'
alias vs='vagrant ssh'
alias vh='vagrant halt'
alias ob='observr autotest.rb'
alias ls="ls --color=auto"
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias grep='grep --color'

alias mux='tmuxinator'
# Just fun
alias fucking=sudo

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# autoload -U compinit && compinit

# disable c-s and c-q freeze
stty stop ''
stty start ''
stty -ixon
stty -ixoff

alias gb="git for-each-ref --sort=committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)'"
alias gbd="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"



alias canihazinterwebz='sudo dhclient -r;sudo dhclient &'
alias tw='mux shell'

setopt AUTO_CD
setopt AUTO_PUSHD PUSHD_TO_HOME
alias d='dirs -v'

setopt CORRECT

my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

function setgov ()
{
     for i in {0..7};
     do
         sudo cpufreq-set -c $i -g $1; 
     done
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}


# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
gbf() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

bindkey -e
PATH=/home/jm/.gvm/pkgsets/go1.8.1/global/bin:/home/jm/.gvm/gos/go1.8.1/bin:/home/jm/.gvm/pkgsets/go1.8.1/global/overlay/bin:/home/jm/.gvm/bin:/home/jm/.gvm/bin:/home/jm/.zplug/repos/zplug/zplug/bin:/home/jm/.cargo/bin:/home/jm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/jm/.composer/vendor/bin:/home/jm/.gvm/gos/go1.8/bin:/home/jm/.composer/vendor/bin:/home/jm/.config/composer/vendor/bin:/home/jm/bin:/home/jm/go/bin:/home/jm/.fzf/bin:/home/jm/.composer/vendor/bin
