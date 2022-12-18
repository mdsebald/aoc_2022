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
    assert Day05.top_of_stacks() == 'CWMTGHBDW'
  end

  test "Day 5: Supply Stacks, Part 2: What crate ends up on top of each stack (multi move)" do
    assert Day05.top_of_stacks2() == 'SSCGWJCRB'
  end

  test "Day 6: Tuning Trouble, Part 1: Count of characters to detect start of packet" do
    assert Day06.get_packet_start() == 1623
  end

  test "Day 6: Tuning Trouble, Part 2: Count characters to detect start of message" do
    assert Day06.get_message_start() == 3774
  end

  # test "Day 7, Part 1: " do
  #   assert Day07
  # end

  # test "Day 7, Part 2: " do
  #   assert Day07
  # end
end
