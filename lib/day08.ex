defmodule Day08 do
  @moduledoc """
  --- Day 8: Treetop Tree House ---

  Consider your map; how many trees are visible from outside the grid?

  Your puzzle answer was 1840
  """
  def solve_1() do
    get_input() |> visible_trees()
  end

  defp visible_trees(grid) do
    rows = length(grid)
    cols = length(hd(grid))

    # Outside edge trees are always visible
    # Don't count corner trees twice
    outside = 2 * rows + 2 * cols - 4

    # Skip the outside rows and columns
    Enum.reduce(1..(rows - 2), outside, fn r, acc ->
      Enum.reduce(1..(cols - 2), acc, fn c, acc ->
        if tree_visible?(grid, r, c), do: acc + 1, else: acc
      end)
    end)
  end

  defp tree_visible?(grid, r, c) do
    height = Enum.at(Enum.at(grid, r), c)
    row = Enum.at(grid, r)
    col = Enum.map(grid, &Enum.at(&1, c))

    left = Enum.slice(row, 0, c)
    right = Enum.slice(row, c + 1, length(row) - c - 1)
    up = Enum.slice(col, 0, r)
    down = Enum.slice(col, r + 1, length(col) - r - 1)

    # Count tree if it is visible from any of the 4 directions
    Enum.any?([left, right, up, down], fn direction ->
      Enum.all?(direction, &(&1 < height))
    end)
  end

  @doc """
  --- Part Two ---

  Consider each tree on your map. What is the highest scenic score possible for any tree?

  Your puzzle answer was 405,769
  """
  def solve_2() do
    get_input() |> highest_view_score()
  end

  defp highest_view_score(grid) do
    rows = length(grid)
    cols = length(hd(grid))

    # View score is zero for outside rows and columns. Skip them
    Enum.reduce(1..(rows - 2), 0, fn r, acc ->
      Enum.reduce(1..(cols - 2), acc, fn c, acc ->
        score = total_view_score(grid, r, c)

        if score > acc do
          score
        else
          acc
        end
      end)
    end)
  end

  defp total_view_score(grid, r, c) do
    height = Enum.at(Enum.at(grid, r), c)
    row = Enum.at(grid, r)
    col = Enum.map(grid, &Enum.at(&1, c))

    left = Enum.slice(row, 0, c) |> Enum.reverse() |> view_score(height)

    right = Enum.slice(row, c + 1, length(row) - c - 1) |> view_score(height)

    up = Enum.slice(col, 0, r) |> Enum.reverse() |> view_score(height)

    down = Enum.slice(col, r + 1, length(col) - r - 1) |> view_score(height)

    left * right * up * down
  end

  defp view_score(view, height) do
    Enum.reduce_while(view, 0, fn v_height, v_score ->
      if v_height >= height do
        {:halt, v_score + 1}
      else
        {:cont, v_score + 1}
      end
    end)
  end

  # Common functions

  defp get_input(input \\ "inputs/day08.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.map(&1, fn char -> String.to_integer(char) end))
  end
end
