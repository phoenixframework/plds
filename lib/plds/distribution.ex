defmodule PLDS.Distribution do
  @moduledoc false

  require Logger

  def connect_to_nodes!(nodes) do
    [_, host] =
      node()
      |> Atom.to_string()
      |> String.split("@")

    # We get the current node host as host for when connect
    # only have shortnames
    for name <- nodes do
      name =
        if long_name?(name) do
          name
        else
          :"#{name}@#{host}"
        end

      connect_to(name)
    end
  end

  defp long_name?(name) do
    name
    |> Atom.to_string()
    |> String.contains?("@")
  end

  defp connect_to(name) do
    if Node.connect(name) do
      Logger.info("[PLDS] Connected to node #{inspect(name)}")
    else
      PLDS.Utils.abort!("could not connect to node: #{inspect(name)}")
    end
  end
end
