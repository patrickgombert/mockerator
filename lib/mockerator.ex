defmodule Mockerator.Helper do
  def quoted_arguments(arity, name) do
    {arguments, _ } = Enum.map_reduce(:lists.duplicate(arity, "x"), 0, fn(x, number) -> { {list_to_atom(integer_to_list(number)), [], name}, number + 1 } end)
    arguments
  end

  def gen_server_call(module, function_name, arity) do
    {{:.,[],[:gen_server,:call]},[],[module,{function_name,quoted_arguments(arity,module)}]}
  end
end

defmodule Mockerator do
  def build(name, calls) do
    quote do
      unquote do
        defmodule name do
          use GenServer.Behaviour

          def start do
            :gen_server.start({:local, __MODULE__}, __MODULE__, [], [])
          end

          def stop do
            :gen_server.cast(__MODULE__, :shutdown)
          end

          def handle_cast(:shutdown, state) do
            {:stop, :normal, state}
          end

          Enum.each(calls, fn({function_name, arity, response}) ->
            Module.eval_quoted(__MODULE__, {:def,[context: name],
                                                 [{:handle_call,[],[{{function_name,[],name},Mockerator.Helper.quoted_arguments(arity, name)}, {:_info, [],name}, {:state,[],name}]},
                                                 [do: {:"{}",[],[:reply,response,{:state,[],name}]}]]})
            Module.eval_quoted(__MODULE__, {:def,[context: name],
                                                 [{function_name,[],Mockerator.Helper.quoted_arguments(arity, name)},
                                                 [do: Mockerator.Helper.gen_server_call(__MODULE__, function_name, arity)]]})
          end)
        end
      end
    end
    name
  end
end

# Mockerator.build(MyCoolMock, [{:test, 2, "my response"}])
