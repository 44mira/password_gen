defmodule PassGen do
  @moduledoc """
  Password Generator Module
  Main function is generate/1 which takes an options map and returns an {:ok, string()}

  Option tags are:
  - length (integer)  # length of the password
  - uppercase (bool)  # if the password contains uppercase letters
  - lowercase (bool)  # if the password contains lowercase letters
  - numbers (bool)    # if the password contains numbers
  - symbols (bool)    # if the password contains symbols
  """
  @allowed_tags [:length, :uppercase, :lowercase, :numbers, :symbols]
  @tag_types %{
    uppercase: Enum.map(?A..?Z, &<<&1>>),
    lowercase: Enum.map(?a..?z, &<<&1>>),
    numbers:   Enum.map(0..9, &Integer.to_string/1),
    symbols:   String.graphemes("_.-=?")
  }

  @doc """
  Main generator interace, takes in an options map.

  Prefer over generate!/1 for error-handling.

  The processing roadmap goes:
  validate_length/2 -> validate_tags/1 -> generate_string/2

  ## Examples:
    options = %{
      length: 6,
      uppercase: false,
      lowercase: true,
      numbers: true,
      symbols: true

    iex> PassGen.generate(options)
    {:ok, "aed34."}

    options = %{
      length: 3,
      uppercase: false,
      lowercase: false,
      numbers: false,
      symbols: true

    iex> PassGen.generate(options)
    {:ok, ".-?"}
  """
  @spec generate(options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    Map.has_key?(options, :length) |> validate_length(options)
  end

  # check if length key exists and is integer.
  defp validate_length(false, _options), do: {:error, "Please provide length."}
  defp validate_length(true, options) when not is_integer(options.length) and options.length > 0, do: {:error, "Please provide positive integer length."}
  defp validate_length(true, options), do: validate_tags(options)

  # check if all rest of the tags are valid and boolean
  defp validate_tags(options) do
    rest = Map.delete(options, :length)

    if not Enum.empty?(rest) and Enum.all?(rest, fn {k, v} ->
      k in @allowed_tags and is_boolean(v) end) do

      Enum.filter(rest, fn {_k, v} -> v end)
      |> generate_string(options.length)
    else
      {:error, "Please provide valid tags and boolean values."}
    end
  end

  # final processing
  defp generate_string(tags, length) do
    allowed = Enum.flat_map(tags, fn {k, _v} -> @tag_types[k] end)

    # this is preferred over Enum.take_random to allow repetition
    result  = Enum.map(1..length, fn _ -> Enum.random(allowed) end) |> Enum.join
    {:ok, result}
  end

  @doc """
  generate/1 but with no error-handling interface.

  Invalid tag values are treated as false.
  Throws an exception on invalid input or has undefined behavior.

  ## Examples:
    options = %{
      length: 6,
      uppercase: false,
      lowercase: true,
      numbers: true,
      symbols: true

    iex> PassGen.generate!(options)
    "h?e4.l"
  """
  @spec generate!(options :: map()) :: bitstring()
  def generate!(options) do
    allowed = options
      |> Map.delete(:length)
      |> Enum.filter(fn {_k, v} -> v == true end)
      |> Enum.flat_map(fn {k, _v} -> @tag_types[k] end)

    # this is preferred over Enum.take_random to allow repetition
    Enum.map(1..options.length, fn _ -> Enum.random(allowed) end) |> Enum.join
  end
end
