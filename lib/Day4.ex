defmodule Day4 do
  defstruct [valid_fields: []]

  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def data do
    "inputs/04.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end

  def run(validation_mode \\ :normal) do
    data()
    |> Enum.map(fn passport ->
      passport
      |> String.split()
      |> Enum.reduce(MapSet.new, &validate(&1, &2, validation_mode))
    end)
    |> IO.inspect
    |> Enum.count(&valid_passport?/1)
    |> IO.inspect
  end

  def part1, do: run()

  def part2, do: run(:strict)

  def valid_passport?(valid_fields) do
    MapSet.equal?(MapSet.new(@required_fields), MapSet.delete(valid_fields, "cid"))
  end

  def validate(field, valid_fields, validation_mode) when is_bitstring(field) do
    field
    |> String.split(":")
    |> List.to_tuple()
    |> validate(valid_fields, validation_mode)
  end

  def validate({"byr", value}, valid_fields, :strict) do
    if within_range?(value, 1920, 2002) do
      MapSet.put(valid_fields, "byr")
    else
      valid_fields
    end
  end

  def validate({"iyr", value}, valid_fields, :strict) do
    if within_range?(value, 2010, 2020) do
      MapSet.put(valid_fields, "iyr")
    else
      valid_fields
    end
  end

  def validate({"eyr", value}, valid_fields, :strict) do
    if within_range?(value, 2020, 2030) do
      MapSet.put(valid_fields, "eyr")
    else
      valid_fields
    end
  end

  def validate({"hgt", value}, valid_fields, :strict) do
    cond do
      String.ends_with?(value, "cm") && within_range?(String.trim_trailing(value, "cm"), 150, 193) ->
        MapSet.put(valid_fields, "hgt")
      String.ends_with?(value, "in") && within_range?(String.trim_trailing(value, "in"), 59, 76) ->
        MapSet.put(valid_fields, "hgt")
      true ->
        valid_fields
    end
  end

  def validate({"hcl", "#" <> <<value::bytes-size(6)>>}, valid_fields, :strict) do
    if String.match?(value, ~r/[0-9a-f]{6}/) do
      MapSet.put(valid_fields, "hcl")
    else
      valid_fields
    end
  end

  @valid_eye_colors ~W(amb blu brn gry grn hzl oth)
  def validate({"ecl", value}, valid_fields, :strict) when value in @valid_eye_colors, do: MapSet.put(valid_fields, "ecl")
  # def validate({"ecl", _value}, valid_fields, :strict), do: valid_fields

  def validate({"pid", value}, valid_fields, :strict) do
    if String.match?(value, ~r/^[0-9]{9}$/) do
      MapSet.put(valid_fields, "pid")
    else
      valid_fields
    end
  end

  def validate({_field, _value}, valid_fields, :strict), do: valid_fields
  def validate({field, _value}, valid_fields, _), do: MapSet.put(valid_fields, field)

  def within_range?(value, min, max) when is_bitstring(value), do: within_range?(String.to_integer(value), min, max)
  def within_range?(value, min, max) when is_integer(value), do: value >= min and value <= max
end
