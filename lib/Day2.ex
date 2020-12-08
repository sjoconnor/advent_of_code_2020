defmodule Day2 do
  def data do
    "inputs/02.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def run(validator) when validator in [Day2.PasswordValidator1, Day2.PasswordValidator2] do
    Enum.count(data(), fn line ->
      line
      |> validator.validate()
      |> Map.get(:valid?)
    end)
  end

  defmodule Validator do
    defstruct [:num1, :num2, :password, :required_char, valid?: true]

    @callback validate(String.t()) :: %{valid?: boolean()}

    def extract(line) do
      [num1_num2, <<required_char::bytes-size(1)>> <> ":", password] = String.split(line)
      [num1, num2] = String.split(num1_num2, "-")

      %__MODULE__{
        num1: String.to_integer(num1),
        num2: String.to_integer(num2),
        password: password,
        required_char: required_char
      }
    end
  end

  defmodule PasswordValidator1 do
    @behaviour Validator

    @impl Validator
    def validate(line) when is_bitstring(line), do: validate(Day2.Validator.extract(line))
    def validate(%{num1: min, num2: max, password: password, required_char: required_char} = validator) do
      char_frequency = frequency(password, required_char)

      cond do
        char_frequency >= min and char_frequency <= max ->
          %{validator | valid?: true}
        true ->
          %{validator | valid?: false}
      end
    end

    defp frequency(password, char) do
      password
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.get(char)
    end
  end

  defmodule PasswordValidator2 do
    @behaviour Validator

    @impl Validator
    def validate(line) when is_bitstring(line), do: validate(Day2.Validator.extract(line))
    def validate(%{required_char: required_char, password: password, num1: num1, num2: num2} = validator) when is_struct(validator) do
      case valid?(required_char, String.at(password, num1 - 1), String.at(password, num2 - 1)) do
       true -> %Day2.Validator{valid?: true}
        _ -> %Day2.Validator{valid?: false}
      end
    end

    defp valid?(required_char, pos_1, pos_2) when pos_1 == required_char and pos_2 != required_char, do: true
    defp valid?(required_char, pos_1, pos_2) when pos_1 != required_char and pos_2 == required_char, do: true
    defp valid?(_required_char, _pos_1, _pos_2), do: false
  end

end

# Day2.run(Day2.PasswordValidator1) |> IO.inspect(label: "count")
# Day2.run(Day2.PasswordValidator2) |> IO.inspect(label: "count")
