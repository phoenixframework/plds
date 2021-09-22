defmodule PLDS.Utils do
  @moduledoc false

  @doc """
  Parses and validates the ip from env.
  """
  def ip!(env) do
    if ip = System.get_env(env) do
      ip!(env, ip)
    end
  end

  @doc """
  Parses and validates the ip within context.
  """
  def ip!(context, ip) do
    case ip |> String.to_charlist() |> :inet.parse_address() do
      {:ok, ip} ->
        ip

      {:error, :einval} ->
        abort!("expected #{context} to be a valid ipv4 or ipv6 address, got: #{ip}")
    end
  end

  @halt_on_abort Application.fetch_env!(:plds, :halt_on_abort)

  # Only halt in normal environments. In test it should raise.
  if @halt_on_abort do
    @doc """
    Aborts booting due to a configuration error.
    """
    @spec abort!(String.t()) :: no_return()
    def abort!(message) do
      IO.puts("\nERROR!!! [PLDS] " <> message)
      System.halt(1)
    end
  else
    def abort!(message) do
      raise "\nERROR!!! [PLDS] " <> message
    end
  end
end
