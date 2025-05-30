# fj.sh

`fj.sh` is a minimalist command-line task manager and runner. It allows you to set up
shell functions for running tasks scoped to a local directory, and run them easily by
using the shortcut `fj mytask`.

# Install

To install it, just clone the repository and add a symbolic link name `fj` to
`src/fj.sh`:

```bash
git clone --depth 1 https://github.com/gutomotta/fj.sh.git ~/.fj.sh
ln -s ~/.fj.sh/src/fj.sh /usr/local/bin/fj
chmod u+x /usr/local/bin/fj
```

If you have ever added `~/bin/` to your `PATH`, you can optionally change
`/usr/local/bin/fj` by `~/bin/fj`.

# Update

For now, the only way to update this is by pulling the latest version from GitHub:

```bash
cd ~/.fj.sh
git pull origin master
```

# Uninstall

Simply remove the repo (and the symbolic link to the executable) from your machine:

```bash
rm -rf ~/.fj.sh /usr/local/bin/fj
```

# Usage

To use it:

1. In the root of some repo, create a `fj.sh` file.
2. Add functions to it to perform common development tasks you usually need to run from
   your shell. From now on, we'll call those functions "tasks".
3. Run them by invoking `fj mytask` from the repo root.

## Example

Take a look at an example local `fj.sh` file:

```bash
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

In this example, you could run `fj up` from your project root instead of `docker compose
up -d`. Moreover, you can pass arguments to your tasks (for instance, you can run `fj
test test/test_users.py`).

Try it yourself!

## Meta-tasks

`fj.sh` has some built-in "meta-tasks". Those are special tasks you can run to help you
manage your repo's tasks. These are the meta-tasks available currently:

| Meta-task  | Description                                      | Long form      | Short form |
|------------|--------------------------------------------------|----------------|------------|
| List tasks | Lists all tasks available in your `fj.sh` file.  | `fj --list`    | `fj -l`    |
| Help       | Shows usage message.                             | `fj --help`    | `fj -h`    |
| Version    | Prints current version of the `fj.sh` executable | `fj --version` | `fj -v`    |

A side-note: tasks and meta-tasks can only be run from a directory where there's a
`fj.sh` file available.

# Utils

`fj.sh` includes a small set of built-in utilities designed to facilitate the development
of shell scripts. All utilities are automatically imported and available for any task you
define.

Please note that using such utilities will break the property of your fj.sh file being
copy-pasteable for non-fj.sh users. In other words, using any of those utilities will
require anyone willing to run your fj.sh tasks to either have fj.sh installed or make
changes to your script before pasting it into their shell. That said, this is an opt-in
feature, so feel free to ignore it if you prefer to keep your tasks more pure shell.

## Available Utilities

### _fj_log
Prints messages with optional indentation. End messages with a whitespace to avoid
trailing newlines.

```bash
task_with_logging() (
    _fj_log "Starting task..."
    FJ_LOG_INDENT=1 _fj_log "Indented message"
    _fj_log "Task almost complete. " # trailing space to avoid trailing newline
    _fj_log "Task complete." # this will have a trailing newline
)
```

### _fj_confirm
Prompts the user for confirmation before proceeding. If the user answers anything other
than "y", the task will exit. 

The first argument (required) is the question to ask, and the second argument (optional)
is the message to display if the user answers anything besides "y".

```bash
dangerous_task() (
    _fj_confirm "This will delete all temporary files" "Cancelled file deletion."
    rm -rf /tmp/project_files/*
)
```

#### Exit Scope

When confirmation exits, the exit raised will end the current shell. That means if you
define your task using curly braces, i.e., not inside a subshell, then the exit will
raise outside the caller. 

```bash
important_task() {
  echo 1
  dangerous_routine
  # this will ONLY run if the user accepts confirmation on dangerous_routine:
  echo 2 
}

dangerous_routine() {
  _fj_confirm "This will delete all temporary files" "Cancelled file deletion."
  # this will ONLY run if the user accepts confirmation:
  rm -rf /tmp/project_files/* 
}
```

On the other hand, if you define your function using parentheses, i.e., inside a
subshell, then only the caller function will exit. 

```bash
important_task() {
  echo 1
  dangerous_routine
  # this will even if the user doesn't accept confirmation because dangerous_routine is
  # defined to run in a subshell:
  echo 2 
}

dangerous_routine() (
  _fj_confirm "This will delete all temporary files" "Cancelled file deletion."
  # this will ONLY run if the user accepts confirmation:
  rm -rf /tmp/project_files/* 
)
```


### _fj_choose
Provides an interactive menu for selecting from options. The selection menu supports
arrow keys (up/down/left/right), j/k, and Ctrl-n/Ctrl-p for navigation, and Enter to
select.

```bash
select_environment() (
    _fj_choose selected_env "dev" "staging" "prod"
    _fj_log "Selected environment: $selected_env"
)
```

# FAQ
## Why?

I was talking to [@flaviokr](https://github.com/flaviokr), and we realized every project we build needs some command-line utilities to be run rather frequently during the development process. We tried different approaches to organize local tasks and define useful aliases shared that we could share with the rest of the team, but none felt quite right. We wanted a minimal tool that made it easy to define functions or scripts that were scoped by repository, so we decided to build one.

## Isn't this just like [some-other-project]?

Maybe. We looked around a bit before starting to develop our own local task manager, but haven't found a tool that fully convinced us. But we're pretty sure somebody out there has built something like `fj.sh`. We just figured it wouldn't be too challenging to build one just the way we wanted. Also, it seemed fun.

## Are you remaking GNU Make?

Not at all—this aims to be a much simpler project. Many developers, including us, have used GNU Make to set up local tasks, but that is harder than simply writing shell functions because the tool is not designed for that purpose.
