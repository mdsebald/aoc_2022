defmodule Day03 do
  @moduledoc """
  --- Day 3: Rucksack Reorganization ---

  Find the item type that appears in both compartments of each rucksack. What
  is the sum of the priorities of those item types?

  Your puzzle answer was 8176.
  """

  def sum_common_priorities() do
    get_rucksacks()
    |> Enum.map(&compartmentalize(&1))
    |> Enum.map(fn {compartment1, compartment2} ->
      MapSet.intersection(compartment1, compartment2)
    end)
    |> Enum.reduce(0, fn common_value, total ->
      get_priority(common_value) + total
    end)
  end

  defp compartmentalize(contents) do
    length = div(String.length(contents), 2)

    {String.slice(contents, 0, length) |> to_map_set(),
     String.slice(contents, length, length) |> to_map_set()}
  end

  @doc """
  --- Part Two ---

  Find the item type that corresponds to the badges of each three-Elf group.
  What is the sum of the priorities of those item types?

  Your puzzle answer was 2689.
  """

  def sum_badge_priorities() do
    get_rucksacks()
    |> Enum.map(&to_map_set(&1))
    |> Enum.chunk_every(3)
    |> Enum.map(&find_badge(&1))
    |> Enum.reduce(0, fn common_value, total ->
      get_priority(common_value) + total
    end)
  end

  defp find_badge([r1, r2, r3]) do
    MapSet.intersection(r1, r2) |> MapSet.intersection(r3)
  end

  # Common functions
  defp to_map_set(string) do
    MapSet.new(String.to_charlist(string))
  end

  defp get_priority(common_value) do
    [value] = MapSet.to_list(common_value)

    if ?a <= value && value <= ?z do
      value - ?a + 1
    else
      value - ?A + 27
    end
  end

  defp get_rucksacks(input \\ "inputs/day03.txt") do
    File.read!(input)
    |> String.split("\n")
  end
end
