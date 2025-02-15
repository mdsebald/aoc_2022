defmodule Day05 do
  @moduledoc """
  --- Day 5: Supply Stacks ---

  The expedition can depart as soon as the final supplies have been unloaded
  from the ships. Supplies are stored in stacks of marked crates, but because
  the needed supplies are buried under many other crates, the crates need to be
  rearranged.

  The ship has a giant cargo crane capable of moving crates between stacks.
  To ensure none of the crates get crushed or fall over, the crane operator
  will rearrange them in a series of carefully-planned steps. After the
  crates are rearranged, the desired crates will be at the top of each stack.

  The Elves don't want to interrupt the crane operator during this delicate
  procedure, but they forgot to ask her which crate will end up where, and
  they want to be ready to unload them as soon as possible so they can
  embark.

  They do, however, have a drawing of the starting stacks of crates and the
  rearrangement procedure (your puzzle input). For example:

      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2

  In this example, there are three stacks of crates. Stack 1 contains two
  crates: crate Z is on the bottom, and crate N is on top. Stack 2 contains
  three crates; from bottom to top, they are crates M, C, and D. Finally,
  stack 3 contains a single crate, P.

  Then, the rearrangement procedure is given. In each step of the procedure,
  a quantity of crates is moved from one stack to a different stack. In the
  first step of the above rearrangement procedure, one crate is moved from
  stack 2 to stack 1, resulting in this configuration:

  [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  In the second step, three crates are moved from stack 1 to stack 3. Crates
  are moved one at a time, so the first crate to be moved (D) ends up below
  the second and third crates:

          [Z]
          [N]
      [C] [D]
      [M] [P]
   1   2   3

  Then, both crates are moved from stack 2 to stack 1. Again, because crates
  are moved one at a time, crate C ends up below crate M:

          [Z]
          [N]
  [M]     [D]
  [C]     [P]
   1   2   3

  Finally, one crate is moved from stack 1 to stack 2:

          [Z]
          [N]
          [D]
  [C] [M] [P]
   1   2   3

  The Elves just need to know which crate will end up on top of each stack;
  in this example, the top crates are C in stack 1, M in stack 2, and Z in
  stack 3, so you should combine these together and give the Elves the message CMZ.

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
  As you watch the crane operator expertly rearrange the crates, you notice
  the process isn't following your prediction.

  Some mud was covering the writing on the side of the crane, and you quickly
  wipe it away. The crane isn't a CrateMover 9000 - it's a CrateMover 9001.

  The CrateMover 9001 is notable for many new and exciting features: air
  conditioning, leather seats, an extra cup holder, and the ability to pick
  up and move multiple crates at once.

  Again considering the example above, the crates begin in the same
  configuration:

      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  Moving a single crate from stack 2 to stack 1 behaves the same as before:

  [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  However, the action of moving three crates from stack 1 to stack 3 means
  that those three moved crates stay in the same order, resulting in this new
  configuration:

          [D]
          [N]
      [C] [Z]
      [M] [P]
   1   2   3

  Next, as both crates are moved from stack 2 to stack 1, they retain their
  order as well:

          [D]
          [N]
  [C]     [Z]
  [M]     [P]
   1   2   3

  Finally, a single crate is still moved from stack 1 to stack 2, but now
  it's crate C that gets moved:

          [D]
          [N]
          [Z]
  [M] [C] [P]
   1   2   3

  In this example, the CrateMover 9001 has put the crates in a totally
  different order: MCD.

  Before the rearrangement process finishes, update your simulation so that
  the Elves know where they should stand to be ready to unload the final
  supplies. After the rearrangement procedure completes, what crate ends up
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
