defmodule Mockerator.Helper do
  def gen_module_name do
    list_to_atom(:uuid.to_string(:uuid.v4))
  end

  def quoted_arguments(arity, name) do
    {arguments, _} = Enum.map_reduce(:lists.duplicate(arity, "x"), 0, fn("x", number) -> { {list_to_atom(integer_to_list(number)), [], name}, number + 1 } end)
    arguments
  end

  def gen_server_call(module, function_name, arity) do
    {{:.,[],[:gen_server,:call]},[],[module,{function_name,quoted_arguments(arity,module)}]}
  end
end

defmodule Mockerator do
  def build(calls) do
    name = Mockerator.Helper.gen_module_name
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

          function_declarations = Enum.map(calls, fn({function_name, arity, response}) ->
            {{:def,[context: name],
                   [{:handle_call,[],[{function_name,Mockerator.Helper.quoted_arguments(arity, name)}, {:_info,[],name}, {:state,[],name}]},
                   [do: {:"{}",[],[:reply,response,{:state,[],name}]}]]},
             {:def,[context: name],
                   [{function_name,[],Mockerator.Helper.quoted_arguments(arity, name)},
                   [do: Mockerator.Helper.gen_server_call(__MODULE__, function_name, arity)]]}}
          end)
          Enum.each(function_declarations, fn({function, proc_function}) ->
            Module.eval_quoted(__MODULE__, function)
            Module.eval_quoted(__MODULE__, proc_function)
          end)
        end
      end
    end
    name
  end
end
