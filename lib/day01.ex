defmodule Day01 do
  @moduledoc """
  --- Day 1: Calorie Counting ---

  Find the Elf carrying the most Calories. How many total Calories is that
  Elf carrying?

  Your puzzle answer was 72718.
  """

  def find_most_total_calories do
    {_, _, max} = get_calories() |> get_max_calories()
    max
  end

  @doc """
  -- Part Two ---

  Find the top three Elves carrying the most Calories. How many Calories are
  those Elves carrying in total?

  Your puzzle answer was 213089.
  """

  def find_top_3_most_total_calories do
    calories_lists = get_calories()
    {_, max_idx1, max_val1} = get_max_calories(calories_lists)

    calories_lists = List.delete_at(calories_lists, max_idx1)
    {_, max_idx2, max_val2} = get_max_calories(calories_lists)

    calories_lists = List.delete_at(calories_lists, max_idx2)
    {_, _, max_val3} = get_max_calories(calories_lists)

    max_val1 + max_val2 + max_val3
  end

  # Common functions
  defp get_max_calories(calories_lists) do
    Enum.reduce(calories_lists, {0, 0, 0}, fn calories_list, {index, max_idx, max_val} ->
      total_calories = Enum.sum(calories_list)

      if total_calories > max_val do
        {index + 1, index, total_calories}
      else
        {index + 1, max_idx, max_val}
      end
    end)
  end

  defp get_calories(input \\ "inputs/day01.txt") do
    File.read!(input)
    |> String.split("\n\n")
    |> Enum.map(fn calories_str ->
      String.split(calories_str, "\n")
      |> Enum.map(&String.to_integer(&1))
    end)
  end
end
