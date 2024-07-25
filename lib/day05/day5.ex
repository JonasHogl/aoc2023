defmodule Day5 do
  @test File.read!("lib/day05/test.txt") |> String.trim() |> String.split("\n")
  @prov File.read!("lib/day05/prov.txt") |> String.trim() |> String.split("\n")

  def test do
    seeds = @test |> Enum.at(0) |> get_seeds
    seeds
  end

  def prov do
    @prov
  end

  def get_seeds("seeds: " <> seeds) do
    String.split(seeds, " ")
  end
end
