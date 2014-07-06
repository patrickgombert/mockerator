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

  test "it replays call history" do
    module = Mockerator.build([{:func, 1, "response"}])
    module.start
    module.func("param")
    assert module.call_history == [func: ["param"]]
    module.stop
  end

  test "it handles tuple types" do
    response = {:a, :b, :c}
    module = Mockerator.build([{:func, 0, response}])
    module.start
    assert module.func == response
    module.stop
  end

  test "it handles the README example" do
    module = Mockerator.build([{:first_function, 1, "my first response"},
                               {:first_function, 2, "my other first response"},
                               {:second_function, 0, "my second response"}])
    module.start
    assert module.first_function(:arg) == "my first response"
    assert module.first_function(:arg1, :arg2) == "my other first response"
    assert module.second_function == "my second response"
    assert module.call_history == [first_function: [:arg], first_function: [:arg1, :arg2], second_function: []]
    module.stop
  end
end
