defmodule Day10 do
  @moduledoc """
  --- Day 10: Cathode-Ray Tube ---

  Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles.
  What is the sum of these six signal strengths?

  Your puzzle answer is 13920
  """
  @signal_cycles [20, 60, 100, 140, 180, 220]

  def solve_1() do
    get_input()
    |> find_signal_strength()
  end

  defp find_signal_strength(instrs) do
    Enum.reduce(instrs, {0, 1, 0}, fn instr, {cycles, x_acc, sig_str} ->
      exec_instr(instr, cycles, x_acc, sig_str)
    end)
  end

  defp exec_instr(instr, cycles, x_acc, sig_str) do
    case instr do
      "noop" ->
        cycles = cycles + 1
        sig_str = calc_sig_str(cycles, x_acc, sig_str)
        {cycles, x_acc, sig_str}

      {"addx", val} ->
        cycles = cycles + 1
        sig_str = calc_sig_str(cycles, x_acc, sig_str)
        cycles = cycles + 1
        sig_str = calc_sig_str(cycles, x_acc, sig_str)
        x_acc = x_acc + val
        {cycles, x_acc, sig_str}
    end
  end

  @signal_cycles [20, 60, 100, 140, 180, 220]

  defp calc_sig_str(cycles, x_acc, sig_str) do
    if Enum.member?(@signal_cycles, cycles) do
      sig_str + cycles * x_acc
    else
      sig_str
    end
  end

  @doc """
  Part 2

  Render the image given by your program. What eight capital letters appear on your CRT?

  Your puzzle answer is EGLHBLFJ
  """

  @line_len 40

  def solve_2() do
    get_input()
    |> print_screen()
  end

  defp print_screen(instrs) do
    Enum.reduce(instrs, {0, [0, 1, 2]}, fn instr, {cycles, sprite} ->
      exec_print(instr, cycles, sprite)
    end)

    IO.write("\n")
  end

  defp exec_print(instr, cycles, sprite) do
    case instr do
      "noop" ->
        print_pixel(cycles, sprite)
        {cycles + 1, sprite}

      {"addx", val} ->
        print_pixel(cycles, sprite)
        cycles = cycles + 1
        print_pixel(cycles, sprite)
        cycles = cycles + 1
        sprite = move_sprite(sprite, val)
        {cycles, sprite}
    end
  end

  defp print_pixel(cycles, sprite) do
    curr_line = rem(cycles, @line_len)
    if curr_line == 0, do: IO.write("\n")

    if Enum.member?(sprite, curr_line) do
      IO.write("#")
    else
      IO.write(" ")
    end
  end

  defp move_sprite(sprite, val) do
    Enum.map(sprite, fn sub -> sub + val end)
  end

  # common functions

  defp get_input(input \\ "inputs/day10.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      instr = String.split(str)

      case length(instr) do
        1 -> Enum.at(instr, 0)
        2 -> {Enum.at(instr, 0), Enum.at(instr, 1) |> String.to_integer()}
      end
    end)
  end
end
