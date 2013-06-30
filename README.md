Mockerator
==========
*it makes mocks*

## usage ##
Mockerator is intended to make mocks according to a simple specification. In order to define a Mock Module:
```elixir
module = Mockerator.build([{:first_function, 1, "my first response"},
                           {:first_function, 2, "my other first response"},
                           {:second_function, 0, "my second response"}])
module.start
module.first_function(:arg)         % -> "my first response"
module.first_function(:arg1, :arg2) % -> "my other first response"
module.second_function              % -> "my second response"
module.blah                         % -> undefined function error
module.first_function               % -> undefined function error
module.stop
```

### arguments ###
Build takes one argument, a list of tuples where each tuple defines {function name (as an atom), arity (number of arguments), response (the default response)}

### response ###
Returned from build is a fully defined module with your mock functions and responses. Call `start` to start the mock and `stop` to stop the mock.

## todo ##
- Playback arguments passed to the functions
