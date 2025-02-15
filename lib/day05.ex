defmodule Day05 do
  @moduledoc """
  --- Day 5: Supply Stacks ---

  After the rearrangement procedure completes, what crate ends up on top of
  each stack?

  Your puzzle answer was CWMTGHBDW.
  """

  def top_of_stacks() do
    {stacks, moves} = get_stacks_and_moves()

    stacks =
      Enum.reduce(moves, stacks, fn move, stacks ->
        {from, to, count} = parse_move(move)
        move_crates(stacks, from, to, count)
      end)

    get_stack_tops(stacks)
  end

  @doc """
  --- Part Two ---

  After the rearrangement procedure completes, what crate ends up
  on top of each stack?

  Your puzzle answer was SSCGWJCRB.
  """

  def top_of_stacks2() do
    {stacks, moves} = get_stacks_and_moves()

    stacks =
      Enum.reduce(moves, stacks, fn move, stacks ->
        {from, to, count} = parse_move(move)
        move_crates2(stacks, from, to, count)
      end)

    get_stack_tops(stacks)
  end

  # Common functions

  defp get_stacks_and_moves(input \\ "inputs/day05.txt") do
    [stacks_str, moves_str] =
      File.read!(input)
      |> String.split("\n\n")

    {init_stacks(stacks_str), init_moves(moves_str)}
  end

  defp init_stacks(stacks_str) do
    String.split(stacks_str, "\n")
    |> Enum.map(&String.to_charlist(&1))
    |> Enum.reverse()
    |> Enum.reduce(initial_stacks(), &add_crates(&1, &2))
  end

  defp add_crates(crates, stacks) do
    Enum.reduce(1..9, stacks, fn index, stacks ->
      pos = (index - 1) * 4 + 1

      case Enum.at(crates, pos) do
        crate when ?A <= crate and crate <= ?Z ->
          add_crate(stacks, index, crate)

        _not_a_crate ->
          stacks
      end
    end)
  end

  defp initial_stacks() do
    %{
      1 => [],
      2 => [],
      3 => [],
      4 => [],
      5 => [],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }
  end

  defp move_crates(stacks, from, to, count) do
    Enum.reduce(1..count, stacks, fn _, stacks ->
      move_crate(stacks, from, to)
    end)
  end

  defp move_crates2(stacks, from, to, count) do
    {stacks, crates} = remove_crates(stacks, from, count)
    add_crates(stacks, to, crates)
  end

  defp move_crate(stacks, from, to) do
    {stacks, crate} = remove_crate(stacks, from)
    add_crate(stacks, to, crate)
  end

  defp add_crate(stacks, index, crate) do
    stack = Map.get(stacks, index)
    Map.put(stacks, index, [crate] ++ stack)
  end

  defp add_crates(stacks, index, crates) do
    stack = Map.get(stacks, index)
    Map.put(stacks, index, crates ++ stack)
  end

  defp remove_crate(stacks, index) do
    stack = Map.get(stacks, index)
    [crate | rem_stack] = stack
    {Map.put(stacks, index, rem_stack), crate}
  end

  defp remove_crates(stacks, index, count) do
    stack = Map.get(stacks, index)
    rem_length = length(stack) - count
    crates = Enum.take(stack, count)
    rem_crates = Enum.take(stack, -rem_length)
    {Map.put(stacks, index, rem_crates), crates}
  end

  defp init_moves(moves_str) do
    String.split(moves_str, "\n")
  end

  defp parse_move(move_str) do
    ["move", count_str, "from", from_str, "to", to_str] = String.split(move_str, " ")
    {String.to_integer(from_str), String.to_integer(to_str), String.to_integer(count_str)}
  end

  defp get_stack_tops(stacks) do
    Enum.reduce(1..9, ~c"", fn index, tops ->
      [top | _] = Map.get(stacks, index)
      tops ++ [top]
    end)
  end
end
