# fj.sh

`fj.sh` is a minimalist command-line task manager and runner. It allows you to set up shell functions for running tasks scoped to a local directory, and run them easily by using the shortcut `fj mytask`.

# Install

To install it, just clone the repository and add a symbolic link name `fj` to `src/fj.sh`:

```sh
git clone --depth 1 https://github.com/gutomotta/fj.sh.git ~/.fj.sh
ln -s ~/.fj.sh/src/fj.sh /usr/local/bin/fj
chmod u+x /usr/local/bin/fj
```

If you have ever added `~/bin/` to your `PATH`, you can optionally change `/usr/local/bin/fj` by `~/bin/fj`.

# Update

For now, the only way to update this is by pulling the latest version from GitHub:

```sh
cd ~/.fj.sh
git pull origin master
```

# Uninstall

Simply remove the repo (and the symbolic link to the executable) from your machine:

```sh
rm -rf ~/.fj.sh /usr/local/bin/fj
```

# Usage

To use it:

1. In the root of some repo, create a `fj.sh` file.
2. Add functions to it to perform common development tasks you usually need to run from your shell. From now on, we'll call those functions "tasks".
3. Run them by invoking `fj mytask` from the repo root.

## Example

Take a look at an example local `fj.sh` file:

```sh
#!/bin/bash

up() (
    docker compose up -d
)

down() (
    docker compose down
)

# it also works with function arguments!
test() (
    python -m unittest "$@"
)
```

In this example, you could run `fj up` from your project root instead of `docker compose up -d`. Moreover, you can pass arguments to your tasks (for instance, you can run `fj test test/test_users.py`).

Try it yourself!

## Meta-tasks

`fj.sh` has some built-in "meta-tasks". Those are special tasks you can run to help you manage your repo's tasks. These are the meta-tasks available currently:

| Meta-task  | Description                                      | Long form      | Short form |
|------------|--------------------------------------------------|----------------|------------|
| List tasks | Lists all tasks available in your `fj.sh` file.  | `fj --list`    | `fj -l`    |
| Help       | Shows usage message.                             | `fj --help`    | `fj -h`    |
| Version    | Prints current version of the `fj.sh` executable | `fj --version` | `fj -v`    |

A side-note: tasks and meta-tasks can only be run from a directory where there's a `fj.sh` file available.

# FAQ
## Why?

I was talking to [@flaviokr](https://github.com/flaviokr), and we realized every project we build needs some command-line utilities to be run rather frequently during the development process. We tried different approaches to organize local tasks and define useful aliases shared that we could share with the rest of the team, but none felt quite right. We wanted a minimal tool that made it easy to define functions or scripts that were scoped by repository, so we decided to build one.

## Isn't this just like [some-other-project]?

Maybe. We looked around a bit before starting to develop our own local task manager, but haven't found a tool that fully convinced us. But we're pretty sure somebody out there has built something like `fj.sh`. We just figured it wouldn't be too challenging to build one just the way we wanted. Also, it seemed fun.

## Are you remaking GNU Make?

Not at all—this aims to be a much simpler project. Many developers, including us, have used GNU Make to set up local tasks, but that is harder than simply writing shell functions because the tool is not designed for that purpose.
