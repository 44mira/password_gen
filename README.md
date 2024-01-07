# PassGen
Password Generator Module

> Built entirely in Elixir.

- [ ] TODO: Unit tests

Ships with two generator functions: `generate/1 and generate!/1` that both take an Option map.

Option tags are:
| Tag | Description |
| --- | ---|
| length (integer)  |  length of the password
| uppercase (bool)  | if the password contains uppercase letters
| lowercase (bool)  | if the password contains lowercase letters
| numbers (bool)    | if the password contains numbers
| symbols (bool)    | if the password contains symbols

> length is a required tag.

```elixir
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

# //------------------------------------------------------------------------------------------//

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
```
