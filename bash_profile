#======================================================================
# Desc: '.bash_profile' is loaded once at terminal start.
#======================================================================

# GIT autocomplete (GIT TAB-TAB)
# See: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
#----------------------------------------------------------------------

source ~/scripts/git_completion.sh

# GIT branch in terminal prompt
# See: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
#----------------------------------------------------------------------

source ~/scripts/git_prompt.sh

# Change default Terminal prompt
# Custom prompt: http://www.itiseezee.com/?p=239
# Prompt color: http://www.mactricksandtips.com/2008/10/customizing-the-mac-terminal-bash-prompt.html
#----------------------------------------------------------------------

# PS1='\[\e[1;34m\][\w]$(__git_ps1 " (%s)") \r\n$  \e[1;34m\]'
PS1='\[\e[1;33m\][\w]$(__git_ps1 " (%s)")\r\n$ \[\e[0;37m\]'

# Change default file color listings
# See: http://geekology.co.za/article/2009/04/how-to-enable-terminals-directory-and-file-color-highlighting-in-mac-os-x
#----------------------------------------------------------------------

# 1.  directory
# 2.  symbolic link
# 3.  socket
# 4.  pipe
# 5.  executable
# 6.  block special
# 7.  character special
# 8.  executable with setuid bit set
# 9.  executable with setgid bit set
# 10. directory writable to others, with sticky bit
# 11. directory writable to others, without sticky bit

# a black
# b red
# c green
# d brown
# e blue
# f magenta
# g cyan
# h light grey
# A bold black, usually shows up as dark grey
# B bold red
# C bold green
# D bold brown, usually shows up as yellow
# E bold blue
# F bold magenta
# G bold cyan
# H bold light grey; looks like bright white
# x default foreground or background

export CLICOLOR=1
export LSCOLORS=HEFxBxDxbxegedabagacad

# Add ~/scripts folder to $PATH
#----------------------------------------------------------------------

export "PATH=$PATH:~/scripts"
export PATH=/usr/local/bin:$PATH

# source ~/scripts/git-workflow.sh

# Storing in repo, so source the latest from there
source ~/rails/git-workflow/git-workflow.sh

# Load RVM into a shell session (as a function)
#----------------------------------------------------------------------

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Added by the Heroku Toolbelt
#----------------------------------------------------------------------

export PATH="/usr/local/heroku/bin:$PATH"

# Add RVM to path for scripting (makes RVM happy to have it first)
#----------------------------------------------------------------------

export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$GEM_HOME/bin:$PATH"

# Alias commands
#----------------------------------------------------------------------

alias cdrails="cd ~/rails"
alias grep="grep --color=auto"
alias la="ls -al"
