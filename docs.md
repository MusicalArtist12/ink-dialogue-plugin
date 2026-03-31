# InkDialogueRunner

Scene node and the programmer frontend.

Attach a InkResource while editing and call `start()` (`start_request()` or `start_at_path()`) during runtime.

When `has_next()` is true, you can get the next DialogueOutput by running `get_next()`.

Keeps track of interpretation context using `InterpreterState`.

After dialogue is complete (`DialogueOutputClasses.Text.should_close_on_completion == true`), you can clear the last context by calling `reset()`. `is_complete()` is only determined if the state has ran into the final `done` command.

*Extends Node*

# InterpreterState

Keeps track of interpretation state such as the call stack and whether interpretation must wait for input or an external function call. Buffers the output.

*Extends Object.*

## DialogueOutputClasses

### `DialogueOutputClasses.Base`

Abstract Base Class. *Extends Object.*

### `DialogueOutputClasses.Text`

Normal dialogue text; the default. *Extends Base*

- `options`: ChoicePoint frontend
- `text`: Display text
- `tags`: metadata
- `should_close_on_completion`: has done been called on this iteration?

### `DialogueOutputClasses.ExternCall`

External function call. *Extends Base.*

***Incomplete Implementation***

- `function`: Function name
- `args`
- `_state`: ????


### `DialogueOutputClasses.Option`

ChoicePoint implementation. *Extends Object.*

- `text`: Option Display Text
- `on_selection`: Called on selection by InterpreterState


# InkResource

The parsed output of the importer half of this plugin. It stores the JSON tree provided by inklecate using `InkNode` derived objects. *Extends Resource.*

## InkResourceSet

Solution to connecting dialogue trees from two different files. Top level path is changed to `<file_name>.<path>` - `start_request()` and `start_from_path()` will be effected.

## InkDialogueRequest

Pushes every path to the call stack so that they are ran in order without breaks.

## InkNode

An element of the interpretation tree. *Extends Resource.*

`func run(state: InterpreterState)`: the primary functionality that determines how this node affects the state.

### InkContainer

- Stores an array and a dictionary of InkNodes. Pushes its iterator to the call stack. *In simple terms, these are basically methods with callable code segments.*

- `arr` nodes are ran when this container is ran
- `dict` nodes are only ran when called either manually or as the result of a `divert` control node.

### InkValue

Abstract base class. Nodes that exend InkValue store data required during runtime. These are basically statements or expressions.

### InkControl

Abstract base class. Nodes that extend InkControl operate on data or the call stack. These effect the interpreter state directly.

### Unimplemented Functionality
- `InkLambda`
- `InkPointer`
- `InkReadCount`
- `InkReference`
- `InkAssign`
- Arithmetic and Logic Commands in `InkCommand`
