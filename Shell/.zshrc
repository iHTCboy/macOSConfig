# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/htc/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  z
  wd
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


alias lpi="lipo -i"
alias hdg="hexo clean; hexo deploy -g"
alias macss="sudo spctl --master-disable"
alias macssab="sudo spctl --master-enable"
alias zshconfig='vim ~/.zshrc'
alias cls='clear'
alias htcbg='cd /Users/HTC/Documents/Personal/P-Project/iHTCBlog/'
alias htcmind='cd /Users/HTC/Documents/Personal/P-Project/OneMindMap/'
alias htcnote='cd /Users/HTC/Documents/Personal/P-Project/NotesEveryDay/'
alias htcimg='cd /Users/HTC/Documents/Personal/P-Project/iGallery/'
alias mkipa='sh /Users/HTC/Documents/Personal/P-Project/iShell/Shell/make_ipa_file.sh'

# Git
alias gam="git add .; git commit -m "

function glazy() {
    git add .
    git commit -a -m "$1"
    git push
}

alias gs="git status"
alias gaa="git add ."
alias gc="git commit -m "
alias gcl="git clone"
alias gp="git pull"
alias gps="git push"
alias gl="git log --graph --all --format=format:'%C(bold blue)%h %C(bold green)(%cr) %C(bold white)%cn: %C(bold yellow)%d%C(reset) %C(white)%s%C(reset)' --abbrev-commit --date=relative && echo '\033[2A'"
alias gll="git log --graph --all --format=format:'%C(bold blue)%h %C(bold green)(%cr) %C(bold cyan)%cD %C(bold yellow)%d%n''        %C(bold white)%cn:%C(reset) %C(white)%s%C(reset)' --abbrev-commit && echo '\033[2A'"

# Python
alias venv='virtualenv --python=python3 venv'
alias actvenv='source venv/bin/activate'
alias pireq='pip install -r requirements.txt'


# iOS MonkeyDev
export MonkeyDevPath=/opt/MonkeyDev
export MonkeyDevDeviceIP=
export PATH=/opt/MonkeyDev/bin:$PATH

# JAVA
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home
export CLASSPAHT=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH:
#export JAVA_HOME=$(/usr/libexec/java_home)

# Android dev
export PATH=${PATH}:/Users/HTC/Library/Android/sdk/platform-tools
export PATH=${PATH}:/Users/HTC/Library/Android/sdk/tools
export PATH=${PATH}:/Users/HTC/Library/Android/sdk/tools/bin/sdkmanager

# Flutter 
export PATH=${PATH}:/Users/HTC/Documents/Programing/Flutter/flutter/bin

#mysql
export PATH=$PATH:/usr/local/mysql/bin

#ARM 版的 Homebrew
export PATH=$PATH:/opt/homebrew/bin

# Homebrew
alias abrew='/opt/homebrew/bin/brew' # ARM Homebrew
alias ibrew='arch -x86_64 /usr/local/bin/brew' # X86 Homebrew
alias export PATH=/opt/homebrew/bin:$PATH

# CocoaPods
alias ipod='arch -x86_64 pod'
alias pov='pod --version'
alias poi='pod install'
alias pou='pod update'
alias pll='pod lib lint --allow-warnings --sources="https://code.37ops.com/sy_ios_pods/TSMGPods/TSMGPodSpecs.git"'
alias prp='pod repo push --allow-warnings TSMGSpecs '

# TSMG
alias gapu="sh /Users/HTC/Documents/Programing/37/TS/TSMGScript/Git/TS-Components-Git-Pull.sh"
alias tspu="cd /Users/HTC/Documents/Programing/37/TS; sh /Users/HTC/Documents/Programing/37/TS/TSMGScript/Git/TS-Components-Git-Pull.sh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#mysql-client
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
#mysql-client compilers
export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
#mysql-client pkg-config
export PKG_CONFIG_PATH="/usr/local/opt/mysql-client/lib/pkgconfig"

# tidevice https://github.com/alibaba/taobao-iphone-device
alias iphone='tidevice'

# WeChat Duplicator
alias opwx='cd /Applications/WeChat.app/Contents/MacOS;./WeChat'

