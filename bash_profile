#############################################################################################
# ENVIRONMENT CONFIGURATION
#############################################################################################

	# Change Prompt
	# link: https://www.thegeekstuff.com/2008/09/bash-shell-ps1-10-examples-to-make-your-linux-prompt-like-angelina-jolie/
	# export PS1="________________________________________________________________________________\n| \w @ \h (\u) \n: "
	# export PS1="\n\n| \w @ \h (\u) \n:"
	# export PS1="\n\d \A \w @ \h (\u) \n:"
	export PS1="\n: "
	export PS2="\n: "

	# Brew
	export PATH="/usr/local/sbin:$PATH"

#############################################################################################
# MAKE TERMINAL BETTER
#############################################################################################

	# mcd:          Makes new Dir and jumps inside
	mcd () { mkdir -p "$1" && cd "$1"; }     

	# trash:        Moves a file to the MacOS trash
	trash () { command mv "$@" ~/.Trash ; }  

	# ql:           Opens any file in MacOS Quicklook Preview
	ql () { qlmanage -p "$*" >& /dev/null; } 

	# mans:   Search manpage given in argument '1' for term given in argument '2' (case insensitive)
	# displays paginated result with colored search terms and two lines surrounding each hit.
	# Example: mans mplayer codec
	mans () {
		man $1 | grep -iC2 --color=always $2 | less
	}

	# showa: to remind yourself of an alias (given some part of it)
	showa () { 
		/usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; 
	}

	# chr: get the value ASCII of a number
	chr () {
		[ "$1" -lt 256 ] || return 1
		printf "\\$(printf '%03o' "$1")"
	}

	# ord: get the integer value of a ASCII
	ord () {
		LC_CTYPE=C printf '%d' "'$1"
	}

	# Preferred 'cp' implementation
	alias cp='cp -iv'                        

	# Preferred 'mv' implementation
	alias mv='mv -iv'                        

	# Preferred 'mkdir' implementation
	alias mkdir='mkdir -pv'                  

	# Preferred 'ls' implementation
	alias ll='ls -FGlAhp'                    

	# Preferred 'less' implementation
	alias less='less -FSRXc'                          

	# Go back 1 directory level
	alias ..='cd ../'                                                      

	# f:            Opens current directory in MacOS Finder
	alias f='open -a Finder ./'                                                              

	# which:        Find executables
	alias which='type -all'                  

	# path:         Echo all executable Paths
	alias path='echo -e ${PATH//:/\\n}'      

	# Show_options: display bash options settings
	alias show_options='shopt'               

	# fix_stty:     Restore terminal settings when screwed up
	alias fix_stty='stty sane'               

	# cic:          Make tab-completion case-insensitive
	alias cic='set completion-ignore-case On'          

	# DT:           Pipe content to file on MacOS Desktop
	alias DT='tee ~/Desktop/terminalOut.txt' 

	# lr:  Full Recursive Directory Listing
	alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#############################################################################################
# FILE AND FOLDER MANAGEMENT
#############################################################################################

	# zipf:         To create a ZIP archive of a folder
	zipf () { zip -r "$1".zip "$1" ; }    

	# extract:  Extract most know archives with one command
	extract () {
		if [ -f $1 ] ; then
		  case $1 in
			*.tar.bz2)   tar xjf $1     ;;
			*.tar.gz)    tar xzf $1     ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       unrar e $1     ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xf $1      ;;
			*.tbz2)      tar xjf $1     ;;
			*.tgz)       tar xzf $1     ;;
			*.zip)       unzip $1       ;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1        ;;
			*)     echo "'$1' cannot be extracted via extract()" ;;
			 esac
		 else
			 echo "'$1' is not a valid file"
		 fi
	}

	# numFiles:     Count of non-hidden files in current dir
	alias numFiles='echo $(ls -1 | wc -l)'

	# make1mb:      Creates a file of 1mb size (all zeros)
	alias make1mb='mkfile 1m ./1MB.dat'   

	# make5mb:      Creates a file of 5mb size (all zeros)
	alias make5mb='mkfile 5m ./5MB.dat'   

	# make10mb:     Creates a file of 10mb size (all zeros)
	alias make10mb='mkfile 10m ./10MB.dat'

	# cleanupDS:  Recursively delete .DS_Store files
	alias cleanupDS='find . -type f -name '*.DS_Store' -ls -delete'

	# finderShowHidden:   Show hidden files in Finder
	# finderHideHidden:   Hide hidden files in Finder
	alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
	alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

	# cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
	alias cleanupLS='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder'

	#  screensaverDesktop: Run a screensaver on the Desktop
	alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

