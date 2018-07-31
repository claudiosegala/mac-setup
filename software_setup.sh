#############################################################################################
#Set up folders
#############################################################################################

	# Set Git Projects folder
	cd
	mkdir Projects

#############################################################################################
#Brew Setup
#############################################################################################

	# Get a brew on
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	# Get some tap repositories
	brew tap caskroom/versions
	brew tap homebrew/services
	brew tap homebrew/core
	brew tap caskroom/cask

	# Set up
	brew update
	brew cleanup
	brew cask cleanup
	brew install repo
	echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
	brew doctor

#############################################################################################
#Git Setup
#############################################################################################

	# Git Install
	brew install git
	git --version
	# git config --global user.name "Your name"
	# git config --global user.email "Your Email"
	git config -l
	brew install git-crypt 	#to support automatic encryption on pushing to git

#############################################################################################
#Command Line Setup
#############################################################################################

	# GCC
	brew install gcc

	# CUnit
	brew install cunit

	# Install Latex
	brew cask install texmaker

	# Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages
	brew install autoconf

	# Automake is a tool for automatically generating Makefile.in files compliant with the GNU Coding Standards
	brew install automake

	# the GNU `gettext' utilities are a set of tools that provides a framework to help other GNU packages produce multi-lingual messages
	brew install gettext

	# Library for manipulating sets and relations of integer points bounded by linear constraints
	brew install isl

	# Libgpg-error is a small library that defines common error values for all GnuPG components
	brew install libgpg-error

	# YAML 1.1 parser and emitter written in C
	# brew install libyaml

	# Library that provides a set of functions for use by applications that allow users to edit command lines as they are typed in
	brew install readline

	# The main OpenSSH page
	brew install ssh-copy-id

	# Supports the awesome mmd formatting system
	# brew install multimarkdown

	# Vim
	brew install vim --with-override-system-vi

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

	# Heroku
	# brew install heroku
	# heroku --version
	# heroku login

#############################################################################################
#Programming Languages Setup
#############################################################################################

	# Ruby
	brew install ruby

	# Python 3
	brew install python  # 2.7
	brew install python3 # 3
	sudo easy_install pip

	# Node / NPM
	brew install node
	brew install npm
	brew install yarn

	# Go
	# brew install go

	# Rust
	# brew install rust

	# Haskell
	# brew cask install haskell-platform

	# Java
	# brew update
	# brew cask install java

	# SQL
	brew install mysql # MySQL
	# brew install sqlite # SQLite
	# brew install postgresql # PostgresSQL

	# Stylus
	# npm install stylus -g

	# Elm
	# brew install elm

	# RVM - Rails
	# \curl -L https://get.rvm.io | bash -s stable
	# osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down'
	# rvm | head -n 1
	# rvm use ruby --install --default
	# rails --version
	# gem install devisegem install rails --no-ri --no-rdoc
	# gem install compass
	# gem install jekyll
	# gem install binding_of_caller
	# gem install devise
	# gem install cancancan
	# gem install cucumber-rails
	# gem install rspec-rails
	# gem install capybara
	# gem install simplecov
	# gem install rubocop
	# gem install rolify
	# gem install factory_girl
	# gem install factory_girl_rails
	# gem install pry-rails
	# gem install pry-byebug
	# gem install better_errors
	# gem install rspec-rails
	# gem install carrierwave
	# gem install mini_magick
	# gem install sidekiq
	# gem install sucker_punch
	# gem install simple_form
	# gem install elasticsearch
	# gem install brakeman
	# gem install database_cleaner
	# brew install imagemagick		

	# Elixir
	# brew install erlang
	# brew install elixir

	# Phoenix
	# mix local.hex
	# mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

#############################################################################################
#Apps Setup
#############################################################################################

	#  Sublime 3
	brew cask install sublime-text
	ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime # isso permite chamar o sublime pelo terminal

	# Atom
	# brew cask install atom

	# Aquamacs
	# brew cask install aquamacs

	# Google Chrome
	brew cask install google-chrome

	# Chromium
	# brew cask install chromium

	# Firefox
	# brew cask install firefox

	# Google Backup and Sync
	brew cask install google-backup-and-sync

	# Android File Transfer
	brew cask install android-file-transfer

	# Dropbox
	# brew cask install dropbox

	# VLC
	brew cask install vlc

	# Spotify
	brew cask install spotify

	# Unarquiver
	brew cask install the-unarchiver

	# AppCleaner
	brew cask install appcleaner

	# Skype
	brew cask install skype

	# Slack
	brew cask install slack

	# Whatsapp
	brew cask install whatsapp

	# Telegram
	brew cask install telegram

	# Cakebrew
	# brew cask install cakebrew

	# Team Viewer
	# brew cask install teamviewer

	# Gimp
	# brew cask install gimp

	# Utorrent
	# brew cask install utorrent

	# Virtualbox
	# brew cask install virtualbox

	# Docker Machine
	# brew install docker-machine

#############################################################################################
#Brew Final Setup
#############################################################################################

	# Finishing setup
	brew update
	brew upgrade
	brew cleanup
	brew doctor

#############################################################################################
#Finish
#############################################################################################

	# Close Window
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "w" using command down' &&
