defmodule Day8 do
   
  @test File.read!("lib/day08/test.txt") |> String.trim |> String.split("\n")
  @prov File.read!("lib/day08/prov.txt") |> String.trim |> String.split("\n")

  defmodule Node do
    defstruct node: "", left: "", right: ""
  end

  def test do
    del1(@test)
  end
 
  def prov do
    del1(@prov)
  end

  def del1([instructions | rows]) do
    nodes = rows |> Enum.filter(&(String.length(&1) > 0))
                 |> Enum.map(&(map_to_node(&1)))

    start_node = nodes |> Enum.find(fn x -> x.node === "AAA" end)

    instructions |> iterate_through_nodes(start_node, nodes, 0, "ZZZ", instructions)
    
  end

  def map_to_node(row) do
    [node_name | l_and_r] = row |> String.split(" = \(")
    [left, right] = l_and_r |> Enum.at(0) |> String.split(", ")
    %Node{node: node_name, left: left, right: right |> String.replace("\)", "")}
  end

  def iterate_through_nodes(_, %Node{node: current_node}, _, steps, goal, _) when current_node === goal, do: steps
  def iterate_through_nodes("", current_node, nodes, steps, goal, instructions), do: iterate_through_nodes(instructions, current_node, nodes, steps, goal, instructions)
  def iterate_through_nodes("L" <> rest, current_node, nodes, steps, goal, instructions), do: iterate_through_nodes(rest, nodes |> Enum.find(fn x -> x.node == current_node.left end), nodes, steps+1, goal, instructions)
  def iterate_through_nodes("R" <> rest, current_node, nodes, steps, goal, instructions), do: iterate_through_nodes(rest, nodes |> Enum.find(fn x -> x.node == current_node.right end), nodes, steps+1, goal, instructions)
    


end