#############################################################################################
# SEARCHING
#############################################################################################

	# ff:       Find file under the current directory
	ff () { /usr/bin/find . -name "$@" ; }

	# ffs:      Find file whose name starts with a given string
	ffs () { /usr/bin/find . -name "$@"'*' ; }

	# ffe:      Find file whose name ends with a given string
	ffe () { /usr/bin/find . -name '*'"$@" ; }

	# spotlight: Search for a file using MacOS Spotlight's metadata
	spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

	# qfind:    Quickly search for file
	alias qfind="find . -name "

#############################################################################################
# PROCESS MANAGEMENT
#############################################################################################

	# findPid: find out the pid of a specified process
	#       Note that the command name can be specified via a regex
	#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
	#     Without the 'sudo' it will only find processes of the current user
	findPid () { lsof -t -c "$@" ; }

	# my_ps: List processes owned by my user:
	my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

	# memHogsTop, memHogsPs:  Find memory hogs
	alias memHogsTop='top -l 1 -o rsize | head -20'
	alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

	# cpuHogs:  Find CPU hogs
	alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

	# topForever:  Continual 'top' listing (every 10 seconds)
	alias topForever='top -l 9999999 -s 10 -o cpu'

	# ttop:  Recommended 'top' invocation to minimize resources
	#       Taken from this macosxhints article
	#     http://www.macosxhints.com/article.php?story=20060816123853639
	alias ttop="top -R -F -s 10 -o rsize"

#############################################################################################
# NETWORK
#############################################################################################

	# ii:  display useful host related informaton
	ii() {
		echo -e "\nYou are logged on ${RED}$HOST"
		echo -e "\nAdditionnal information:$NC " ; uname -a
		echo -e "\n${RED}Users logged on:$NC " ; w -h
		echo -e "\n${RED}Current date :$NC " ; date
		echo -e "\n${RED}Machine stats :$NC " ; uptime
		echo -e "\n${RED}Current network location :$NC " ; scselect
		echo -e "\n${RED}Public facing IP Address :$NC " ;myip
		#echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
		echo
	}

	# myip:         Public facing IP Address
	alias myip='curl ip.appspot.com'

	# netCons:      Show all open TCP/IP sockets
	alias netCons='lsof -i'

	# flushDNS:     Flush out the DNS Cache
	alias flushDNS='dscacheutil -flushcache'

	# lsock:        Display open sockets
	alias lsock='sudo /usr/sbin/lsof -i -P'

	# lsockU:       Display only open UDP sockets
	alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'

	# lsockT:       Display only open TCP sockets
	alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'

	# ipInfo0:      Get info on connections for en0
	alias ipInfo0='ipconfig getpacket en0'

	# ipInfo1:      Get info on connections for en1
	alias ipInfo1='ipconfig getpacket en1'

	# openPorts:    All listening connections
	alias openPorts='sudo lsof -i | grep LISTEN'

#############################################################################################
# ICPC 
#############################################################################################

	# new_contest: Create a folder with many files for the contest           
	# Example: new_contest aula2
	new_contest () {
		mkdir $1
		cd $1
		touch {a..z}.cpp
		for f in {a..z}.cpp
		do
			echo "
			#include <bits/stdc++.h>
			using namespace std;

			#define FILL(X, V)           memset((X), (V), sizeof(X))
			#define SIZE(V)              int((V).size())
			#define FOR2(c,i,j) for(int(c)=(i),_MAX=(j);(c)<_MAX;(c)++)
			#define FOR(cont,max)        FOR2((cont), 0, (max))
			#define LOG(x)               (31 - __builtin_clz(x))
			#define W(x)                 cerr << \"\033[31m\" << #x << \"=\" << x << \"\033[0m\" << \"\n\";
			#define ii                   pair<int, int>
			#define ff                   first
			#define ss                   second
			#define oo                   1e9
			#define ep                   1e-9
			#define pb                   push_back

			typedef long long ll;
			typedef unsigned long long ul;

			int main() {
				ios::sync_with_stdio(false);
			}
			" > $f
		done
	}

	run () {
		if [ $# -eq 1 ]; then
			g++ -Wall -g -std=c++11 $1 && ./a.out
		else
			g++ -Wall -g -std=c++11 $1 && ./a.out < $2
		fi
	}

	# compile: compile with C++11 
	alias compile='g++ -Wall -g -stdc++=11'














