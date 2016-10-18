#	Brew Essencial
#	run using command sh `inst.sh`


# Get a brew on

	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install ruby #upgrade ruby

# Set up

	brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup
	brew install repo


# Get some tap

	brew install caskroom/cask/brew-cask
	brew tap caskroom/versions
	brew tap homebrew/science
	brew tap homebrew/dupes
	brew tap homebrew/core
	brew tap caskroom/cask
	brew tap caskroom/version

# Command Line

	# Git
	brew install git
	git --version
	git config --global user.name "Claudio Segala Rodrigues Silva Filho"
	git config --global user.email "claudiosegalafilho@gmail.com"
	git config -l
	brew install git-crypt 	# to support automatic encryption on pushing to git

	# GCC
	brew install gcc

	# CUnit
	brew install cunit

	# Node / NPM
	brew install node
	brew install npm

# Utilities
	

	# 
	brew install nam

	# 
	brew install automake

	# 
	brew install autoconf

	# 
	brew install count

	# 
	brew install gettext

	# 
	brew install gap

	# 
	brew install isl

	# 
	brew install clove

	# 
	brew install libgpg-error

	# 
	brew install linksba

	# 
	brew install limbic

	# 
	brew install lib tool

	# 
	brew install libyaml

	# 
	brew install mfr

	# 
	brew install nurses

	# 
	brew install pig-config

	# 
	brew install readline

	# SQLite
	brew install sqlite

	# 
	brew install ssh-copy-id

	# supports the awesome mmd formatting system
	brew install multi markdown
	
	# Vim
	brew install vim --override-system-vi
	
	#  gives you v4, a more modern version (note you need to add it to approved shells and use chsh to switch to it
	brew install bash
	
	# excellent escape command completion for bash
	brew install bash-completion


	# gives you network bandwidth measurement
	brew install speedtest_cli
	
	#for simple high speed file transfer
	brew install wget

	# Open SSH
	brew install openssh

	# Make to unite libraries
	brew install make


# Apps
	
	#  Sublime 3
	brew cask install sublime-text3;
	
	# Atom
	brew cask install atom;
	
	# Google Chrome
	brew cask install google-chrome;

	# Chromium
	brew cask install chromium

	# Firefox
	brew cask install firefox

	# Google Drive
	brew cask install google-drive
	
	# VLC
	brew cask install vlc;
	
	# Skype
	brew cask install skype;
	
	# Dropbox
	brew cask install dropbox;
	
	# Utorrent
	brew cask install utorrent;
	
	# Popcorn Time
	brew tap popcorn-time/homebrew-cask https://git.popcorntime.io/caskroom/homebrew-cask.git;
	brew cask install popcorn-time;
	
	# Virtualbox
	brew cask install virtualbox;
	
	# Docker Machine
	brew install docker-machine;
	
	# Slack
	brew cask install slack;

	# Spotify
	brew cask install spotify

	# Wunderlist
	brew cask install wunderlist

	# Unarquiver
	brew cask install the-unarchiver

	# AppCleaner
	brew cask install appcleaner
 
	# Team Viewer
	brew cask install teamviewer

	# Aquamacs
	brew cask install aquamacs

	# Gimp
	brew cask install gimp

	# Android File Transfer
	brew cask install android-file-transfer

	# Whatsapp
	brew cask install whatsapp

	# Telegram
	brew cask install telegram


# Languages

	# Stylus
	npm install stylus -g

	# Elm
	brew install elm 

	# PostgresSQL
	brew install postgresql

	# Elixir
	brew install elixir

	# Phoenix
	mix local.hex
	createuser -d postgres
	mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.0.3/phoenix_new-1.0.3.ez
	   		
	# Java
	brew update
	brew cask install java
	
	# Haskell

	# Python 3
	brew install python 		
	sudo easy_install pip

	# My SQL
	brew install mariadb
	mysql_install_db
	/usr/local/bin/mysql_secure_installation

	# RVM
	\curl -L https://get.rvm.io | bash -s stable
	source ~/.bach_profile
	rvm | head -n 1
	rvm use ruby --install --default
	ruby -v
	gem install rails --no-ri --no-rdoc
	rails --version
 
# Finishing Brew

	brew update
	brew upgrade
	brew cleanup
	brew doctor

#-------------------------
# Bash Configuracion

# Put all this inside the bash_profile

# [[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM$

# alias cognin="clear && cd && cd Git/front-end && sublime ."
# alias codetime="clear && cd && cd Dropbox/Code && sublime ."
# alias uri="clear && cd && cd Dropbox/Code/URI"
# alias uva="clear && cd && cd Dropbox/Code/UVa"
# alias codeforces="clear && cd && cd Dropbox/Code/Codeforces"
# alias compile="clear && g++ -Wall -std=c++11 -g -O2 -o code"
# alias run="time ./code < in"
# alias setting="nano ~/.bash_profile && clear && source ~/.bash_profile"

# echo "Tips for better use"
# echo "cognin - to open cognin"
# echo "codetime - to get to the right folder and open sublime"
# echo "uri - to get to uri folder"
# echo "uva - to get to uva folder"
# echo "codeforces - to get to codeforces folder"
# echo "compile -  to compile in C++"
# echo "run - to get your code running and get the input from in"
# echo "setting - to modify bash"




