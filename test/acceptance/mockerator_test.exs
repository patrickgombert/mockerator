Code.require_file "test/test_helper.exs"

defmodule MockeratorTest do
  use ExUnit.Case

  test "it builds a no arity function" do
    module = Mockerator.build([{:func, 0, "response"}])
    module.start
    assert module.func == "response"
    module.stop
  end

  test "it builds a single arity function" do
    module = Mockerator.build([{:func, 1, "response"}])
    module.start
    assert module.func(:anything) == "response"
    module.stop
  end

  test "it builds a multiple arity function" do
    module = Mockerator.build([{:func, 3, "response"}])
    module.start
    assert module.func(1, 2, 3) == "response"
    module.stop
  end

  test "it builds multiple functions" do
    module = Mockerator.build([{:func, 0, "response"}, {:other_func, 0, "other response"}])
    module.start
    assert module.func == "response"
    assert module.other_func == "other response"
    module.stop
  end
end
