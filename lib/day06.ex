defmodule Day06 do
  @moduledoc """
  --- Day 6: Tuning Trouble ---

  How many characters need to be processed before the first start-of-packet marker is detected?

  Your puzzle answer was 1623.
  """
  def get_packet_start() do
    get_packet()
    |> String.to_charlist()
    |> Enum.reduce_while({[0, 0, 0, 0], 0}, fn char, {last_four, count} ->
      [_ | rem] = last_four
      last_four = rem ++ [char]

      case length(Enum.uniq(last_four)) do
        4 -> {:halt, count + 1}
        _ -> {:cont, {last_four, count + 1}}
      end
    end)
  end

  @doc """
  -- Part Two ---

  How many characters need to be processed before the first start-of-message
  marker is detected?

  Your puzzle answer was 3774.
  """

  def get_message_start() do
    get_packet()
    |> String.to_charlist()
    |> Enum.reduce_while({[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0}, fn char,
                                                                             {last_fourteen,
                                                                              count} ->
      [_ | rem] = last_fourteen
      last_fourteen = rem ++ [char]

      case length(Enum.uniq(last_fourteen)) do
        14 -> {:halt, count + 1}
        _ -> {:cont, {last_fourteen, count + 1}}
      end
    end)
  end

  # Common functions

  defp get_packet(input \\ "inputs/day06.txt") do
    File.read!(input)
  end
end
