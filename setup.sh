# Get Git setup information
printf '\nWhat name do you want to add on your git commit setup? '
read -r git_name

printf '\nWhat email do you want to add on your git commit setup? '
read -r git_email


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
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/claudiosegalarodriguessilvafilho/.zprofile eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Applications
brew install --cask visual-studio-code # code editor
# brew install --cask typora # markdown editor
brew install --cask whatsapp
brew install --cask messenger
brew install --cask telegram
# brew install --cask slack
brew install --cask nordvpn # vpn
brew install --cask stremio # pirate netflix
brew install --cask spotify # music streaming
brew install --cask vlc # video player
brew install --cask google-drive # cloud backup
# brew install --cask android-file-transfer # android file transfer
# brew install --cask cakebrew
# brew install --cask appcleaner

# Install Tools
brew install just
brew install git

# Install Deno
brew install deno

# Install Misc Tools
# brew install gcc
# brew install htop # better 'top'
# brew install openssh # Open SSH
# brew install ssh-copy-id # The main OpenSSH page
# brew install vim --with-override-system-vi
# brew install bash # Latest version of bash
# brew install bash-completion # Excelent escape command completion for bash
# brew install make # for makefile
# brew install mysql # sqlite postgresql
# brew install docker-machine

# Install Ruby
# brew install ruby
# \curl -L https://get.rvm.io | bash -s stable
# source ~/.rvm/scripts/rvm
# rvm | head -n 1
# rvm use ruby --install --default
# gem install jekyll

# Install JS
# brew install node npm

# Install Python 
# brew install python3 pipx
# pip3 install virtualenv virtualenvwrapper
# cat files/bash_profile_python_env >> ~/.bash_profile

# Install Go
# brew install go
# cat files/bash_profile_go_env >> ~/.bash_profile
# source ~/.bash_profile
# mcd ~/Projects\ Golang
# mkdir bin
# mkdir src
# echo "export GOPATH=\"$HOME/Projects Golang\"" >> ~/.bash_profile

# Config git (based on https://gist.github.com/scottnonnenberg/fefa3f65fdb3715d25882f3023b31c29)
gh config set editor "code -w"

git config --global user.name $git_name
git config --global user.email $git_email
git config --global core.editor "code --wait"

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.ff 'merge --ff-only'
git config --gloabl alias.undo 'reset --soft HEAD^'
git config --global alias.stash-all 'stash save --include-untracked'
git config --global alias.glog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

echo .DS_Store >> ~/.gitignore_global

# Finishing setup
brew doctor
