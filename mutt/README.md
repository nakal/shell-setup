# shell-setup: Mutt

This [mutt](http://www.mutt.org/) configuration is a part of the entire
configuration suite named [shell-setup](https://github.com/nakal/shell-setup).
It is not meant to be run standalone.

[mutt](http://www.mutt.org/) is the default email client (MUA) for this
configuration. You can easily get it integrated to start within the
[xmonad configuration](https://github.com/nakal/xmonad-conf) by adding this
line to the host-specific configuration (in `autostartPrograms`):

```
("xterm", ["-title", "mutt", "-e", "sh", "-c", "'tmux has-session -t mutt && tmux -2 attach-session -d -t mutt || tmux -2 new-session -s mutt mutt'"])
```

## Local configuration

To use mutt, you still need a further configuration file in
`~/.mutt/local.muttrc` with the following entries that vary from host
to host.

```
set realname="My Full Name"
set from="My Full Name <my.email@server.org>"
set folder="imaps://imap.server.org"
set spoolfile="imaps://USERNAME:PASSWORD@imap.server.org/"
set smtp_url="smtps://USERNAME:PASSWORD@smtp.server.org/"
set pgp_sign_as=WWXXYYZZ
mailboxes imaps://imap.server.org/INBOX
mailboxes imaps://imap.server.org/INBOX/Mailinglist
[...]
```

## Colors for mutt

The colorscheme for mutt is in `~/.mutt/colors.muttrc`. It mostly tries to
simulate the colors from atom-dark.

## Further features

* integrates vim as editor to write emails
* integrates GNUpg and GPG-Agent in a unannoying way
* integrates `abook`
* Trash is a trash folder, mails won't be simply deleted
* caching enabled
* some special bindings
	* a few hacks for the sidebar patch
		* `Ctrl+Up` and `Ctrl+Down`  move the folder selection
		* `Ctrl+Right` selects the folder
	* `Backspace` goes back to INBOX
	* `Backslash` goes to a mailbox with unread mail
	* learning of spams and hams (the backend is not open source, sorry)
		* `X` moves the current mail to the folder `INBOX.Spam.LearnSpam`
		* `H` moves the current mail to the folder `INBOX.Spam.LearnHam`
