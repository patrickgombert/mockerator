defmodule Mockerator.Mixfile do
  use Mix.Project

  def project do
    [ app: :mockerator,
      elixir: "~> 0.15.0",
      version: "0.0.3",
      deps: deps ]
  end

  def application do
    []
  end

  defp deps do
    [
      { :uuid, github: "travis/erlang-uuid" }
    ]
  end
end
