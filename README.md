# Radpath

[![Build Status](https://travis-ci.org/lowks/Radpath.png?branch=master)](https://travis-ci.org/lowks/Radpath)
[![Build Status](https://drone.io/github.com/lowks/Radpath/status.png)](https://drone.io/github.com/lowks/Radpath/latest)
[![wercker status](https://app.wercker.com/status/10f2bf7288af1be5c4e39f25367bb3b7/s/master "wercker status")](https://app.wercker.com/project/byKey/10f2bf7288af1be5c4e39f25367bb3b7)
[![Circle CI](https://circleci.com/gh/lowks/Radpath/tree/master.png?style=badge)](https://circleci.com/gh/lowks/Radpath/tree/master)
[![Inline docs](http://inch-ci.org/github/lowks/Radpath.svg?branch=master&style=flat)](http://inch-ci.org/github/lowks/Radpath)
[![Build Status](https://snap-ci.com/lowks/Radpath/branch/master/build_image)](https://snap-ci.com/lowks/Radpath/branch/master/build_image)
[![Coverage Status](https://coveralls.io/repos/lowks/Radpath/badge.png?branch=master)](https://coveralls.io/r/lowks/Radpath?branch=master)

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
{status, fd, file_path}  = Radpath.mktempfile
IO.write fd, "hoho"
File.close fd
File.read! filepath
"hoho"
File.rm! filepath
```

This uses all the defaults

To customize the location plus the extension: 

```
{_, fd, filepath} = Radpath.mktempfile(".log", "/home/lowks/Downloads")
IO.write fd, "hoho"
File.read! filepath
"hoho"
File.close! filepath
```

The default is ".log". Checkout the rest of the docs in the docs folder.

Run `mix docs` to generate a nice docs in a local folder or you can read them online: [Radpath hexdocs](http://hexdocs.pm/radpath/ "Hexdocs link for Radpath")

Check out [test examples](./test/radpath_test.exs) for usage.
