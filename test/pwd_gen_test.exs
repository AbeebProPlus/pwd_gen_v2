defmodule PwdGenTest do
  use ExUnit.Case

  describe "Password generator" do
    setup do
      parameters = %{
        "length" => "10",
        "numbers" => "false",
        "uppercase" => "false",
        "symbols" => "false"
      }

      {:ok, result} = PwdGen.generate(parameters)

      parameters_type = %{
        lowercase_arr: Enum.map(?a..?z, &<<&1>>),
        digits: Enum.map(0..9, &Integer.to_string(&1)),
        uppercase: Enum.map(?A..?Z, &<<&1>>),
        symbols: String.split("!#$%&()*+,-./:;<=>?@[]^_{|}~", "", trim: true)
      }

      %{
        parameters_type: parameters_type,
        result: result
      }
    end
  end

  test "returns error when no length is provided" do
    param = %{"invalid" => "false"}
    assert {:error, "Provide a length"} = PwdGen.generate(param)
  end

  test "returns error if length is not integer" do
    param = %{"length" => "ab"}
    assert {:error, "Provide an integer"} = PwdGen.generate(param)
  end

  test "returns error with invalid data" do
    param = %{
      "length" => "1",
      "numbers" => "fase",
      "uppercase" => "false",
      "symbols" => "fase"
    }

    assert {:error, "Provide boolean data"} = PwdGen.generate(param)
  end

  test "returns error when no invalid option" do
    param = %{
      "length" => "1",
      "n" => "fase",
      "uppercase" => "false",
      "symbols" => "fase"
    }
    assert {:error, _} = PwdGen.generate(param)
  end
end
