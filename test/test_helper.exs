unless Node.alive?() do
  {_, 0} = System.cmd("epmd", ["-daemon"])
end

PLDS.NodesSupport.spawn([:ana, :bob])

ExUnit.start()
