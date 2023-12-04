defmodule Day4 do
  @test File.read!("lib/day4/test.txt") |> String.trim |> String.split("\n")
  @prov File.read!("lib/day4/prov.txt") |> String.trim |> String.split("\n")

  defmodule Card do
   defstruct card_nr: 0, winners: [], numbers: []
  end

  def test do
    del1(@prov)
  end

  def del1(rader) do
    rader |> Enum.map(&mappa_till_card/1)
          |> Enum.map(&mappa_till_antal_vinnare/1)
          |> Enum.filter(fn x -> x > 0 end)
          |> Enum.map(&räkna_poäng/1)
          |> Enum.reduce(0, (fn x, acc -> x + acc end))
  end

  def mappa_till_card(rad) do
    ["Card" <> card_nr_str | omgång] = String.split(rad, ":")
    {card_nr, _} = card_nr_str |> String.trim() |> Integer.parse()

    [winners_str | numbers_str]= omgång |> hd |> String.trim() |> String.replace("  ", " ") |> String.split(" | ")

    %Card{
      card_nr: card_nr, 
      winners: winners_str |> String.split(" "), 
      numbers: numbers_str |> hd |> String.split(" ")}
  end

  def mappa_till_antal_vinnare(%Card{winners: winners, numbers: numbers}) do
    numbers |> Enum.filter(fn x -> x in winners end) |> Enum.to_list() |> length
  end

  def räkna_poäng(1), do: 1
  def räkna_poäng(n), do: räkna_poäng(n-1) * 2

end
