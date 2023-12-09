defmodule Day9 do
  
  @test File.read!("lib/day09/test.txt") |> String.trim |> String.split("\n")
  @prov File.read!("lib/day09/prov.txt") |> String.trim |> String.split("\n")

  def test do
    del2(@test)
  end
 
  def prov do
    del2(@prov)
  end


  def test1 do
    del1(@test)
  end

  def del1(rows) do
    rows |> Enum.map(&(String.split(&1, " ")))
         |> Enum.map(&(string_enum_to_int_enum(&1)))                    #|> Enum.map(fn x -> Enum.map(x, (fn y -> String.to_integer(y) end)) end)
         |> Enum.map(&(map_to_history([&1])))
         |> Enum.map(&(extrapolate_right(&1)))
         |> Enum.map(&(Enum.at(&1, -1)))
         |> Enum.reduce(&(&1 + &2))
  end

  def del2(rows) do
    rows |> Enum.map(&(String.split(&1, " ")))
         |> Enum.map(&(string_enum_to_int_enum(&1)))                    #|> Enum.map(fn x -> Enum.map(x, (fn y -> String.to_integer(y) end)) end)
         |> Enum.map(&(map_to_history([&1])))
         |> Enum.map(&(extrapolate_left(&1)))
         |> Enum.map(&(Enum.at(&1, 0)))
         |> Enum.reduce(&(&1 + &2))
  end

  def string_enum_to_int_enum(str_enum) do
    str_enum |> Enum.map(&(String.to_integer(&1)))
  end

  def last_value(enum), do: enum |> Enum.to_list |> List.last

  def map_to_history(rows) do
    last_row = rows |> last_value
    if last_row |> Enum.any?(&(&1 != 0)) do
      map_to_history(rows ++ [create_history_from_row(last_row)])
    else
      rows
    end
  end


  def create_history_from_row([first_val | rest]), do: create_history_from_row(rest, first_val, [])
  def create_history_from_row([], _, result), do: result
  def create_history_from_row([val | rest], val_to_the_left, result), do:  create_history_from_row(rest, val, result ++ [val - val_to_the_left])


  def extrapolate_right([history | []]), do: history ++ [0]
  def extrapolate_right([history | rest_history]) do
    val1 = history |> Enum.at(-1)
    val2 = extrapolate_right(rest_history) |> Enum.at(-1)
    history ++ [val1 + val2]
  end

 
  def extrapolate_left([history | []]), do: history ++ [0]
  def extrapolate_left([history | rest_history]) do
    val1 = history |> Enum.at(0)
    val2 = extrapolate_left(rest_history) |> Enum.at(0)
    [val1 - val2] ++ history
  end 

end
