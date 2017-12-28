# cfg
#### shareable shell and editor config files
---
Install (needs to exist in home directory):
```
$ cd ~ && git clone git@github.com:evnp/cfg.git
```
Symlink config files in ~ (and create backups of existing config files):
```
$ cfg/link
```
Remove symlinks and restore original config files from backups:
```
$ cfg/unlink
```
Install Vim plugins (from inside vim):
```
:PlugInstall!
```
