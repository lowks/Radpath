Code.ensure_loaded?(Hex) and Hex.start                                                                                              
defmodule Radpath.Mixfile do
  use Mix.Project

  def project do
    [ app: :radpath,
      version: "0.0.5",
      elixir: "~> 1.0.0",
      description: description,
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
         "Docs" => "http://hexdocs.pm/radpath/0.0.4/"
     }
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps(:prod) do
    [{:tempfile, github: "lowks/tempfile"},
     {:finder, github: "h4cc/Finder" },
     {:erlware_commons, github: "erlware/erlware_commons" },
     {:inch_ex, only: :docs}] 
  end

  defp deps(:test) do
    [{:tempfile, github: "lowks/tempfile"},
     {:ex_doc, github: "elixir-lang/ex_doc"},
     {:finder, github: "h4cc/Finder"},
     {:amrita, "~>0.4", github: "josephwilk/amrita"},
     {:erlware_commons, github: "erlware/erlware_commons"},
     {:inch_ex, only: :docs}] 
  end

  defp deps(:dev) do
    [{:tempfile, github: "lowks/tempfile"},
     {:ex_doc, github: "elixir-lang/ex_doc"},
     {:finder, github: "h4cc/Finder"},
     {:amrita, "~>0.4", github: "josephwilk/amrita"},
     {:erlware_commons, github: "erlware/erlware_commons"},
     {:excoveralls, "~> 0.3"}]
   end

  defp deps(_) do
   deps(:prod)
  end
end
