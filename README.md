# cfg
#### shareable shell and editor config file management
---
Install (needs to exist in home directory):
```
$ cd ~ && git clone git@github.com:evnp/cfg.git
```
Create a `cfg-files` dir and place config files there. Or (recommended) add your config files to a repo and clone it inside `cfg`, then rename the directory `cfg-files` (unless the repo is named `cfg-files`). E.g.:
```
$ cd ~/cfg && git clone git@github.com:evnp/cfg-files.git
```
Symlink config files in ~ (and create backups of existing config files):
```
$ ~/cfg/link
```
Remove symlinks and restore original config files from backups:
```
$ ~/cfg/unlink
```
Install Vim plugins (from inside vim):
```
:PlugInstall!
```
