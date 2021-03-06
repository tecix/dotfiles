# Enable Powerlevel7k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.zshrc_local_before file
if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi


# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Edit command line using Ctrl-x-e
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# history-search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# ALIAS

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
#LS_COLORS="ow=01;36;40" && export LS_COLORS
# export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# List all files colorized in long format
alias ls="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
alias la="ls -lahF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
# Always use color output for `ls`
alias ls="command ls ${colorflag}"


alias clip='xclip -sel c'

# VARIABLES
if type nvim > /dev/null 2>&1; then
  export VISUAL=nvim
  alias vim='nvim'
fi

export VISUAL=nvim
export EDITOR="$VISUAL"

# alternative to select-word-style bash
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'



# CUSTOM FUNCTIONS

# my Note function
note () {
  case "$1" in
    c | cd | dir)
      cd "$notes_dir"
      ;;
    sync)
      pushd "$notes_dir"
      msg="Regenerated at $(date -u '+%Y-%m-%d %H:%M:%S') UTC"
      git add .
      git commit -m "$msg"
      git pull
      git push origin master
      popd
      # ls "$notes_dir"
      ;;
    p | push)
      pushd "$notes_dir"
      msg="Regenerated at $(date -u '+%Y-%m-%d %H:%M:%S') UTC"
      git add .
      git commit -m "$msg"
      git push origin master
      popd
      ;;
	n | new) 
	  neuron -d $notes_dir new -e
	  ;;
	l | list) 
	  neuron -d $notes_dir search -e
	  ;;
    s | search)
	  neuron -d $notes_dir search -a -e
	  ;;
	*)
	  cd "$notes_dir" && vim inbox.md && cd -
	  ;; 
  esac
}


# cheat sheets (github.com/chubin/cheat.sh), find out how to use commands
# example 'cheat tar'
# for language specific question supply 2 args first for language, second as the question
# eample: cheat python3 execute external program
cheat() {
    if [ "$2" ]; then
        curl "https://cheat.sh/$1/$2+$3+$4+$5+$6+$7+$8+$9+$10"
    else
        curl "https://cheat.sh/$1"
    fi
}

# Run the command given by "$@" in the background
silent_background() {
  if [[ -n $ZSH_VERSION ]]; then  # zsh:  https://superuser.com/a/1285272/365890
    setopt local_options no_notify no_monitor
    "$@" & disown;
  elif [[ -n $BASH_VERSION ]]; then  # bash: https://stackoverflow.com/a/27340076/5353461
    { 2>&3 "$@"& } 3>&2 2>/dev/null
  else  # Unknownness - just background it
    "$@" &
  fi
}

note_sync_updated() {
	git -C $notes_dir fetch
	# gstatus=`git -C $notes_dir status --porcelain`
	gstatus=`git -C $notes_dir status | grep 'changes'`
	if [ ${#gstatus} -ne 0 ]; then 
		note sync
	fi
}


## MAIN ==
# Sync notes on startup and exit
# num_terminal=`ls /dev/pts | wc -l`
# if [ $num_terminal -lt 3 ]; then
# 	silent_background note_sync_updated
# 	# This one does NOT work
# 	# note_sync_updated
# 	# TRAPEXIT() {
# 	# 	silent_background note_sync_updated
# 	# }

# 	# This one work -- but let's disable it cause it annoying.
# 	# And I'm using Notion.so for now
# 	# trap note_sync_updated EXIT
# fi

if [ -e /home/chithien/.nix-profile/etc/profile.d/nix.sh ]; then . /home/chithien/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# Allow local customizations in the ~/.zshrc_local_after file
if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi

# Allow local customizations in the ~/.shell_local_after file
if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
