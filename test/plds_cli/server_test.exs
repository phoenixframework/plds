defmodule PLDSCli.ServerTest do
  use ExUnit.Case, async: true

  alias PLDSCli.Server, as: Cli

  test "args_to_options/1 raises with invalid options" do
    assert [] == PLDSCli.Server.args_to_options([])

    assert [
             sname: "foo",
             connect: "bar",
             connect: "baz",
             cookie: "mycookie",
             port: 9000,
             ip: "192.168.0.1"
           ] ==
             Cli.args_to_options(
               ~w(--sname foo -c bar -c baz --cookie mycookie --port 9000 --ip 192.168.0.1)
             )

    assert_raise RuntimeError,
                 "the provided --sname and --name options are mutually exclusive, please specify only one of them",
                 fn ->
                   Cli.args_to_options(~w(--name foo@bar.baz --sname foo))
                 end

    assert_raise RuntimeError,
                 "the provided connections should have long names because you specified the --name option",
                 fn ->
                   Cli.args_to_options(~w(--name foo@bar.baz -c short@name))
                 end

    assert_raise RuntimeError,
                 "the provided --name option should include the full host name",
                 fn ->
                   Cli.args_to_options(~w(--name foo@bar -c long@example.com))
                 end

    assert_raise RuntimeError,
                 "the provided connections should have short names because you specified the --sname option",
                 fn ->
                   Cli.args_to_options(~w(--sname foo@bar -c long@example.com))
                 end
  end
end
