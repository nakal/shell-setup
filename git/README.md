# shell-setup: Git

This [Git](https://git-scm.com/) configuration is a part of the
entire configuration suite named
[shell-setup](https://github.com/nakal/shell-setup).
It is not meant to be run standalone.

[Git](https://git-scm.com/) is a core application within the
configuration itself and it is critical to keep the entire configuration
system working.

## Local configuration

Git includes the configuration in `~/.gitconfig_local`, if the file exists.
It is a good idea to setup at least:

```
[user]
	name = Full Name
	email = my.email@server.org
```

## Global excludes (ignores)

In `~/.gitignore_global`, it is possible to specify some patterns to ignore
in every project and avoid repetitions. The format is same like in
`.gitignore`.

## Further features

* integrates vim
* uses colors
* refreshes ctags and cscope with hooks
