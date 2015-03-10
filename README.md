# nakal's shell configuration

What is being configured here?

* shells:
	* tcsh
	* zsh
		* custom prompt theme with Git integration
* editors:
	* vim
* version control system:
	* git
* utils:
	* tmux
	* indent

## Small warning

**Please be careful using this project. I cannot be hold responsible for any
damages that might occur. If you are not sure, STOP and DON'T USE anything
here.**

I tried my best to avoid dangerous operations during the setup and operation
phases (see below), but I cannot tell for sure if there are systems or hosts
that can be damaged by the actions executed there.

**TAKE A GOOD LOOK WHAT IS BEING DONE AND MAKE SURE THAT EVERYTHING IS
REASONABLE IN YOUR CASE! AND I MEAN E-V-E-R-Y-T-H-I-N-G!!**

## Installation instructions

If, at this point, you already don't understand something, give up please
before doing any damage.

For those who read the warnings above and have confidence that I am not
doing any harm, proceed with these steps:

0. **Make a backup of your $HOME**
1. Clone the project.
2. When you have FreeBSD, you can directly execute the script
   `setup.sh`. If you are not on FreeBSD, you will need
   to check the dependencies by yourself and comment out the
   `pkg info` check at the beginning of the script.

## Features and gotchas

The configuration is fully managed in [git](http://git-scm.com).

All the configurations included are softlinks. It means that you can update
them and you implicitly update the checked out project. This also implies
that it might be a good idea to make yourself a fork of this project. But
you can also merge in changes from my repository, but don't complain, if
something breaks for you. You should consider this project my private
playground.
