# .vimrc

This is my custom .vimrc file.

## Change .vimrc file path

### Pattern1. symbolic link

This is very simple way to change .vimrc file path.

```
ln -s /path/to/this/dir/.vimrc ~/.vimrc
```

### Pattern2. environment Variables

Set the followings to the end of ~/.bashrc file.

```
export VIMINIT='source /path/to/this/dir/.vimrc'
export MYVIMRC=/path/to/this/dir/.vimrc
```

