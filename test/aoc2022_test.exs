defmodule Aoc2022Test do
  use ExUnit.Case

  test "Day 1: Calorie Counting, Part 1: Find most total calories" do
    assert Day01.find_most_total_calories() == 72_718
  end

  test "Day 1: Calorie Counting, Part 2: Find top 3 most calories" do
    assert Day01.find_top_3_most_total_calories() == 213_089
  end

  test "Day 2: Rock Paper Scissors, Part 1: Total score strategy 1" do
    assert Day02.calc_total_score1() == 13_526
  end

  test "Day 2: Rock Paper Scissors, Part 2: Total score strategy 2" do
    assert Day02.calc_total_score2() == 14_204
  end

  test "Day 3: Rucksack Reorganization, Part 1: Sum priorities common to both compartments" do
    assert Day03.sum_common_priorities() == 8176
  end

  test "Day 3: Rucksack Reorganization, Part 2: Sum priorities of 3 elf group badges" do
    assert Day03.sum_badge_priorities() == 2689
  end

  test "Day 4: Camp Cleanup, Part 1: Count fully contained assignment pairs" do
    assert Day04.count_contained_pairs() == 305
  end

  test "Day 4: Camp Cleanup, Part 2: Count overlapping assignment pairs" do
    assert Day04.count_overlap_pairs() == 811
  end

  test "Day 5: Supply Stacks, Part 1: What crate ends up on top of each stack (single move)" do
    assert Day05.top_of_stacks() == ~c"CWMTGHBDW"
  end

  test "Day 5: Supply Stacks, Part 2: What crate ends up on top of each stack (multi move)" do
    assert Day05.top_of_stacks2() == ~c"SSCGWJCRB"
  end

  test "Day 6: Tuning Trouble, Part 1: Count of characters to detect start of packet" do
    assert Day06.get_packet_start() == 1623
  end

  test "Day 6: Tuning Trouble, Part 2: Count characters to detect start of message" do
    assert Day06.get_message_start() == 3774
  end

  test "Day 7: No Space Left On Device, Part 1: Total size of dirs less than 100k" do
    assert Day07.total_size_of_dirs_lt_100K() == 1_182_909
  end

  test "Day 7: No Space Left On Device, Part 2: Find smallest dir to delete" do
    assert Day07.find_smallest_dir_to_delete() == 2_832_508
  end

  test "Day 8: Treetop Tree House, Part 1: How many trees visible" do
    assert Day08.solve_1() == 1840
  end

  test "Day 8: Treetop Tree House, Part 2: What is the highest scenic score possible for any tree?" do
    assert Day08.solve_2() == 405_769
  end

  test "Day 9: Rope Bridge, Part 1: How many positions does the tail of the rope visit at least once" do
    assert Day09.solve_1() == 6376
  end

  test "Day 9: Rope Bridge, Part 2: How many positions does the tail of the 10 knot rope visit at least once" do
    assert Day09.solve_2() == 2607
  end

  test "Day 10: Cathode-Ray Tube, Part 1: What is the sum of the six signal strengths" do
    assert Day10.solve_1() == {240, 27, 13920}
  end

  test "Day 10: Cathode-Ray Tube, Part 2: What eight capital letters appear on your CRT" do
    # "EGLHBLFJ"
    assert Day10.solve_2() == :ok
  end
end
