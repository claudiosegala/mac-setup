#	Brew Essencial

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
	
	# Heroku
	brew install heroku
	heroku --version
	heroku login

	# RVM
	\curl -L https://get.rvm.io | bash -s stable
	osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down'
	rvm | head -n 1
	rvm use ruby --install --default
	ruby -v
	gem install devisegem install rails --no-ri --no-rdoc
	gem install compass
	gem install jekyll
	gem install binding_of_caller
	gem install devise
	gem install cancancan
	gem install cucumber-rails
	gem install rspec-rails
	gem install capybara
	gem install simplecov
	gem install rubocop
	gem install rolify
	gem install factory_girl
	gem install factory_girl_rails
	gem install pry-rails
	gem install pry-byebug
	gem install better_errors
	gem install rspec-rails
	gem install carrierwave
	gem install mini_magick
	gem install sidekiq
	gem install sucker_punch
	gem install simple_form
	gem install elasticsearch
	gem install brakeman
	gem install database_cleaner
	brew install imagemagick		
	rails --version

# Finishing Brew

	brew update
	brew upgrade
	brew cleanup
	brew doctor
	
# Set Up bits/stdc++

	cd
	cd ../../usr/local/include
	mkdir bits
	cd bits
	touch stdc++.h
	echo "// C++ includes used for precompiling -*- C++ -*-

	// Copyright (C) 2003-2013 Free Software Foundation, Inc.
	//
	// This file is part of the GNU ISO C++ Library.  This library is free
	// software; you can redistribute it and/or modify it under the
	// terms of the GNU General Public License as published by the
	// Free Software Foundation; either version 3, or (at your option)
	// any later version.

	// This library is distributed in the hope that it will be useful,
	// but WITHOUT ANY WARRANTY; without even the implied warranty of
	// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	// GNU General Public License for more details.

	// Under Section 7 of GPL version 3, you are granted additional
	// permissions described in the GCC Runtime Library Exception, version
	// 3.1, as published by the Free Software Foundation.

	// You should have received a copy of the GNU General Public License and
	// a copy of the GCC Runtime Library Exception along with this program;
	// see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
	// <http://www.gnu.org/licenses/>.

	/** @file stdc++.h
	 *  This is an implementation file for a precompiled header.
	 */

	// 17.4.1.2 Headers

	// C
	#ifndef _GLIBCXX_NO_ASSERT
	#include <cassert>
	#endif
	#include <cctype>
	#include <cerrno>
	#include <cfloat>
	#include <ciso646>
	#include <climits>
	#include <clocale>
	#include <cmath>
	#include <csetjmp>
	#include <csignal>
	#include <cstdarg>
	#include <cstddef>
	#include <cstdio>
	#include <cstdlib>
	#include <cstring>
	#include <ctime>

	#if __cplusplus >= 201103L
	#include <ccomplex>
	#include <cfenv>
	#include <cinttypes>
	#include <cstdbool>
	#include <cstdint>
	#include <ctgmath>
	#include <cwchar>
	#include <cwctype>
	#endif

	// C++
	#include <algorithm>
	#include <bitset>
	#include <complex>
	#include <deque>
	#include <exception>
	#include <fstream>
	#include <functional>
	#include <iomanip>
	#include <ios>
	#include <iosfwd>
	#include <iostream>
	#include <istream>
	#include <iterator>
	#include <limits>
	#include <list>
	#include <locale>
	#include <map>
	#include <memory>
	#include <new>
	#include <numeric>
	#include <ostream>
	#include <queue>
	#include <set>
	#include <sstream>
	#include <stack>
	#include <stdexcept>
	#include <streambuf>
	#include <string>
	#include <typeinfo>
	#include <utility>
	#include <valarray>
	#include <vector>

	#if __cplusplus >= 201103L
	#include <array>
	#include <atomic>
	#include <chrono>
	#include <condition_variable>
	#include <forward_list>
	#include <future>
	#include <initializer_list>
	#include <mutex>
	#include <random>
	#include <ratio>
	#include <regex>
	#include <scoped_allocator>
	#include <system_error>
	#include <thread>
	#include <tuple>
	#include <typeindex>
	#include <type_traits>
	#include <unordered_map>
	#include <unordered_set>
	#endif" >> stdc++.h

	
# Close window

	osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "w" using command down'
	
# THIS SECTION IS FOR MAC CURIOSITIES
# 1 - In Terminal, type "emacs" then command+X and then type "tetris", have fun
# 2 - In Terminal, type "emacs" then command+X and then type "doctor", feel free to let it all out
