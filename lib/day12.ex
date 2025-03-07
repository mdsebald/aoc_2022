defmodule Day12 do
  @moduledoc """
  --- Day 12: Hill Climbing Algorithm ---

  What is the fewest steps required to move from your current position to the location that should get the best signal?

  Your puzzle answer was 370
  """
  def solve_1() do
    get_input()
    |> get_start_finish()
    |> replace_height_chars()
    # BFS to find shortest path
    |> find_shortest_path()
  end

  @doc """
  Part 2

  What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal?

  Your puzzle answer was 363
  """
  def solve_2() do
    {grid, _start, finish} =
      get_input()
      |> get_start_finish()
      |> replace_height_chars()

    find_all_starts(grid)
    |> Enum.reduce(999_999, fn start, shortest ->
      curr_short = find_shortest_path({grid, start, finish})

      if curr_short < shortest do
        curr_short
      else
        shortest
      end
    end)
  end

  # common functions

  defp get_input(input \\ "inputs/day12.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        {{x, y}, char}
      end)
    end)
    |> Enum.into(%{})
  end

  defp get_start_finish(grid) do
    start = Enum.find(grid, fn {_, v} -> v == "S" end) |> elem(0)
    finish = Enum.find(grid, fn {_, v} -> v == "E" end) |> elem(0)

    grid = replace_start_char(grid, start) |> replace_finish_char(finish)

    {grid, start, finish}
  end

  defp find_all_starts(grid) do
    Enum.filter(grid, fn {_, v} -> v == 0 end)
    |> Enum.map(fn {coord, 0} -> coord end)
  end

  defp find_shortest_path({grid, start, finish}) do
    # Initialize BFS with starting point
    queue = :queue.from_list([{start, 0}])
    visited = MapSet.new([start])

    bfs(queue, visited, grid, finish)
  end

  defp bfs(queue, visited, grid, finish) do
    case :queue.out(queue) do
      {{:value, {current, steps}}, queue_rest} ->
        if current == finish do
          steps
        else
          {new_queue, new_visited} = process_neighbors(current, steps, queue_rest, visited, grid)
          bfs(new_queue, new_visited, grid, finish)
        end

      {:empty, _} ->
        # No path found
        nil
    end
  end

  defp process_neighbors(current, steps, queue, visited, grid) do
    current_height = Map.get(grid, current)

    [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    |> Enum.map(fn {dx, dy} ->
      {x, y} = current
      {x + dx, y + dy}
    end)
    |> Enum.filter(fn pos ->
      Map.has_key?(grid, pos) and not MapSet.member?(visited, pos)
    end)
    |> Enum.filter(fn pos ->
      neighbor_height = Map.get(grid, pos)
      neighbor_height <= current_height + 1
    end)
    |> Enum.reduce({queue, visited}, fn pos, {q, v} ->
      {:queue.in({pos, steps + 1}, q), MapSet.put(v, pos)}
    end)
  end

  defp replace_start_char(grid, start) do
    Map.put(grid, start, "a")
  end

  defp replace_finish_char(grid, finish) do
    Map.put(grid, finish, "z")
  end

  defp replace_height_chars({grid, start, finish}) do
    grid =
      Map.keys(grid)
      |> Enum.reduce(grid, fn coord, grid ->
        {_old_char, grid} =
          Map.get_and_update(grid, coord, fn char -> {char, height_value(char)} end)

        grid
      end)

    {grid, start, finish}
  end

  defp height_value(char) do
    :binary.first(char) - ?a
  end
end
