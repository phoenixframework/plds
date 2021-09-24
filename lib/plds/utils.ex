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

  @doc """
  Check if this app is running with long name.
  """
  def long_name? do
    node_host() =~ "."
  end

  @doc """
  Similar to long_name?/0, but check the given name.
  """
  def long_name?(name) do
    name =~ "@" and name =~ "."
  end

  @doc """
  Check if the given name is a short name with host.
  """
  def short_name_with_host?(name) do
    String.contains?(name, "@") && not String.contains?(name, ".")
  end

  @doc """
  Returns the host part of a node.
  """
  @spec node_host() :: binary()
  def node_host do
    [_, host] = node() |> Atom.to_string() |> :binary.split("@")

    host
  end
end
