Mockerator
==========
*it makes mocks (and is a dirty dirty macro)*

## usage ##
Mockerator is intended to make mocks according to a simple specification. In order to define a Mock Module:
```elixir
module = Mockerator.build(MyCoolMock, [{:first_function, 1, "my first response"},
                                       {:second_function, 0, "my second response"}])
module.start
module.first_function(:arg) % -> "my first response"
module.second_function      % -> "my second response"
module.blah                 % -> undefined function error
module.first_function       % -> undefined function error
module.stop
```

### arguments ###
build takes two arguments, the first is an atom representing the Mock Module's name. The second is a list of tuples where each tuple defines {function name (as an atom), arity (number of arguments), response (the default response)}

## todo ##
- Write tests
- Playback arguments passed to the functions
