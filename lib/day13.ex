defmodule Day13 do
  @moduledoc """
  --- Day 13: Distress Signal ---

  What is the sum of the indices of the pairs in the right order?

  Your puzzle answer was 4734
  """
  def solve_1() do
    get_input_1()
    |> Enum.reduce(0, fn {{left_packet, right_packet}, index}, acc ->
      case compare(left_packet, right_packet) do
        true -> acc + index
        _ -> acc
      end
    end)
  end

  defp get_input_1(input \\ "inputs/day13.txt") do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.map(fn {packet_pair, index} ->
      [left_str, right_str] = String.split(packet_pair, "\n")

      {left_packet, _rest} = Code.eval_string(left_str)
      {right_packet, _rest} = Code.eval_string(right_str)

      {{left_packet, right_packet}, index}
    end)
  end

  @doc """
  Part 2

  What is the decoder key for the distress signal?

  Your puzzle answer was 21836
  """
  def solve_2() do
    get_input_2()
    |> Enum.sort(&compare/2)
    |> calc_decoder_key()
  end

  @divider_packet_1 [[2]]
  @divider_packet_2 [[6]]

  defp get_input_2(input \\ "inputs/day13.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&Code.eval_string(&1))
    |> Enum.map(fn {packet, _rest} -> packet end)
    |> List.insert_at(0, @divider_packet_1)
    |> List.insert_at(0, @divider_packet_2)
  end

  defp calc_decoder_key(packets) do
    (Enum.find_index(packets, fn x -> x == @divider_packet_1 end) + 1) *
      (Enum.find_index(packets, fn x -> x == @divider_packet_2 end) + 1)
  end

  # common functions

  # Compare two integers
  def compare(left, right) when is_integer(left) and is_integer(right) do
    cond do
      left < right -> true
      left > right -> false
      true -> :eq
    end
  end

  # Compare integer with list
  def compare(left, right) when is_integer(left) and is_list(right) do
    compare([left], right)
  end

  # Compare list with integer
  def compare(left, right) when is_list(left) and is_integer(right) do
    compare(left, [right])
  end

  # Compare two lists
  def compare([], []) do
    :eq
  end

  def compare([], [_ | _]) do
    true
  end

  def compare([_ | _], []) do
    false
  end

  def compare([left_head | left_tail], [right_head | right_tail]) do
    case compare(left_head, right_head) do
      :eq -> compare(left_tail, right_tail)
      result -> result
    end
  end
end
