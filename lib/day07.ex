defmodule Day07 do
  @moduledoc """
  --- Day 7: No Space Left On Device ---

  Find all of the directories with a total size of at most 100000. What is
  the sum of the total sizes of those directories?

  Your puzzle answer was 1182909.
  """

  def total_size_of_dirs_lt_100K() do
    find_dir_sizes()
    |> find_dirs_lt_100K()
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.sum()
  end

  @doc """
  --- Part Two ---

  Find the smallest directory that, if deleted, would free up enough space on
  the filesystem to run the update. What is the total size of that directory?

  Your puzzle answer was 2832508.
  """

  def find_smallest_dir_to_delete() do
    all_dirs = find_dir_sizes()

    total_used = find_total_used(all_dirs)
    free_space = 70_000_000 - total_used
    min_to_free = 30_000_000 - free_space

    Enum.filter(all_dirs, fn {_dir, size} -> size >= min_to_free end)
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.min()
  end

  # Common functions

  defp find_dir_sizes() do
    get_terminal_output()
    |> Enum.reduce({["/"], %{}}, &parse_line/2)
    |> elem(1)
    |> compute_sizes()
  end

  defp find_dirs_lt_100K(all_dirs) do
    Enum.filter(all_dirs, fn {_dir, size} -> size <= 100_000 end)
  end

  defp find_total_used(all_dirs) do
    Enum.map(all_dirs, fn {_dir, size} -> size end) |> Enum.max()
  end

  defp parse_line("$ cd /", {_path, _dir_tree}), do: {["/"], %{"/" => %{}}}

  defp parse_line("$ cd ..", {path, dir_tree}), do: {tl(path), dir_tree}

  defp parse_line("$ cd " <> dir, {path, dir_tree}), do: {[dir | path], dir_tree}

  defp parse_line("$ ls", {path, dir_tree}), do: {path, dir_tree}

  defp parse_line("dir " <> dir, {path, dir_tree}) do
    update_in(dir_tree, Enum.reverse(path), &Map.put(&1, dir, %{}))
    |> then(&{path, &1})
  end

  defp parse_line(size_and_file_name, {path, dir_tree}) do
    [size_str, file_name] = String.split(size_and_file_name, " ")
    file_size = String.to_integer(size_str)

    update_in(dir_tree, Enum.reverse(path), &Map.put(&1, file_name, file_size))
    |> then(&{path, &1})
  end

  def compute_sizes(dir_tree) do
    compute_sizes(dir_tree, %{}) |> elem(1)
  end

  defp compute_sizes(%{} = dir, acc) do
    {size, acc} =
      Enum.reduce(dir, {0, acc}, fn
        {_, %{} = subdir}, {sum, acc} ->
          {sub_size, acc} = compute_sizes(subdir, acc)
          {sum + sub_size, acc}

        {_, file_size}, {sum, acc} ->
          {sum + file_size, acc}
      end)

    {size, Map.put(acc, dir, size)}
  end

  defp get_terminal_output(input \\ "inputs/day07.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
  end
end
