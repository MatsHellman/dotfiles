# My simple dotfiles

> Mats Hellman | July 23rd 2025  

This repository contains my very simple dotfiles I use in my Linux installations.  
There are thousands and thousands of these repos on Github, but this one is mine, just like in the old great movie by Stanley Kubrik.  
Everyone needs their own repo to have their personal preferences. If you find something you can use here, good for you, don't hold any issues against me.  

## Managing my dotfiles

The repo contains dotfiles I use for my setup and the script sync-dotfiles.sh is used sync the files based on their git status to the local system.
All settings are in folder for that specific application and is using the following rules:

- The folder name is used in the script as well so name you top folder according to your application you define settings for.
- In a app folder I store all config files without the dot prefix even if it is used normally, like .bashrc is bash/bashrc
- Every application folder contains a .env file defining how and where to place the file in the local system.

### Example .env file

```bash
MODE=COPY
TARGETS=(
    "~/.tmux.conf"
)
```

In the .env file you can set the mode to COPY or SYMLINK, this will define how the file is handled by the script. I use both so for some of my files when I edit them they are
 immediately used by the system.

## Running the sync-dotfiles

When you run the sync dotfiles there are a few options available.

### Default run

By default if you run the script without any options it will only process the files that changed.

```bash
./sync-dotfiles.sh
```

### Run without changes

Runing without doing any changes you can use the option **--dryrun**

```bash
./sync-dotfiles.sh --dryrun
```

### Redo all configuration files even if gitstatus hasn't changed

Running with the option **--all**

```bash
./sync-dotfiles.sh --all
```
