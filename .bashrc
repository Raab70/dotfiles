# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# Git setup
source ~/git-prompt.sh
source ~/git-completion.bash
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
# This doesn't work as PS1 colors override
# GIT_PS1_SHOWCOLORHINTS=true
prompt_command () {
    if [ "\$(type -t __git_ps1)" ]; then # if we're in a Git repo, show current branch
        BRANCH="\$(__git_ps1 '( %s ) ')"
    fi
    local TIME=`fmt_time` # format time for prompt string
    local LOAD=`uptime|awk '{min=NF-2;print $min}'`
    local GREEN="\[\033[0;32m\]"
    local LGREEN="\[\033[01;32m\]"
    local CYAN="\[\033[0;36m\]"
    local BCYAN="\[\033[1;36m\]"
    local BLUE="\[\033[0;34m\]"
    local LBLUE="\[\033[01;34m\]"
    local GRAY="\[\033[0;37m\]"
    local DKGRAY="\[\033[1;30m\]"
    local WHITE="\[\033[1;37m\]"
    local RED="\[\033[0;31m\]"
    # return color to Terminal setting for text color
    local DEFAULT="\[\033[0;39m\]"
    # set the titlebar to the last 2 fields of pwd
    local TITLEBAR='\[\e]2;`pwdtail`\a'
    PS1="${LGREEN}[\u@\h${DKGRAY}(${LOAD}) ${GRAY}${TIME} ${LGREEN}]${LBLUE} \w ${RED}${BRANCH}${DEFAULT}\n$ "

    if [ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ] ; then
        _OLD_VIRTUAL_PS1="$PS1"
        if [ "x" != x ] ; then
            PS1="$PS1"
        else
            if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
                # special case for Aspen magic directories
                # see http://www.zetadev.com/software/aspen/
                PS1="[`basename \`dirname \"$VIRTUAL_ENV\"\``] $PS1"
            elif [ "$VIRTUAL_ENV" != "" ]; then
                PS1="(`basename \"$VIRTUAL_ENV\"`)$PS1"
            fi
        fi
    fi
    export PS1
}
# PROMPT_COMMAND=prompt_command

fmt_time () { #format time just the way I likes it
    if [ `date +%p` = "PM" ]; then
        meridiem="pm"
    else
        meridiem="am"
    fi
    date +"%l:%M:%S$meridiem"|sed 's/ //g'
}
pwdtail () { #returns the last 2 fields of the working directory
    pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}
chkload () { #gets the current 1m avg CPU load
    local CURRLOAD=`uptime|awk '{print $8}'`
    if [ "$CURRLOAD" > "1" ]; then
        local OUTP="HIGH"
    elif [ "$CURRLOAD" < "1" ]; then
        local OUTP="NORMAL"
    else
        local OUTP="UNKNOWN"
    fi
    echo $CURRLOAD
}

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=999
HISTFILESIZE=999

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ $(id -u) -eq 0 ];
    then # you are root, make the prompt red
        PS1="\e[01;31m\u@\h: \W #\e[00m "
    else
        # PS1='\[\033[01;34m\]\u\[\033[01;32m\]@\h [\T]\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\] $(__git_ps1 " (%s)") > '
          # PS1='\[\033[01;32m\]\u@\h [\T]\[\033[00m\]:\[\033[01;34m\]\w\[\033[00;31m\]$(__git_ps1)\[\033[00m\]\n\$ '
          PROMPT_COMMAND=prompt_command
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -G'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ls='ls -G'
alias ll='ls -Galh'
alias la='ls -AG'
alias l='ls -CFG'
alias cpr='rsync -avhz --progress --stats'
alias mvr='rsync -avhz --progress --stats --remove-source-files'
alias virtualenv="virtualenv --system-site-packages"
alias sudo='sudo '
alias readlink='greadlink'

# Aliases for redis
alias redis_start='redis-server /usr/local/etc/redis.conf'
alias redis_test='redis-cli ping'

alias docker_config='eval "$(docker-machine env default)"'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export CLICOLOR=1 # same as 'alias ls=ls -G' which I also have set

# The color designators are as follows:
# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
# A     bold black, usually shows up as dark grey
# B     bold red
# C     bold green
# D     bold brown, usually shows up as yellow
# E     bold blue
# F     bold magenta
# G     bold cyan
# H     bold light grey; looks like bright white
# x     default foreground or background
#
# Note that the above are standard ANSI colors.  The actual display may differ depending on the color capabilities of the terminal in use.
#
# The order of the attributes are as follows:
# 1.   directory
# 2.   symbolic link
# 3.   socket
# 4.   pipe
# 5.   executable
# 6.   block special
# 7.   character special
# 8.   executable with setuid bit set
# 9.   executable with setgid bit set
# 10.  directory writable to others, with sticky bit
# 11.  directory writable to others, without sticky bit
# export LSCOLORS=ExFxCxDxBxegedabagacad  # light bg red exe
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx  # dark bg red exe
export LSCOLORS=ExGxBxDxBxEgEdxbxgxcDx  # Linux emulation

#Export some variables
export EDITOR=vim

LANG=en_US.UTF-8

export SPARK_HOME=/usr/local/Cellar/apache-spark/2.2.1/libexec
export PYTHONPATH=$SPARK_HOME/python/build/:$SPARK_HOME/python/:$PYTHONPATH
# export PYTHONPATH="/Library/Python/2.7/site-packages/:$PYTHONPATH"

# Turn on line numbers for tracing with set -x
export PS4='$LINENO +'

export PATH=/Users/rharrigan/bin:$PATH

_apex()  {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local opts="$(apex autocomplete -- ${COMP_WORDS[@]:1})"
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}

complete -F _apex apex
uptime
w
export PATH="$PATH:$HOME/.astro/"
