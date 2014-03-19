# Radpath

[![Build Status](https://travis-ci.org/lowks/Radpath.png?branch=master)](https://travis-ci.org/lowks/Radpath)

A library for handling paths in Elixir inspired by enhpath in Python.

## Getting Started

To use Radpath, as usual add a depedency in your mix project

``` elixir
    
def deps do
  [ { :Radpath, github: "lowks/Radpath"}]
end
```

After that, run `mix deps.get` from your shell to fetch and compile radpath.

## Status

Project is still actively being developed

## Running Tests

As usual, just run

```
mix test
```

## Docs

To list down files in a path:

```
Radpath.files("/home/lowks/Documents")
```

or if you wanted to filter out pdfs:

```
Radpath.files("/home/lowks/Documents", "pdf")
```

To list down only directories:

```
Radpath.dirs("/home/lowks")                  
```

To create symlink:

```
Radpath.symlink(source, destination)
```

To create tempfile:

```
Radpath.mktempfile
```

This uses all the defaults

To customize the location plus the extension: 

```
Radpath.mktempfile(".log", "/home/lowks/Documents/temp/")
```

The default is ".log". Checkout the rest of the docs in the docs folder.