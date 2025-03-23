defmodule Day15 do
  @moduledoc """
  --- Day 15: Beacon Exclusion Zone ---

  In the row where y=2000000, how many positions cannot contain a beacon?

  Your puzzle answer was 5688618
  """
  @target_row 2_000_000

  def solve_1() do
    get_input()
    |> get_coverage_at_row(@target_row)
    |> sum_ranges()
  end

  defp get_coverage_at_row(sensors_and_beacons, target_row) do
    sensors_and_beacons
    |> calc_sensor_beacon_dist()
    |> calc_sensor_row_coverage(target_row)
    |> merge_ranges()
  end

  defp calc_sensor_row_coverage(sensors_and_distances, target_row) do
    Enum.map(sensors_and_distances, fn {{sx, sy}, distance} ->
      # Calculate how far the sensor's coverage extends at the target row
      y_distance = abs(sy - target_row)
      remaining_distance = distance - y_distance

      if remaining_distance >= 0 do
        {sx - remaining_distance, sx + remaining_distance}
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp sum_ranges(ranges) do
    Enum.map(ranges, fn {start_x, end_x} -> end_x - start_x end) |> Enum.sum()
  end

  @doc """
  Part 2

  Find the only possible position for the distress beacon. What is its tuning frequency?

  Your puzzle answer was 12625383204261
  """
  @target_max 4_000_000

  def solve_2() do
    get_input("inputs/day15.txt")
    |> get_coverage_over_range(@target_max)
    |> calc_tuning_freq()
  end

  defp get_coverage_over_range(sensors_and_beacons, target_max) do
    Enum.reduce_while(0..target_max, 0, fn row, _range_gap ->
      get_coverage_at_row(sensors_and_beacons, row, target_max)
      |> find_range_gap(row)
    end)
  end

  defp get_coverage_at_row(sensors_and_beacons, target_row, max) do
    sensors_and_beacons
    |> calc_sensor_beacon_dist()
    |> calc_sensor_row_coverage(target_row, max)
    |> merge_ranges()
  end

  defp calc_sensor_row_coverage(sensors_and_distances, target_row, max) do
    Enum.map(sensors_and_distances, fn {{sx, sy}, distance} ->
      # Calculate how far the sensor's coverage extends at the target row
      y_distance = abs(sy - target_row)
      remaining_distance = distance - y_distance

      if remaining_distance >= 0 do
        {max(0, sx - remaining_distance), min(max, sx + remaining_distance)}
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp find_range_gap(ranges, row) do
    if Enum.count(ranges) > 1 do
      [{_x0, x1}, {_x2, _x3}] = Enum.sort(ranges)
      {:halt, {x1 + 1, row}}
    else
      {:cont, 0}
    end
  end

  defp calc_tuning_freq({x, y}) do
    x * 4_000_000 + y
  end

  # common functions

  defp get_input(input \\ "inputs/day15.txt") do
    regex = ~r/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/

    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, sx, sy, bx, by] = Regex.run(regex, line)

      {
        {String.to_integer(sx), String.to_integer(sy)},
        {String.to_integer(bx), String.to_integer(by)}
      }
    end)
  end

  defp calc_sensor_beacon_dist(sensors_and_beacons) do
    Enum.map(sensors_and_beacons, fn {{sx, sy}, {bx, by}} ->
      {{sx, sy}, abs(sx - bx) + abs(sy - by)}
    end)
  end

  defp merge_ranges(ranges) do
    Enum.sort(ranges)
    |> Enum.reduce([], fn range, acc ->
      merge_range(range, acc)
    end)
  end

  defp merge_range(range, []) do
    [range]
  end

  defp merge_range({start_x, end_x}, [{prev_start, prev_end} | rest]) do
    # If the current range overlaps with the previous one
    if start_x <= prev_end + 1 do
      # Merge them
      [{prev_start, max(prev_end, end_x)} | rest]
    else
      # Otherwise, add the current range to the list
      [{start_x, end_x}, {prev_start, prev_end} | rest]
    end
  end
end
