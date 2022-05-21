
local ZSH_CONF=$HOME/.zsh                      # Define the place I store all my zsh config stuff
local ZSH_CACHE=$ZSH_CONF/cache                # for storing files like history and zcompdump 

# Set important shell variables
   export EDITOR=vim                           # Set default editor
   export WORDCHARS=''                         # This is the oh-my-zsh default, I think I'd like it to be a bit different 
   export PAGER=less                           # Set default pager
   export LESS="-R"                            # Set the default options for less 
   export LANG="en_US.UTF-8"                   # I'm not sure who looks at this, but I know it's good to set in general
   export TERM=xterm-256color

# Misc
   setopt ZLE                                  # Enable the ZLE line editor, which is default behavior, but to be sure
   declare -U path                             # prevent duplicate entries in path
   LESSHISTFILE="/dev/null"                    # Prevent the less hist file from being made, I don't want it
   setopt NO_BEEP                              # Disable beeps
   setopt MULTI_OS                             # Can pipe to mulitple outputs
   unsetopt NO_HUP                             # Kill all child processes when we exit, don't leave them running
   setopt INTERACTIVE_COMMENTS                 # Allows comments in interactive shell.
   setopt RC_EXPAND_PARAM                      # Abc{$cool}efg where $cool is an array surrounds all array variables individually
   unsetopt FLOW_CONTROL                       # Ctrl+S and Ctrl+Q usually disable/enable tty input. This disables those inputs

# ZSH History 
   alias history='fc -fl 1'
   HISTFILE=$ZSH_CACHE/history                 # Keep our home directory neat by keeping the histfile somewhere else
   SAVEHIST=100000                             # Big history
   HISTSIZE=100000                             # Big history
   setopt EXTENDED_HISTORY                     # Include more information about when the command was executed, etc
   setopt APPEND_HISTORY                       # Allow multiple terminal sessions to all append to one zsh command history
   setopt HIST_FIND_NO_DUPS                    # When searching history don't display results already cycled through twice
   setopt HIST_EXPIRE_DUPS_FIRST               # When duplicates are entered, get rid of the duplicates first when we hit $HISTSIZE 
   setopt HIST_IGNORE_SPACE                    # Don't enter commands into history if they start with a space
   setopt HIST_VERIFY                          # makes history substitution commands a bit nicer. I don't fully understand
   setopt SHARE_HISTORY                        # Shares history across multiple zsh sessions, in real time
   setopt HIST_IGNORE_DUPS                     # Do not write events to history that are duplicates of the immediately previous event
   setopt INC_APPEND_HISTORY                   # Add commands to history as they are typed, don't wait until shell exit
   setopt HIST_REDUCE_BLANKS                   # Remove extra blanks from each command line being added to history

# ASDF
   if [ -f $HOME/.asdf/asdf.sh ]; then
      source $HOME/.asdf/asdf.sh 
      # append completions to fpath
      fpath=(${ASDF_DIR}/completions $fpath)
      export PATH="$(yarn global bin):$PATH"
   fi

# ZSH Auto Completion
   # Figure out the short hostname
   if [[ "$OSTYPE" = darwin* ]]; then          
      # OS X's $HOST changes with dhcp, etc., so use ComputerName if possible.
      SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
   else
      SHORT_HOST=${HOST/.*/}
   fi
 
   #the auto complete dump is a cache file where ZSH stores its auto complete data, for faster load times
   local ZSH_COMPDUMP="$ZSH_CACHE/acdump-${SHORT_HOST}-${ZSH_VERSION}"  #where to store autocomplete data
 
   autoload -U compinit                                    # Autoload auto completion
   compinit -i -d "${ZSH_COMPDUMP}"                        # Init auto completion; tell where to store autocomplete dump
   zstyle ':completion:*' menu select                      # Have the menu highlight as we cycle through options
   zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'     # Case-insensitive (uppercase from lowercase) completion
   setopt COMPLETE_IN_WORD                                 # Allow completion from within a word/phrase
   setopt ALWAYS_TO_END                                    # When completing from the middle of a word, move cursor to end of word
   setopt MENU_COMPLETE                                    # When using auto-complete, put the first option on the line immediately
   setopt COMPLETE_ALIASES                                 # Turn on completion for aliases as well
   setopt LIST_ROWS_FIRST                                  # Cycle through menus horizontally instead of vertically

# Bindings
   bindkey "^a" vi-beginning-of-line
   bindkey "^e" vi-end-of-line
   bindkey "^[[1;3C" forward-word
   bindkey "^[[1;3D" backward-word

# Aliases
   if [ -x "$(command -v lsd)" ]; then
      alias ls='lsd'
   fi

   if [ -x "$(command -v nvim)" ]; then
      alias vim='nvim'
      export EDITOR=nvim
   fi 

   if [ -x "$(command -v bat)" ]; then
      alias cat='bat'
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"

      bdiff() {
          git diff --name-only --diff-filter=d | xargs bat --diff
      }
   fi

   alias pip-upgrade="pip freeze | cut -d'=' -f1 | xargs -n1 pip install -U"

# FZF
   if [ -x "$(command -v rg)" ]; then
      export FZF_DEFAULT_COMMAND='rg --files --hidden --follow 2>/dev/null'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
   fi
  
   if [ -f /usr/share/fzf/shell/key-bindings.zsh ]; then
      source /usr/share/fzf/shell/key-bindings.zsh
   fi

# Node
  if [ -d $HOME/.local/.npm-global ]; then
     export PATH=~/.local/.npm-global/bin:$PATH
  fi

# Python
  if [ -d $HOME/.local/python/venvs/default ]; then
     source ~/.local/python/venvs/default/bin/activate
     export PATH=~/.local/python/venvs/default/bin:$PATH
  fi

# Prompt
   if [ -f /usr/local/bin/starship ]; then
      eval "$(starship init zsh)"
   fi
