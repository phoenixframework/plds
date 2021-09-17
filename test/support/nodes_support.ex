defmodule PLDS.NodesSupport do
  @moduledoc false

  # This function helps to spawn new nodes in the
  # current machine.
  def spawn(nodes_names) do
    case :net_kernel.start([:"primary@127.0.0.1"]) do
      {:error, {:already_started, _}} ->
        :erl_boot_server.start([{127, 0, 0, 1}])

      {:ok, _} ->
        :erl_boot_server.start([{127, 0, 0, 1}])

      other ->
        raise "cannot spawn nodes because #{inspect(other)}"
    end

    host = current_host()

    nodes_names
    |> Enum.map(&Task.async(fn -> spawn_node(host, &1) end))
    |> Enum.map(&Task.await(&1, 20_000))
  end

  defp current_host do
    Node.self()
    |> to_string()
    |> String.split("@")
    |> Enum.at(1)
    |> String.to_atom()
  end

  defp spawn_node(host, node_name) do
    {:ok, _node} = :slave.start(host, node_name, inet_loader_args())
  end

  defp inet_loader_args() do
    to_charlist("-loader inet -hosts 127.0.0.1 -setcookie #{Node.get_cookie()}")
  end
end
