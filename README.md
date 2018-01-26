# nakal's shell configuration

What is being configured here? Click on the links to see details
about the configuration done for the specific piece of software.

* shells:
	* [tcsh](shell/tcsh/.cshrc)
	* [zsh](shell/zsh)
		* custom prompt theme with Git integration
* editors:
	* [vim](vim)
		* advanced configuration for developers
* version control system:
	* [git](git/README.md)
* mail:
	* [neomutt](mutt/README.md)
		* lynx and urlview integration
* utils:
	* (ex)ctags
	* git
	* tmux
	* uncrustify
* syscons (FreeBSD)
	* keymap file with swapped ESC and CAPSLOCK

## Small warning

The setup script used here will modify configurations and startup files
in your home directory. Please be aware of this fact!

I tried my best to avoid dangerous operations during the setup and operation
phases (see below), but I cannot tell for sure if there are systems or hosts
that can be damaged by the actions executed there.

When you start `setup.sh`, it will perform many safety checks not to destroy
important data.

## Installation instructions

For those who read the warnings above proceed with these steps:

0. **Make a backup of your $HOME**
1. Clone the project.
2. When you have FreeBSD, you can directly execute the script
   `setup.sh`. If you are not on FreeBSD, you will need
   to check the dependencies by yourself and comment out the
   `pkg info` check at the beginning of the script.

## Managed software configurations

The configuration is fully managed in [git](http://git-scm.com).

All the configurations included are softlinks. It means that you can update
them and you implicitly update the checked out project. This also implies
that it might be a good idea to make yourself a fork of this project. But
you can also merge in changes from my repository, but don't complain, if
something breaks for you. You should consider this project my private
playground.
