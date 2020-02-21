# Set up competitive programming stuff
mkdir ~/../../usr/local/include/bits && touch ~/../../usr/local/include/bits/stdc++.h
cat files/stdc++.h >> ~/../../usr/local/include/bits/stdc++.h

mkdir ~/.icpc
cp files/code.cpp ~/.icpc
cp files/makefile ~/.icpc
cp files/stdc++.h ~/.icpc

# Setup bash_profile
cat files/bash_profile >> ~/.bash_profile
source ~/.bash_profile

# Set dev folder
mkdir ~/Projects

# Get a brew on
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "export PATH="/usr/local/sbin:$PATH" # brew" >> ~/.bash_profile && source ~/.bash_profile

# Get some repositories
brew tap homebrew/code
brew tap homebrew/services
brew tap caskroom/cask
brew tap caskroom/versions

# Install
brew cask install visual-studio-code # general editor
brew cask install typora # markdown editor
brew cask install google-chrome # browser
brew cask install google-backup-and-sync # backup
brew cask install whatsapp # communication
brew cask install telegram # communication
brew cask install slack # communication
brew cask install spotify # music
brew cask install vlc # video player
brew cask install stremio # streaming
brew cask install cakebrew # brew GUI
brew cask install appcleaner # remove apps
brew cask install android-file-transfer # android manipulation

brew install git git-lfs git-crypt # git-crypt make support for automatic encryption on pushing to git
brew install gcc
brew install htop # better 'top'
brew install openssh # Open SSH
brew install ssh-copy-id # The main OpenSSH page
brew install vim --with-override-system-vi
brew install bash # Latest version of bash
brew install bash-completion # Excelent escape command completion for bash
brew install make # for makefile
brew install go
brew install ruby
brew install node npm
brew install mysql # sqlite postgresql
brew install python3 pip3
pip3 install virtualenv virtualenvwrapper
#brew install docker-machine

# Config paths
cat files/bash_profile_python_env >> ~/.bash_profile
cat files/bash_profile_go_env >> ~/.bash_profile
source ~/.bash_profile

# Config git (based on https://gist.github.com/scottnonnenberg/fefa3f65fdb3715d25882f3023b31c29)
git config --global user.name "Claudio Segala Rodrigues Silva Filho"
git config --global user.email "claudiosegalafilho@gmail.com"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.ff 'merge --ff-only'
git config --gloabl alias.undo 'reset --soft HEAD^'
git config --global alias.stash-all 'stash save --include-untracked'
git config --global alias.glog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
#git config --global commit.gpgSign true
git config --global core.editor "code --wait"
echo .DS_Store >> ~/.gitignore_global

# Config ruby
\curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm | head -n 1
rvm use ruby --install --default
gem install jekyll

# Config go
mcd ~/Projects\ Golang
mkdir bin
mkdir src
echo "export GOPATH=\"$HOME/Projects Golang\"" >> ~/.bash_profile

# Finishing setup
brew doctor
