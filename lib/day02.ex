defmodule Day02 do
  @moduledoc """
  --- Day 2: Rock Paper Scissors ---

  What would your total score be if everything goes exactly according to your
  strategy guide?

  Your puzzle answer was 13526.
  """

  def calc_total_score1() do
    get_strategy_guide()
    |> Enum.reduce(0, fn round, total -> calc_score1(round) + total end)
  end

  defp calc_score1("A X"), do: 1 + 3
  defp calc_score1("A Y"), do: 2 + 6
  defp calc_score1("A Z"), do: 3 + 0
  defp calc_score1("B X"), do: 1 + 0
  defp calc_score1("B Y"), do: 2 + 3
  defp calc_score1("B Z"), do: 3 + 6
  defp calc_score1("C X"), do: 1 + 6
  defp calc_score1("C Y"), do: 2 + 0
  defp calc_score1("C Z"), do: 3 + 3

  @doc """
  --- Part Two ---

  Following the Elf's instructions for the second column, what would your
  total score be if everything goes exactly according to your strategy guide?

  Your puzzle answer was 14204.
  """

  def calc_total_score2() do
    get_strategy_guide()
    |> Enum.reduce(0, fn round, total -> calc_score2(round) + total end)
  end

  defp calc_score2("A X"), do: 3 + 0
  defp calc_score2("A Y"), do: 1 + 3
  defp calc_score2("A Z"), do: 2 + 6
  defp calc_score2("B X"), do: 1 + 0
  defp calc_score2("B Y"), do: 2 + 3
  defp calc_score2("B Z"), do: 3 + 6
  defp calc_score2("C X"), do: 2 + 0
  defp calc_score2("C Y"), do: 3 + 3
  defp calc_score2("C Z"), do: 1 + 6

  # Common functions

  defp get_strategy_guide(input \\ "inputs/day02.txt") do
    File.read!(input)
    |> String.split("\n")
  end
end
