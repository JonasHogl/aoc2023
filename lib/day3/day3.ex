defmodule Day3 do
  
  @test File.read!("lib/day3/test.txt") |> String.trim |> String.split("\n")
  @prov File.read!("lib/day3/prov.txt") |> String.trim |> String.split("\n")


  defmodule Part do
    defstruct part_nr: "", row: -1, col: -1
  end

  def kör() do
    IO.puts "Del1: #{del1(@test)}"
    IO.puts "Del2: #{del2(@test)}"
  end



  def kör(:p) do
    IO.puts "Del1: #{del1(@prov)}"
    IO.puts "Del2: #{del2(@prov)}"
  end

  def test() do
    del2(@test)
  end

  def del1(rader) do
    rader_med_index = rader |> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.with_index() end)
                            |> Enum.with_index()
  
    symboler = rader_med_index |> Enum.flat_map(&mappa_rad_till_symbol_delar/1)
    siffror = rader_med_index |> Enum.flat_map(&mappa_rad_till_siffer_delar/1)

    r = siffror |> Enum.map(fn s -> para_ihop_med_synbolgrannar(s, symboler) end)
    IO.inspect r

    r |> Enum.filter(&har_siffran_minst_en_granne?/1)
      |> Enum.reduce(0, &summera_delnummer/2)

    
  end


  def del2(rader) do
    rader_med_index = rader |> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.with_index() end)
                            |> Enum.with_index()
  

    siffror = rader_med_index |> Enum.flat_map(&mappa_rad_till_siffer_delar/1)

    symboler = rader_med_index |> Enum.flat_map(&mappa_rad_till_symbol_delar/1) 
                               |> Enum.filter(fn %Part{part_nr: part} -> part === "*" end)
                               |> Enum.map(fn s -> para_ihop_med_siffergrannar(s, siffror) end)
                               |> Enum.filter(&har_symbolen_två_grannar?/1)
                               |> Enum.map(&mappa_till_gear_ratio/1)
                               |> Enum.reduce(0, (fn x, acc -> x + acc end))

  end

  def summera_delnummer({%Part{part_nr: p_nr}, _}, acc) do
    {nr, _} = Integer.parse(p_nr)
    nr + acc
  end



  def mappa_till_gear_ratio({_, [%Part{part_nr: part_nr1}, %Part{part_nr: part_nr2}]}) do
    {nr1, _} = Integer.parse(part_nr1)
    {nr2, _} = Integer.parse(part_nr2)
    nr1 * nr2
  end



  def para_ihop_med_siffergrannar(symbol, siffror) do
    siffer_grannar = siffror |> Enum.filter(fn siffra -> filtrera_grannar_rad(symbol.row, siffra.row) end)
                             |> Enum.filter(fn siffra -> filtrera_granne_till_symbol_col(symbol.col, siffra) end)

    {symbol, siffer_grannar}
  end


  def filtrera_granne_till_symbol_col(symbol_col, siffra) do
    Enum.to_list(siffra.col - 1 .. siffra.col + String.length(siffra.part_nr)) |> Enum.any?(fn x -> x === symbol_col end)
  end

  def har_symbolen_två_grannar?({_,grannar}) do
    grannar |> Enum.to_list() |> length() === 2
  end


  def har_siffran_minst_en_granne?({_, []}), do: false
  def har_siffran_minst_en_granne?(_), do: true

  def mappa_rad_till_symbol_delar({rad, rad_nr}) do
    rad |> Enum.filter(fn {tecken, _} -> är_symbol?(tecken) end)
        |> Enum.map(fn {tecken, kolumn_nr} -> %Part{part_nr: tecken, row: rad_nr, col: kolumn_nr} end)
  end


  def mappa_rad_till_siffer_delar({rad, rad_nr}), do: mappa_rad_till_siffer_delar(rad, %Part{row: rad_nr}, [])
  defp mappa_rad_till_siffer_delar([], part, radens_komponenter) when part.part_nr !== "", do: radens_komponenter ++ [part]
  defp mappa_rad_till_siffer_delar([], _, radens_komponenter), do: radens_komponenter
  defp mappa_rad_till_siffer_delar([{symbol, kolumn_nr} | rest], part, radens_komponenter) when symbol >= "0" and symbol <= "9" and part.part_nr !== "" do
    mappa_rad_till_siffer_delar(rest, %Part{part_nr: part.part_nr <> symbol, row: part.row, col: part.col}, radens_komponenter)
  end
  defp mappa_rad_till_siffer_delar([{symbol, kolumn_nr} | rest], part, radens_komponenter) when symbol >= "0" and symbol <= "9" do
    mappa_rad_till_siffer_delar(rest, %Part{part_nr: symbol, row: part.row, col: kolumn_nr}, radens_komponenter)
  end
  defp mappa_rad_till_siffer_delar([{symbol, kolumn_nr} | rest], part, radens_komponenter) when part.part_nr !== "" do
    mappa_rad_till_siffer_delar(rest, %Part{row: part.row}, radens_komponenter ++ [part])
  end
  defp mappa_rad_till_siffer_delar([{_, _} | rest], part, radens_komponenter) do
    mappa_rad_till_siffer_delar(rest, part, radens_komponenter)
  end


  def är_symbol?(tecken) when is_binary(tecken), do: not(tecken >= "0" and tecken <= "9") && tecken !== "."

  def uppdatera_part_nr(%Part{part_nr: _, row: r, col: c}, part_nr), do: %Part{part_nr: part_nr, row: r, col: c}
  
  def para_ihop_med_synbolgrannar(%Part{part_nr: nr, row: num_r, col: num_c}, lista_på_symboler) do

    symboler_runt_siffrans_rad = lista_på_symboler 
                      |> Enum.filter(fn %Part{row: sym_r} -> filtrera_grannar_rad(num_r, sym_r) end)
                      |> Enum.filter(fn %Part{col: sym_c} -> filtrera_grannar_col(nr, num_c, sym_c) end)

    {%Part{part_nr: nr, row: num_r, col: num_c}, symboler_runt_siffrans_rad}
  end

  def filtrera_grannar_rad(0, row_2), do: row_2 == 0 || row_2 == 1
  def filtrera_grannar_rad(row_1, row_2) do
    row_2 >= row_1 - 1 and row_2 <= row_1 + 1
  end

  def filtrera_grannar_col(nr, col_1, col_2) do
    col_2 >= col_1 - 1 and col_2 <= col_1 + String.length(nr)
  end
  

  def till_siffra(n) do
    {siffra,_} = Integer.parse n
    siffra
  end

end
