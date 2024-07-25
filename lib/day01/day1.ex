defmodule Day1 do

  @fil "lib/day01/del2.txt"

  def del1 do
    Enum.to_list(File.stream!(@fil))
      |> Enum.map(&String.trim/1)
      |> Enum.map(&filter_characters/1)
      |> Enum.filter(fn x -> String.length(x) > 0 end)
      |> Enum.map(&map_to_calibration_value/1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(fn x, acc -> x + acc end)  
  end

  def filter_characters(binary) do
    String.replace(binary, ~r/[^0-9]/, "")
  end

  def map_to_calibration_value(data) do
    String.first(data) <> String.last(data)
  end



  def del2 do
    Enum.to_list(File.stream!(@fil))
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.downcase/1)
      |> Enum.map(&map_spelled_out_numbers/1)
      |> Enum.map(&filter_characters/1)
      |> Enum.filter(fn x -> String.length(x) > 0 end)
      |> Enum.map(&map_to_calibration_value/1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(fn x, acc -> x + acc end)
  end



  def map_spelled_out_numbers(string), do: map_spelled_out_numbers(string, "")
  defp map_spelled_out_numbers("", res), do: res
  defp map_spelled_out_numbers(string, result) do
    cond do
      String.starts_with?(string, "one") -> map_spelled_out_numbers(string_tail(string), result <> "1")
      String.starts_with?(string, "two") -> map_spelled_out_numbers(string_tail(string), result <> "2")
      String.starts_with?(string, "three") -> map_spelled_out_numbers(string_tail(string), result <> "3")
      String.starts_with?(string, "four") -> map_spelled_out_numbers(string_tail(string), result <> "4")
      String.starts_with?(string, "five") -> map_spelled_out_numbers(string_tail(string), result <> "5")
      String.starts_with?(string, "six") -> map_spelled_out_numbers(string_tail(string), result <> "6")
      String.starts_with?(string, "seven") -> map_spelled_out_numbers(string_tail(string), result <> "7")
      String.starts_with?(string, "eight") -> map_spelled_out_numbers(string_tail(string), result <> "8")
      String.starts_with?(string, "nine") -> map_spelled_out_numbers(string_tail(string), result <> "9")
      true -> map_spelled_out_numbers(string_tail(string), result <> String.first(string))
    end
  end
  
   

  def string_tail(string) do
    String.slice(string, 1..String.length(string))
  end

end
