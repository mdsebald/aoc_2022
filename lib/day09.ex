defmodule Day09 do
  @moduledoc """

  --- Day 9: Rope Bridge ---
  How many positions does the tail of the rope visit at least once?

  Your puzzle answer was 6376
  """
  def solve_1() do
    get_input()
    |> move_rope(2)
    |> count_visited()
  end

  @doc """
  --- Part Two ---

  How many positions does the tail of the 10 knot rope visit at least once?

  Your puzzle answer was 2607
  """
  def solve_2() do
    get_input()
    |> move_rope(10)
    |> count_visited()
  end

  # Common functions

  defp move_rope(directions, knot_cnt) do
    init_knots = List.duplicate({0, 0}, knot_cnt)

    Enum.reduce(directions, {init_knots, [{0, 0}]}, fn {dir, steps}, {knots, visited} ->
      move_head(dir, steps, knots, visited)
    end)
  end

  defp move_head(_dir, 0, knots, visited) do
    {knots, visited}
  end

  defp move_head(dir, steps, knots, visited) do
    [{hx, hy} | tl_knots] = knots

    {hx, hy} =
      case dir do
        "R" -> {hx + 1, hy}
        "L" -> {hx - 1, hy}
        "U" -> {hx, hy + 1}
        "D" -> {hx, hy - 1}
      end

    knots = move_tails(tl_knots, [{hx, hy}])
    move_head(dir, steps - 1, knots, [List.last(knots) | visited])
  end

  defp move_tails([], hd_knots), do: Enum.reverse(hd_knots)

  defp move_tails(tl_knots, hd_knots) do
    {hx, hy} = hd(hd_knots)
    [{tx, ty} | rem_tl_knots] = tl_knots
    {tx, ty} = move_tail(hx, hy, tx, ty)
    move_tails(rem_tl_knots, [{tx, ty} | hd_knots])
  end

  defp move_tail(hx, hy, tx, ty) do
    case {hx - tx, hy - ty} do
      {2, 0} -> {tx + 1, ty}
      {-2, 0} -> {tx - 1, ty}
      {0, 2} -> {tx, ty + 1}
      {0, -2} -> {tx, ty - 1}
      {1, 2} -> {tx + 1, ty + 1}
      {-1, 2} -> {tx - 1, ty + 1}
      {1, -2} -> {tx + 1, ty - 1}
      {-1, -2} -> {tx - 1, ty - 1}
      {2, 1} -> {tx + 1, ty + 1}
      {-2, 1} -> {tx - 1, ty + 1}
      {2, -1} -> {tx + 1, ty - 1}
      {-2, -1} -> {tx - 1, ty - 1}
      {-2, -2} -> {tx - 1, ty - 1}
      {2, 2} -> {tx + 1, ty + 1}
      {2, -2} -> {tx + 1, ty - 1}
      {-2, 2} -> {tx - 1, ty + 1}
      _ -> {tx, ty}
    end
  end

  defp count_visited({_knots, visited}) do
    Enum.uniq(visited) |> Enum.count()
  end

  defp get_input(input \\ "inputs/day09.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      [dir, steps_str] = String.split(str)
      {dir, String.to_integer(steps_str)}
    end)
  end
end
