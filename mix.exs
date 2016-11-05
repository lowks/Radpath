Code.ensure_loaded?(Hex) and Hex.start
defmodule Radpath.Mixfile do
  use Mix.Project

  @version "0.0.5"

  def project do
    [ app: :radpath,
      version: @version,
      elixir: "~> 1.3.0 or ~> 1.0.2 or ~> 1.1.0",
      description: description,
      docs: [source_ref: "v#{@version}", main: "Radpath"],
      package: package,
      deps: deps(Mix.env),
      deps_path: System.get_env("MY_DEPS_PATH") || "deps",
      test_coverage: [tool: ExCoveralls]
     ]
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
     files: ["lib", "mix.exs", "README.md", "LICENSE*", "test*"],
     contributors: ["Low Kian Seong"],
     deps: deps(:prod),
     licenses: ["MIT"],
     links: %{
         "GitHub" => "https://github.com/lowks/Radpath",
         "Docs" => "http://hexdocs.pm/radpath"
     }
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }

  defp deps(:prod) do
    [
     {:tempfile, github: "lowks/tempfile" },
     {:ex_doc, github: "elixir-lang/ex_doc"},
     {:finder, github: "h4cc/Finder" },
     {:erlware_commons, github: "erlware/erlware_commons"},
     {:temp, "~> 0.2"},
    ]
  end

  defp deps(:test) do
    deps(:prod) ++ [
     {:pattern_tap, github: "mgwidmann/elixir-pattern_tap", only: :test},
     {:amrita, "~>0.4", github: "josephwilk/amrita", only: :test},
     {:excoveralls,  "== 0.3.6", only: :test},
    ]
  end

  defp deps(:docs) do
    deps(:prod) ++ [
      {:inch_ex, only: :docs},
    ]
  end

  defp deps(_) do
   deps(:prod)
  end
end
