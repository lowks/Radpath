# Radpath

[![Build Status](https://travis-ci.org/lowks/Radpath.png?branch=master)](https://travis-ci.org/lowks/Radpath)

[![Build Status](https://drone.io/github.com/lowks/Radpath/status.png)](https://drone.io/github.com/lowks/Radpath/latest)

[![wercker status](https://app.wercker.com/status/8a98607487fbd4ad61904acbb840e31a/m/ "wercker status")](https://app.wercker.com/project/bykey/8a98607487fbd4ad61904acbb840e31a)

[![Circle CI](https://circleci.com/gh/lowks/Radpath.png?style=badge)](https://circleci.com/gh/lowks/Radpath)

A library for handling paths in Elixir inspired by Python's pathlib.

## Getting Started

To use Radpath, as usual add a dependency in your mix:

``` elixir
    
def deps do
  [ { :Radpath, github: "lowks/Radpath"}]
end
```

After that, run `mix deps.get` from your shell to fetch and compile radpath.

## Status

Project is still actively being developed

## Running Tests

There is a special Makefile for running tests, just run:

```
make ci
```

## Docs

To list down files in a path:

```
Radpath.files("/home/lowks/Documents")
```

or if you wanted to filter out certain files with pdf extensions:

```
Radpath.files("/home/lowks/Documents", "pdf")
```

Listing down only directories:

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

You can also run `mix docs` to generate a nice docs folder

Or check out [test examples](./test/radpath_test.exs) for usage.
