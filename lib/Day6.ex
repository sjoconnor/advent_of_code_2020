defmodule Day6 do
  def data do
    "inputs/06.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end

  def part1 do
    data()
    |> Enum.map(fn chunk ->
      chunk
      |> String.split()
      |> Enum.flat_map(&String.graphemes/1)
      |> MapSet.new()
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  def part2 do
    data()
    |> Enum.map(fn chunk ->
      chunk
      |> String.graphemes()
      |> MapSet.new()
      |> MapSet.delete("\n")
      |> Enum.count(fn q ->
        chunk
        |> String.split()
        |> Enum.all?(&String.contains?(&1, q))
      end)
    end)
    |> Enum.sum()
  end
end
