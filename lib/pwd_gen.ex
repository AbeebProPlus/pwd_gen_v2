defmodule PwdGen do
  @symbols "!#$%&()*+,-./:;<=>?@[]^_{|}~"

  def generate(options) do
    validate_length(options)
  end

  defp validate_length(options) do
    has_length = Map.has_key?(options, "length")
    message = "Provide a length"

    if has_length === true do
      validate_length_is_integer(options)
    else
      error(message)
    end
  end

  defp validate_length_is_integer(options) do
    number_arr = Enum.map(0..9, fn x -> Integer.to_string(x) end)
    is_length_int = Enum.member?(number_arr, options["length"])

    if is_length_int == true do
      validate_options_are_boolean(options)
    else
      message = "Provide an integer"
      error(message)
    end
  end

  defp error(message) do
    {:error, message}
  end

  defp validate_options_are_boolean(options) do
    options_without_length = Map.delete(options, "length")
    options_values = Map.values(options_without_length)

    all_booleans =
      Enum.all?(options_values, fn val -> val |> String.to_atom() |> is_boolean() end)

    if all_booleans == true do
      validate_options(options)
    else
      message = "Provide boolean data"
      error(message)
    end
  end

  defp validate_options(options) do
    length_to_integer = options["length"] |> String.trim() |> String.to_integer()
    options_without_length = Map.delete(options, "length")
    new_arr = ["lowercase_letter" | extracted_true_values(options_without_length)]
    IO.puts("#{inspect(extracted_true_values(options_without_length))}")
    random_char_arr = Enum.map(new_arr, &get/1)
    length = length_to_integer - length(random_char_arr)
    random_strings = generate_password(length, options)
    strings = random_char_arr ++ random_strings
    invalid_option? = false in strings

    case invalid_option? do
      true ->
        {:error, "Only options allowed numbers, uppercase, symbols."}

      false ->
        string =
          strings
          |> Enum.shuffle()
          |> to_string()

        {:ok, string}
    end
  end

  defp extracted_true_values(options) do
    Enum.reduce(options, [], fn {k, v}, acc ->
      if v |> String.trim() |> String.to_existing_atom(), do: [k | acc], else: acc
    end)
  end

  defp get("lowercase_letter") do
    <<Enum.random(?a..?z)>>
  end

  defp get("uppercase") do
    <<Enum.random(?A..?Z)>>
  end

  defp get("numbers") do
    <<Enum.random(0..9)>>
  end

  defp get("symbols") do
    @symbols |> String.split("", trim: true) |> Enum.random()
  end

  defp get(_option) do
    false
  end

  defp generate_password(length, options) do
    Enum.map(1..length, fn _ -> options |> Enum.random() |> get() end)
  end
end
