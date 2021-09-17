defmodule PLDS.DistributionTest do
  use ExUnit.Case, async: true

  test "connect_to_nodes!/1" do
    # Nodes as spawned in test_helper.exs
    nodes = [:ana, :"bob@127.0.0.1"]

    assert :ok = PLDS.Distribution.connect_to_nodes!(nodes)

    assert Enum.sort(Node.list()) == [:"ana@127.0.0.1", :"bob@127.0.0.1"]

    assert_raise RuntimeError,
                 ~s|\nERROR!!! [PLDS] could not connect to node: :"charlie@127.0.0.1"|,
                 fn ->
                   PLDS.Distribution.connect_to_nodes!([:charlie])
                 end
  end
end
