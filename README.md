# fj.sh

`fj.sh` is a minimalist command-line task runner for your projects. It allows you to set up shell functions for running tasks scoped to a local directory and run them easily by using the the shortcut `'fj mytask'`.

# FAQ
## Why?

I was talking to @flaviokr and we figured every project we build needs some command-line utilities to be run quite often during the development process. We have tried some different approaches to defining local tasks but none felt quite right. We needed a minimal tool that defined a simple pattern for us to define functions or scripts scoped to each repository so that we could use it in all our other projects, so we decided to build it.

## Isn't this just like <some-other-project>?

Maybe. I looked around a bit before starting to develop my own local task manager, but haven't found a tool that fully convinced me. But I'm pretty sure somebody out there has built something like `fj.sh`. I just figured it wouldn't be too hard to build one just the way I wanted it, and also it seemed fun.

## Are you remaking GNU Make?

No. In fact, this aims to be a much simpler project. GNU Make is a very powerful tool, but it is origninally designed to generate executables from source files, not executing local tasks associated with your git repository. I used GNU Make for setting up local tasks many times, but that was always harder than just writing shell functions, because the tool wasn't designed for that purpose.
