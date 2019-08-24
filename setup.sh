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

# Set default folder
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
brew cask install google-chrome
brew cask install google-backup-and-sync
brew cask install android-file-transfer
brew cask install vlc
brew cask install spotify
brew cask install the-unarchiver
brew cask install appcleaner
brew cask install slack
brew cask install whatsapp
brew cask install telegram
brew cask install cakebrew

brew install git git-crypt # git-crypt make support for automatic encryption on pushing to git
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

# Config git
git config --global user.name "Claudio Segala Rodrigues Silva Filho"
git config --global user.email "claudiosegalafilho@gmail.com"

# Config ruby
\curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm | head -n 1
rvm use ruby --install --default
gem install jekyll

# Config go
mkdir ~/.go
mkdir ~/.go/bin
mkdir ~/.go/src
echo

# Finishing setup
brew doctor
