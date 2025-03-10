defmodule Day14 do
  @moduledoc """
  --- Day 14: Regolith Reservoir ---

  How many units of sand come to rest before sand starts flowing into the abyss below?

  Your puzzle answer was 618
  """

  @sand ?o
  @rock ?#
  @sand_org {500, 0}

  def solve_1() do
    get_input()
    |> map_rocks()
    |> get_cave_limits()
    |> drop_sand_1(@sand_org)
    |> count_sand()
  end

  defp drop_sand_1({cave_map, lx_max, rx_max, y_max}, {x_sand, y_sand}) do
    # check down
    y_next = y_sand + 1

    if y_next <= y_max do
      case Map.get(cave_map, {x_sand, y_next}) do
        nil ->
          # nothing in the way, keep going down
          drop_sand_1({cave_map, lx_max, rx_max, y_max}, {x_sand, y_next})

        _ ->
          # already occupied with rock or sand, check down and left
          x_next = x_sand - 1

          if x_next >= lx_max do
            case Map.get(cave_map, {x_next, y_next}) do
              nil ->
                # nothing in the way, keep going down and left
                drop_sand_1({cave_map, lx_max, rx_max, y_max}, {x_next, y_next})

              _ ->
                # already occupied with rock or sand, check down and right
                x_next = x_sand + 1

                if x_next <= rx_max do
                  case Map.get(cave_map, {x_next, y_next}) do
                    nil ->
                      # nothing in the way, keep going down and right
                      drop_sand_1({cave_map, lx_max, rx_max, y_max}, {x_next, y_next})

                    _ ->
                      # already occupied with rock or other sand,
                      # sand is stuck at its current location
                      cave_map = Map.put(cave_map, {x_sand, y_sand}, @sand)
                      # drop the next sand
                      drop_sand_1({cave_map, lx_max, rx_max, y_max}, @sand_org)
                  end
                else
                  # sand will fall forever, end here
                  cave_map
                end
            end
          else
            # sand will fall forever, end here
            cave_map
          end
      end
    else
      # sand will fall forever, end here
      cave_map
    end
  end

  @doc """
  Part 2

  How many units of sand come to rest when cave floor is added?

  Your puzzle answer was 26358
  """

  def solve_2() do
    get_input()
    |> map_rocks()
    |> get_cave_limits()
    |> get_floor()
    |> drop_sand_2(@sand_org)
    |> count_sand()
  end

  defp get_floor({cave_map, _lx_max, _rx_max, y_max}) do
    {cave_map, y_max + 2}
  end

  defp drop_sand_2({cave_map, floor}, {x_sand, y_sand}) do
    # check down
    y_next = y_sand + 1

    if y_next == floor do
      # Sand hit the floor, leave it here
      cave_map = Map.put(cave_map, {x_sand, y_sand}, @sand)
      drop_sand_2({cave_map, floor}, @sand_org)
    else
      case Map.get(cave_map, {x_sand, y_next}) do
        nil ->
          # nothing in the way, keep going down
          drop_sand_2({cave_map, floor}, {x_sand, y_next})

        _ ->
          # already occupied with rock or sand, check down and left
          x_next = x_sand - 1

          case Map.get(cave_map, {x_next, y_next}) do
            nil ->
              # nothing in the way, keep going down and left
              drop_sand_2({cave_map, floor}, {x_next, y_next})

            _ ->
              # already occupied with rock or sand, check down and right
              x_next = x_sand + 1

              case Map.get(cave_map, {x_next, y_next}) do
                nil ->
                  # nothing in the way, keep going down and right
                  drop_sand_2({cave_map, floor}, {x_next, y_next})

                _ ->
                  # already occupied with rock or other sand,
                  # sand is stuck at its current location
                  cave_map = Map.put(cave_map, {x_sand, y_sand}, @sand)

                  if {x_sand, y_sand} == @sand_org do
                    # hole is plugged, all done
                    cave_map
                  else
                    # keep dropping sand
                    drop_sand_2({cave_map, floor}, @sand_org)
                  end
              end
          end
      end
    end
  end

  # common functions

  defp get_input(input \\ "inputs/day14.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " -> ", trim: true)
      |> Enum.map(fn pair ->
        [x_str, y_str] = String.split(pair, ",", trim: true)
        {String.to_integer(x_str), String.to_integer(y_str)}
      end)
    end)
  end

  defp map_rocks(lines) do
    Enum.reduce(lines, %{}, fn line, cave_map ->
      place_rocks(cave_map, hd(line), tl(line))
    end)
  end

  defp place_rocks(cave_map, _last_pair, []), do: cave_map

  defp place_rocks(cave_map, {prev_x, prev_y}, [{next_x, next_y} | rem_pairs]) do
    # suppress warning about negative step ranges
    x_range = if prev_x > next_x, do: prev_x..next_x//-1, else: prev_x..next_x
    y_range = if prev_y > next_y, do: prev_y..next_y//-1, else: prev_y..next_y

    cave_map =
      Enum.reduce(x_range, cave_map, fn x, acc_x ->
        Enum.reduce(y_range, acc_x, fn y, acc_y ->
          Map.put(acc_y, {x, y}, @rock)
        end)
      end)

    place_rocks(cave_map, {next_x, next_y}, rem_pairs)
  end

  defp get_cave_limits(cave_map) do
    Enum.reduce(cave_map, {cave_map, 999, 0, 0}, fn {{x, y}, @rock},
                                                    {cave_map, lx_max, rx_max, y_max} ->
      lx_max = if x < lx_max, do: x, else: lx_max
      rx_max = if x > rx_max, do: x, else: rx_max
      y_max = if y > y_max, do: y, else: y_max
      {cave_map, lx_max, rx_max, y_max}
    end)
  end

  defp count_sand(cave_map) do
    Enum.filter(cave_map, fn {{_x, _y}, content} -> content == @sand end) |> Enum.count()
  end
end
