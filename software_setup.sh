# Set git projects folder
cd && mkdir Projects

# Get a brew on
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "export PATH="/usr/local/sbin:$PATH" # brew" >> ~/.bash_profile && source ~/.bash_profile

# Get some repositories
brew tap homebrew/code
brew tap homebrew/services
brew tap caskroom/cask
brew tap caskroom/versions

# Install
brew cask install google-chrome
brew cask install google-backup-and-sync
brew cask install android-file-transfer
brew cask install vlc
brew cask install spotify
brew cask install the-unarchiver
brew cask install appcleaner
brew cask install skype
brew cask install slack
brew cask install whatsapp
brew cask install telegram
brew cask install cakebrew

brew install repo # for android development
brew install git git-crypt # git-crypt make support for automatic encryption on pushing to git
brew install gcc
brew install cunit
brew install libyaml # YAML 1.1 parser and emitter written in C
brew install readline # library that provides a set of functions for use by applications that allow users to edit command lines as they are typed in
brew install htop # better 'top'
brew install openssh # Open SSH
brew install ssh-copy-id # The main OpenSSH page
brew install vim --with-override-system-vi
brew install bash # Latest version of bash
brew install bash-completion # Excelent escape command completion for bash
brew install cmake # to generate makefile
brew install make # for makefile
brew cask install texmaker # Latex
brew install go
brew install node npm
brew install mysql # sqlite postgresql
brew install python3 pip3
pip3 install virtualenv virtualenvwrapper
#brew install docker-machine

# Config paths
echo \
"# python env
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh" \ 
>> ~/.bash_profile
source ~/.bash_profile

# Config git
git config --global user.name "Claudio Segala Rodrigues Silva Filho"
git config --global user.email "claudiosegalafilho@gmail.com"

# Finishing setup
brew update
brew cleanup
brew upgrade
brew cleanup
brew doctor

# Close Window
osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "w" using command down' &&
