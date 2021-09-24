defmodule PLDS.UtilsTest do
  use ExUnit.Case, async: true

  test "ip!/2 parses an IP address" do
    assert {127, 0, 0, 1} = PLDS.Utils.ip!("my-context", "127.0.0.1")
    assert {0, 0, 0, 0, 0, 0, 0, 1} = PLDS.Utils.ip!("my-context", "0:0:0:0:0:0:0:1")
    assert {0, 0, 0, 0, 0, 0, 0, 1} = PLDS.Utils.ip!("my-context", "::1")

    assert_raise RuntimeError,
                 "\nERROR!!! [PLDS] expected my-context to be a valid ipv4 or ipv6 address, got: not a valid IP",
                 fn ->
                   PLDS.Utils.ip!("my-context", "not a valid IP")
                 end
  end

  test "abort!/1 aborts the system" do
    assert_raise RuntimeError, "\nERROR!!! [PLDS] my error message", fn ->
      PLDS.Utils.abort!("my error message")
    end
  end

  test "short_name_with_host?/1" do
    assert PLDS.Utils.short_name_with_host?("foo@bar")
    refute PLDS.Utils.short_name_with_host?("foo@bar.baz")
    refute PLDS.Utils.short_name_with_host?("foo")
  end

  test "long_name?/1" do
    assert PLDS.Utils.long_name?("foo@bar.baz")
    assert PLDS.Utils.long_name?("foo@127.0.0.1")
    refute PLDS.Utils.long_name?("foo")
    refute PLDS.Utils.long_name?("foo@bar")
  end
end
