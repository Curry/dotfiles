#! /bin/zsh
export TERM='xterm-256color'
export VISUAL=nvim
export EDITOR="$VISUAL"
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000000
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export PATH="$HOME/.yarn/bin:$PATH"

setopt histverify
setopt extendedhistory
setopt histignorealldups
setopt histreduceblanks
setopt incappendhistory
setopt sharehistory
setopt interactive_comments
setopt extended_glob
setopt autocd

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
    print -P "%F{160}▓▒░ The clone has failed.%f"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':history-search-multi-word' page-size '11'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,command'
zstyle ':completion:*:*:make:*' tag-order 'targets'

zinit is-snippet for \
  OMZ::lib/git.zsh \
  OMZ::plugins/git/git.plugin.zsh \
  OMZ::plugins/pyenv/pyenv.plugin.zsh \
  OMZ::plugins/ng/ng.plugin.zsh

zinit cdclear -q

zinit light-mode for \
  zinit-zsh/z-a-bin-gem-node \
  mafredri/zsh-async \
  atclone'dircolors -b LS_COLORS > clrs.zsh' \
    atpull'%atclone' pick'clrs.zsh' nocompile'!' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"' trapd00r/LS_COLORS

zinit atload'!source ~/.p10k.zsh' lucid nocd for \
  romkatv/powerlevel10k

zinit as'null' wait'1' lucid from'gh-r' for \
  fbin'fzf' junegunn/fzf-bin \
  sbin'**/fd' @sharkdp/fd \
  mv'tl-* -> tl' fbin'tl' ryanmjacobs/tl

zinit as'null' wait'1' lucid for \
  fbin'bin/git-dsf;bin/diff-so-fancy' zdharma/zsh-diff-so-fancy \
  fbin rupa/v

zinit wait lucid for \
  changyuheng/fz \
  andrewferrier/fzf-z \
  seletskiy/zsh-fuzzy-search-and-edit \
  rupa/z \
  blockf zsh-users/zsh-completions \
  hcgraf/zsh-sudo \
  atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' zdharma/fast-syntax-highlighting \
  atload'!_zsh_autosuggest_start' zsh-users/zsh-autosuggestions \
  zdharma/history-search-multi-word \
  lukechilds/zsh-nvm

bindkey '^P' fuzzy-search-and-edit

alias npm='noglob npm'
alias e='nvim'
alias zrc='$EDITOR ~/.zshrc'
alias pyd='pyenv deactivate'
alias pya='pyenv activate'
alias ls='exa --git'
alias l='ls -la'
alias la='ls -lag --time-style=iso --group-directories-first'
alias brewup='brew update; brew upgrade; brew cleanup; brew doctor'
alias qmku='gcm && glum && gp && gcd && grbm && gpf'
alias gfix='gaa && fix && gpf'

gli() {
  gaa
  gcam "$1"
  ggpush
}

fix () {
  git commit --fixup $(echo "$(git rev-parse --short HEAD)")
  GIT_SEQUENCE_EDITOR=true grbi --autosquash HEAD~2
}

