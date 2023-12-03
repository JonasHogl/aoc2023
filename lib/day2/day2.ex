defmodule Day2 do

  @fil File.read!("lib/day2/del1.txt") |> String.trim |> String.split("\n")
  @max_red 12
  @max_green 13
  @max_blue 14


  defmodule Game do
    defstruct game: 0, reds: 0, greens: 0, blues: 0
  end


  def day2 do
    IO.puts "Del1: #{del1()}"
    IO.puts "Del2: #{del2()}"
  end

  def del1 do
    @fil |> Enum.map(&mappa_till_game/1)
         |> Enum.filter(&är_omgången_giltig?/1)
         |> Enum.reduce(0, &summera_omgångsnummren/2)
  end

  def del2 do
    @fil |> Enum.map(&mappa_till_game/1)
         |> Enum.map(&mappa_till_power/1)
         |> Enum.reduce(0, &summera_power/2)
  end


  def är_omgången_giltig?(omgång) do
    omgång.reds <= @max_red
      && omgång.greens <= @max_green
      && omgång.blues <= @max_blue
  end

  def summera_omgångsnummren(%Game{game: game}, acc), do: game + acc

  def mappa_till_power(%Game{reds: reds, greens: greens, blues: blues}), do: reds * greens * blues

  def summera_power(power, acc), do: power + acc

  def mappa_till_game(rad) do
    [omgångsnummer | omgång] = String.split(rad, ": ")
    {nummer, _} = omgångsnummer |> String.replace("Game ", "") |> Integer.parse
   
    omgång |> hd 
           |> String.split("; ")
           |> Enum.flat_map(fn x -> String.split(x, ", ") end)
           |> Enum.reduce(%Game{game: nummer}, fn(x, acc) -> lagra_färginfo(acc, x) end)
  end

  def lagra_färginfo(game, färginfo) do
    [antal | färg] = färginfo |> String.split(" ")

    case hd(färg) do
      "red" -> set_reds(game, antal)
      "green" -> set_greens(game, antal)
      "blue" -> set_blues(game, antal)
      _ -> game
    end
  end

  def set_reds(game, reds) when is_binary(reds) do
    {antal, _} = Integer.parse(reds)
    set_reds(game, antal)
  end
  def set_reds(game, reds) do
    if reds > game.reds do  
      %Game{game: game.game, reds: reds, greens: game.greens, blues: game.blues}
    else
      game
    end
  end


  def set_greens(game, greens) when is_binary(greens) do
    {antal, _} = Integer.parse(greens)
    set_greens(game, antal)
  end
  def set_greens(game, greens) do
    if greens > game.greens do
      %Game{game: game.game, reds: game.reds, greens: greens, blues: game.blues}
    else 
      game
    end
  end


  def set_blues(game, blues) when is_binary(blues) do
    {antal, _} = Integer.parse(blues)
    set_blues(game, antal)
  end
  def set_blues(game, blues) do
    if blues > game.blues do  
      %Game{game: game.game, reds: game.reds, greens: game.greens, blues: blues}
    else 
      game
    end
  end

end
