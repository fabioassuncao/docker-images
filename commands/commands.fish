# This script was modified by Fábio Assunção <fabio23gt@gmail.com>
# Date 2018-02-12
# See the original in https://github.com/codecasts/ambientum/blob/master/commands.fish

# where the codions cache will live
set	A_BASE		$HOME/.cache/codions

# define specific cache directories
set	A_CONFIG    $A_BASE/.config
set	A_CACHE	    $A_BASE/.cache
set	A_LOCAL	    $A_BASE/.local
set A_SSH		$HOME/.ssh
set A_COMPOSER  $A_BASE/.composer

# create directories
mkdir -p $A_CONFIG
mkdir -p $A_CACHE
mkdir -p $A_LOCAL
mkdir -p $A_COMPOSER

# Reset permissions
chown -R $(whoami) $A_BASE
# chown -R $(whoami):$(whoami) $A_BASE

# home directory
set A_USER_HOME /home/codions


####
# alias for NPM And other node commands
####

# node Env
function n
	docker run -it --rm -v (pwd):/var/www/app -v $A_CONFIG:$A_USER_HOME/.config -v $A_CACHE:$A_USER_HOME/.cache -v $A_LOCAL:$A_USER_HOME/.local -v $A_SSH:$A_USER_HOME/.ssh codions/nodejs:9 $argv
end

# php Env
function p
	docker run -it --rm -v (pwd):/var/www/app -v $A_COMPOSER:$A_USER_HOME/.composer -v $A_CONFIG:$A_USER_HOME/.config -v $A_CACHE:$A_USER_HOME/.cache -v $A_LOCAL:$A_USER_HOME/.local -v $A_SSH:$A_USER_HOME/.ssh codions/php:7.1 $argv
end