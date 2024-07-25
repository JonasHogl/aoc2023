defmodule Day10 do
    
  @test File.read!("lib/day10/test.txt") |> String.trim |> String.split("\n")
  @prov File.read!("lib/day10/prov.txt") |> String.trim |> String.split("\n")


  def prov do
    del1(@prov)
  end

  def test do
    del1(@test)
  end

  def del1(rows) do
    start_row = rows |> Enum.find_index(&(String.contains?(&1, "S")))
    start_col = rows |> Enum.at(start_row) |> String.split("", trim: true) |> Enum.find_index(&(&1 === "S"))

    IO.puts "Start finns x: #{start_row}, y: #{start_col}"
  end

end
