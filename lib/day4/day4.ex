defmodule Day4 do
  @test File.read!("lib/day4/test.txt") |> String.trim |> String.split("\n")
  @prov File.read!("lib/day4/prov.txt") |> String.trim |> String.split("\n")

  defmodule Card do
   defstruct card_nr: 0, winners: [], numbers: [], count: 1
  end

  def kör() do
    IO.puts del1(@prov)
    IO.puts del2(@prov)
  end

  def kör(:t) do
    IO.puts del1(@test)
    IO.puts del2(@test)
  end

  def test do
    del2(@prov)
  end

  def del1(rader) do
    rader |> Enum.map(&mappa_till_card/1)
          |> Enum.map(&mappa_till_antal_vinnare/1)
          |> Enum.filter(fn x -> x > 0 end)
          |> Enum.map(&räkna_poäng/1)
          |> Enum.reduce(0, &(&1 + &2))
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



  def del2(rader) do
    rader |> Enum.map(&mappa_till_card/1)
          |> räkna_vunna_kort(0)

    
          
  end
  def del2(_), do: :inte_implementerat


  def räkna_vunna_kort([], totala_anta_kort), do: totala_anta_kort
  def räkna_vunna_kort([%Card{card_nr: nr, winners: vinnare, numbers: nummer, count: count} | resterande_vinnare], totala_antal_kort) do
    IO.inspect %Card{card_nr: nr, winners: vinnare, numbers: nummer, count: count} 
    antal_vinster = nummer |> Enum.filter(fn x -> x in vinnare end) |> Enum.to_list |> length
    IO.puts "antal vinster: #{antal_vinster}"
    IO.puts "resten"
    vunna_kort = resterande_vinnare |> Enum.take(antal_vinster) |> Enum.map(fn card -> öka_count(card, card.count + count) end)
    nya_kort_totalen = vunna_kort ++ Enum.drop(resterande_vinnare, antal_vinster)

    IO.inspect nya_kort_totalen
    räkna_vunna_kort(nya_kort_totalen, totala_antal_kort + count)
  end

  def öka_count(card, nytt_antal), do: %{card | count: nytt_antal}

end
