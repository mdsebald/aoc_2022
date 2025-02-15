defmodule Day04 do
  @moduledoc """
  --- Day 4: Camp Cleanup ---

  In how many assignment pairs does one range fully contain the other?

  Your puzzle answer was 305.
  """

  def count_contained_pairs() do
    get_sections()
    |> Enum.reduce(0, fn pair, contained ->
      if contained?(pair) do
        contained + 1
      else
        contained
      end
    end)
  end

  defp contained?([x1, x2, y1, y2]) do
    (x1 <= y1 and y2 <= x2) or (y1 <= x1 and x2 <= y2)
  end

  @doc """
  --- Part Two ---

  In how many assignment pairs do the ranges overlap?

  Your puzzle answer was 811.
  """

  def count_overlap_pairs() do
    get_sections()
    |> Enum.reduce(0, fn pair, overlapped ->
      if overlapped?(pair) do
        overlapped + 1
      else
        overlapped
      end
    end)
  end

  defp overlapped?([x1, x2, y1, y2]) do
    y1 <= x2 and x1 <= y2
  end

  # Common functions

  defp convert_pair(pair_str) do
    String.split(pair_str, [",", "-"])
    |> Enum.map(&String.to_integer(&1))
  end

  defp get_sections(input \\ "inputs/day04.txt") do
    File.read!(input)
    |> String.split("\n")
    |> Enum.map(&convert_pair(&1))
  end
end
