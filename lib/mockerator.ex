defmodule Mockerator.Helper do
  def gen_module_name do
    list_to_atom(:uuid.to_string(:uuid.v4))
  end

  def quoted_arguments(arity, name) do
    {arguments, _} = Enum.map_reduce(:lists.duplicate(arity, "x"), 0, fn("x", number) -> { {list_to_atom(integer_to_list(number)), [], name}, number + 1 } end)
    arguments
  end
end

defmodule Mockerator do
  def build(name // Mockerator.Helper.gen_module_name, calls) do
    defmodule name do
      use GenServer.Behaviour

      def start do
        :gen_server.start({:local, __MODULE__}, __MODULE__, [], [])
      end

      def stop do
        :gen_server.cast(__MODULE__, :shutdown)
      end

      def call_history do
        :gen_server.call(__MODULE__, :call_history)
      end

      def init do
        {:ok, []}
      end

      def handle_call(:call_history, _info, state) do
        {:reply, state, state}
      end

      def handle_cast(:shutdown, state) do
        {:stop, :normal, state}
      end

      function_declarations = Enum.map(calls, fn({function_name, arity, response}) ->
        escaped_response = Macro.escape(response)
        { {:def,[context: name],
                [{:handle_call,[],[{function_name,Mockerator.Helper.quoted_arguments(arity, name)}, {:_info,[],name}, {:state,[],name}]},
                [do:
                  quote do
                    state = state ++ [{unquote(function_name), unquote(Mockerator.Helper.quoted_arguments(arity, name))}]
                    {:reply, unquote(escaped_response), state}
                  end]]},
          {:def,[context: name],
                [{function_name,[],Mockerator.Helper.quoted_arguments(arity, name)},
                [do:
                  quote do
                  :gen_server.call(__MODULE__, {unquote(function_name), unquote(Mockerator.Helper.quoted_arguments(arity, name))})
                  end]]} }
      end)
      Enum.each(function_declarations, fn({function, proc_function}) ->
        Module.eval_quoted(__MODULE__, function)
        Module.eval_quoted(__MODULE__, proc_function)
      end)
    end
    name
  end
end
