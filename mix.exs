defmodule Radpath.Mixfile do
  use Mix.Project

  def project do
    [ app: :radpath,
      version: "0.0.1",
      elixir: "~> 0.12.4",
      description: description,
      package: package,
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  defp description do
    """
    A path library for Elixir inspired by Python path libraries
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md", "LICENSE*", "test*"]
     contributors: ["Low Kian Seong"],
     licenses: ["MIT"],
     links: [{ "GitHub", "https://github.com/lowks/Radpath"},]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps(:prod) do
    [{ :tempfile, github: "glejeune/tempfile" },
     { :finder, github: "h4cc/Finder" }]
  end

  defp deps(:test) do
    [{ :tempfile, github: "glejeune/tempfile" },
     { :ex_doc, github: "elixir-lang/ex_doc" },
     { :finder, github: "h4cc/Finder" },
     { :amrita, "~>0.2", github: "josephwilk/amrita"}]
  end

  defp deps(_) do
   deps(:prod)
  end
end
