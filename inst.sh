#	Brew Essencial
#	run using command `sh inst.sh`

# Get a brew on

	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install ruby

# Get some tap

	brew install caskroom/cask/brew-cask
	brew tap caskroom/versions
	brew tap homebrew/science
	brew tap homebrew/dupes
	brew tap homebrew/core
	brew tap caskroom/cask

# Set up

	brew update
	brew upgrade brew-cask
	brew cleanup
	brew cask cleanup
	brew install repo
	echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
	brew doctor

# Command Line

	# Git
	brew install git
	git --version
	# git config --global user.name "Your name"
	# git config --global user.email "Your Email"
	git config -l
	brew install git-crypt 	# to support automatic encryption on pushing to git

	# GCC
	brew install gcc

	# CUnit
	brew install cunit

	# Node / NPM
	brew install node
	brew install npm
	npm install -g grunt-cli

# Utilities

	# Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages
	brew install autoconf

	# Automake is a tool for automatically generating Makefile.in files compliant with the GNU Coding Standards
	brew install automake

	# the GNU `gettext' utilities are a set of tools that provides a framework to help other GNU packages produce multi-lingual messages
	brew install gettext

	# System for computational discrete algebra
	brew install gap

	# Library for manipulating sets and relations of integer points bounded by linear constraints
	brew install isl

	# Libgpg-error is a small library that defines common error values for all GnuPG components
	brew install libgpg-error

	# YAML 1.1 parser and emitter written in C
	brew install libyaml

	# Library that provides a set of functions for use by applications that allow users to edit command lines as they are typed in
	brew install readline

	# The main OpenSSH page
	brew install ssh-copy-id

	# Supports the awesome mmd formatting system
	brew install multimarkdown

	# Vim
	brew install vim --override-system-vi

	# Gives you v4, a more modern version (note you need to add it to approved shells and use chsh to switch to it
	brew install bash

	# Excellent escape command completion for bash
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
	brew cask install sublime-text
	ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime # isso permite chamar o sublime pelo terminal

	# Atom
	brew cask install atom

	# Google Chrome
	brew cask install google-chrome

	# Chromium
	brew cask install chromium

	# Firefox
	brew cask install firefox

	# Google Drive
	brew cask install google-drive

	# VLC
	brew cask install vlc

	# Skype
	brew cask install skype

	# Dropbox
	brew cask install dropbox

	# Utorrent
	brew cask install utorrent

	# Virtualbox
	brew cask install virtualbox

	# Docker Machine
	brew install docker-machine

	# Slack
	brew cask install slack

	# Spotify
	brew cask install spotify

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

	# SQLite
	brew install sqlite

	# Elixir
	brew install erlang
	brew install elixir

	# Phoenix
	mix local.hex
	mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

	# Java
	brew update
	brew cask install java

	# Haskell
	brew cask install haskell-platform

	# Python 3
	brew install python  # 2.7
	brew install python3 # 3
	sudo easy_install pip

	# My SQL
	brew install mysql

	# RVM
	\curl -L https://get.rvm.io | bash -s stable
	osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down'
	rvm | head -n 1
	rvm use ruby --install --default
	ruby -v
	gem install rails --no-ri --no-rdoc
	gem install compass
	gem install jekyll
	gem install binding_of_caller
	gem install devise
	gem install cucumber-rails
	gem install rspec-rails
	gem install factory_girl_rails
	gem install pry-rails
	gem install simple_form
	brew install imagemagick		
	
	rails --version
	osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "w" using command down'

# Finishing Brew

	brew update
	brew upgrade
	brew cleanup
	brew doctor
	
# THIS SECTION IS FOR MAC CURIOSITIES
# 1 - In Terminal, type "emacs" then command+X and then type "tetris", have fun
# 2 - In Terminal, type "emacs" then command+X and then type "doctor", feel free to let it all out
