defmodule Day5 do
  def part1 do
    taken_seats()
    |> List.last()
    |> IO.inspect(label: "Max Seat")
  end

  def part2 do
    all_taken_seats = taken_seats()

    11..length(all_taken_seats)
    |> Enum.to_list()
    |> Kernel.--(all_taken_seats)
    |> List.first()
  end

  def data do
    "inputs/05.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def taken_seats do
    data()
    |> Enum.map(&calculate_seat_number/1)
    |> Enum.sort()
  end

  def calculate_seat_number(passport) do
    row = partition_search(passport, 0, 127, &slice_rows/1, &partition/2)
    column = partition_search(passport, 0, 7, &slice_columns/1, &partition/2)

    (row * 8) + column
  end

  def partition_search(passport, min, max, slicer_fn, find_fn) do
    passport
    |> slicer_fn.()
    |> String.graphemes()
    |> Enum.reduce(min..max, &find_fn.(&1, &2))
    |> List.first
  end

  def partition("F", list), do: take_lower(list)
  def partition("L", list), do: take_lower(list)
  def partition("R", list), do: take_upper(list)
  def partition("B", list), do: take_upper(list)

  def take_lower(list), do: Enum.take(list, trunc(Enum.count(list) / 2))
  def take_upper(list), do: Enum.take(list, trunc(-(Enum.count(list) / 2)))

  def slice_rows(str), do: String.slice(str, 0, 7)
  def slice_columns(str), do: String.slice(str, 7, 3)
end
