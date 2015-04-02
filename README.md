# Radpath

[![Build Status](https://travis-ci.org/lowks/Radpath.png?branch=master)](https://travis-ci.org/lowks/Radpath)
[![Build Status](https://drone.io/github.com/lowks/Radpath/status.png)](https://drone.io/github.com/lowks/Radpath/latest)
[![wercker status](https://app.wercker.com/status/8a98607487fbd4ad61904acbb840e31a/m/ "wercker status")](https://app.wercker.com/project/bykey/8a98607487fbd4ad61904acbb840e31a)
[![Circle CI](https://circleci.com/gh/lowks/Radpath/tree/master.png?style=badge)](https://circleci.com/gh/lowks/Radpath/tree/master)
[![Inline docs](http://inch-ci.org/github/lowks/Radpath.svg?branch=master&style=flat)](http://inch-ci.org/github/lowks/Radpath)
[![Build Status](https://snap-ci.com/lowks/Radpath/branch/master/build_image)](https://snap-ci.com/lowks/Radpath/branch/master)

A library for dealing with paths in Elixir largely inspired by Python's pathlib.


## Getting Started

To use Radpath, add a dependency in your mix:

``` 
    
def deps do
  [ { :Radpath, github: "lowks/Radpath"}]
end
```

then `mix deps.get` fetches dependencies and compiles Radpath.

## Status

Developed whenever I can find the time.

## Running Tests

Running tests against a stable release of Elixir defined by 'STABLE_ELIXIR_VERSION' in the Makefile:

```
make ci
```

Running tests against your system's Elixir:

```
make
```

## Docs (Lite Version)

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

Run `mix docs` to generate a nice docs in a local folder or you can read them online: [Radpath hexdocs](http://hexdocs.pm/radpath/ "Hexdocs link for Radpath")

Check out [test examples](./test/radpath_test.exs) for usage.
