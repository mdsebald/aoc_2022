defmodule Day11 do
  @moduledoc """
  --- Day 11: Monkey in the Middle ---

  What is the level of monkey business after 20 rounds

  Your puzzle answer was 56120
  """

  def solve_1() do
    get_input()
    |> process_rounds(20)
    |> calc_mb_level()
  end

  defp process_rounds(monkeys, 0), do: monkeys

  defp process_rounds(monkeys, rounds) do
    process_monkeys(monkeys)
    |> process_rounds(rounds - 1)
  end

  defp process_monkeys(monkeys) do
    Enum.reduce(monkeys, monkeys, fn monkey, acc ->
      monkey = Enum.at(acc, monkey.id)
      process_turn(monkey, acc)
    end)
  end

  defp process_turn(%{items: []}, monkeys), do: monkeys

  defp process_turn(monkey, monkeys) do
    %{items: [item | rem_items]} = monkey

    new_worry = monkey.operation.(item) |> div(3)

    target =
      if rem(new_worry, monkey.test) == 0, do: monkey.true_rule, else: monkey.false_rule

    monkeys = update_monkey(monkeys, monkey.id, rem_items, monkey.inspected + 1)

    monkeys = update_target(monkeys, target, new_worry)

    updated_monkey = Enum.at(monkeys, monkey.id)
    process_turn(updated_monkey, monkeys)
  end

  defp update_monkey(monkeys, id, rem_items, inspected) do
    Enum.map(monkeys, fn monkey ->
      if monkey.id == id, do: %{monkey | items: rem_items, inspected: inspected}, else: monkey
    end)
  end

  defp update_target(monkeys, target, new_worry) do
    Enum.map(monkeys, fn monkey ->
      if monkey.id == target, do: %{monkey | items: monkey.items ++ [new_worry]}, else: monkey
    end)
  end

  @doc """
  Part 2

  what is the level of monkey business after 10000 rounds?

  Your puzzle answer was 24389045529
  """
  def solve_2() do
    monkeys = get_input()
    modulo = calc_modulo(monkeys)

    process_rounds(monkeys, modulo, 10000)
    |> calc_mb_level()
  end

  defp calc_modulo(monkeys) do
    Enum.map(monkeys, & &1.test) |> Enum.product()
  end

  defp process_rounds(monkeys, _modulo, 0), do: monkeys

  defp process_rounds(monkeys, modulo, rounds) do
    process_monkeys(monkeys, modulo) |> process_rounds(modulo, rounds - 1)
  end

  defp process_monkeys(monkeys, modulo) do
    Enum.reduce(monkeys, monkeys, fn monkey, acc ->
      monkey = Enum.at(acc, monkey.id)
      process_turn(monkey, modulo, acc)
    end)
  end

  defp process_turn(%{items: []}, _modulo, monkeys), do: monkeys

  defp process_turn(monkey, modulo, monkeys) do
    %{items: [item | rem_items]} = monkey

    new_worry = rem(monkey.operation.(item), modulo)

    target =
      if rem(new_worry, monkey.test) == 0, do: monkey.true_rule, else: monkey.false_rule

    monkeys = update_monkey(monkeys, monkey.id, rem_items, monkey.inspected + 1)

    monkeys = update_target(monkeys, target, new_worry)

    updated_monkey = Enum.at(monkeys, monkey.id)
    process_turn(updated_monkey, modulo, monkeys)
  end

  # common functions

  defp get_input(input \\ "inputs/day11.txt") do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_monkey/1)
  end

  defp parse_monkey(block) do
    [id, items, operation, test, true_rule, false_rule] = String.split(block, "\n", trim: true)

    %{
      id: parse_id(id),
      items: parse_items(items),
      operation: parse_operation(operation),
      test: parse_test(test),
      true_rule: parse_true_rule(true_rule),
      false_rule: parse_false_rule(false_rule),
      inspected: 0
    }
  end

  defp parse_id("Monkey " <> id), do: String.trim_trailing(id, ":") |> String.to_integer()

  defp parse_items("  Starting items: " <> items),
    do: String.split(items, ", ") |> Enum.map(&String.to_integer/1)

  defp parse_operation("  Operation: new = old * old"), do: &(&1 * &1)
  defp parse_operation("  Operation: new = old + " <> n), do: &(&1 + String.to_integer(n))
  defp parse_operation("  Operation: new = old * " <> n), do: &(&1 * String.to_integer(n))

  defp parse_test("  Test: divisible by " <> num), do: String.to_integer(num)

  defp parse_true_rule("    If true: throw to monkey " <> target) do
    String.to_integer(target)
  end

  defp parse_false_rule("    If false: throw to monkey " <> target) do
    String.to_integer(target)
  end

  defp calc_mb_level(monkeys) do
    monkeys
    |> Enum.map(& &1.inspected)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end
end
