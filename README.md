# fj.sh

`fj.sh` is a minimalist command-line task runner for your projects. It allows you to set up shell functions for running tasks scoped to a local directory and run them easily by using the the shortcut `'fj mytask'`.

# Installation

To install it, just clone the repository and add a symbolic link name `fj` to `src/fj.sh`:

```sh
git clone --depth 1 https://github.com/gutomotta/fj.sh.git ~/.fj.sh
ln -s ~/.fj.sh/src/fj.sh /usr/local/bin/fj
```

If you have ever added `~/bin/` to your `PATH`, you can optionally change `/usr/local/bin/fj` by `~/bin/fj`.

# Updating

For now, the only way to update this is by pulling the latest version from github:

```sh
cd ~/.fj.sh
git pull origin master
```

# Usage

To use it:

1. In the root of some repo, create a `fj.sh` file
2. Add functions to it to perform common development tasks you usually need to run from your shell
3. Run them by invoking `fj mytask`

## Example

Take a look at an example local `fj.sh` file:

```sh
# fj.sh
#!/bin/bash

up() (
    docker compose up -d
)

down() (
    docker compose down
)
```

In this example, you could run `fj up` from your project root instead of `docker compose up -d`.

Go try it yourself!

# FAQ
## Why?

I was talking to @flaviokr and we figured every project we build needs some command-line utilities to be run quite often during the development process. We have tried some different approaches to defining local tasks but none felt quite right. We needed a minimal tool that defined a simple pattern for us to define functions or scripts scoped to each repository so that we could use it in all our other projects, so we decided to build it.

## Isn't this just like [some-other-project]?

Maybe. I looked around a bit before starting to develop my own local task manager, but haven't found a tool that fully convinced me. But I'm pretty sure somebody out there has built something like `fj.sh`. I just figured it wouldn't be too hard to build one just the way I wanted it, and also it seemed fun.

## Are you remaking GNU Make?

No. In fact, this aims to be a much simpler project. GNU Make is a very powerful tool, but it is originally designed to generate executables from source files, not executing local tasks associated with your git repository. I used GNU Make for setting up local tasks many times, but that was always harder than just writing shell functions, because the tool wasn't designed for that purpose.
