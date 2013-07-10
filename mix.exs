defmodule Mockerator.Mixfile do
  use Mix.Project

  def project do
    [ app: :mockerator,
      version: "0.0.2",
      deps: deps ]
  end

  def application do
    []
  end

  defp deps do
    [
      { :uuid, %r(.*), github: "travis/erlang-uuid" }
    ]
  end
end
