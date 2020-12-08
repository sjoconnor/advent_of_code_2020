defmodule Day1 do
  def data do
    "inputs/01.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def perms(_, 0), do: [[]]
  def perms([], _), do: []
  def perms([head | tail], size) do
    (for elem <- perms(tail, size - 1), do: [head|elem]) ++ perms(tail, size)
  end

  def run(size) do
    data()
    |> perms(size)
    |> Enum.find(fn perm -> Enum.sum(perm) == 2020 end)
    |> IO.inspect(label: "Pair")
    |> Enum.reduce(&(&1 * &2))
    |> IO.inspect(label: "Result")
  end

  def part_1 do
    run(2)
  end

  def part_2 do
    run(3)
  end
end

# Day1.part_1()
# Day1.part_2()
