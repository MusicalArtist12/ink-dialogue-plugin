# Documentation

**The most important classes to understand are** `InkDialogueRunner` and `InkOutput.*`.

These are what you will interact with the most when implementing this plugin into your game.

Every output returned by the interpreter is a child class of `InkOutput`.

ChoicePoint implementation is done through the property `InkOutput.Text.options` which is an array of `InkOutput.Option`. `InkOutput.Text` is the generally the default output from the interpreter. Call `InkOutput.Option.select()` to choose that option.

## Overview

This is not a comprehensive overview of every class defined in this plugin. Specficially, `InkValue` and `InkControl` have many child classes.

- `InkDialogueRunner` *extends* `Node`
- `InkInterpreter` *extends* `RefCounted`
- `InkOutput` *extends* `RefCounted`
    - *abstract* `InkOutput.Base` *extends* `RefCounted`
    - `InkOutput.Text` *extends* `InkOutput.Base`
    - `InkOutput.ExternCall` *extends* `InkOutput.Base`
    - `InkOutput.Option` *extends* `RefCounted`
- `InkResource` *extends* `Resource`
    - `InkResourceSet` *extends* `InkResource`
- `InkDialogueRequest` *extends* `Resource`
- *abstract* `InkNode` *extends* `Resource`
    - `InkContainer` *extends* `InkNode`
    - *abstract* `InkValue` *extends* `InkNode`
    - *abstract* `InkControl` *extends* `InkNode`

# InkDialogueRunner

Scene node and the programmer frontend.

Attach a InkResource while editing and call `start()` (`start_request()` or `start_at_path()`) during runtime.

When `has_next()` is true, you can get the next InkOutput by running `get_next()`.

Keeps track of interpretation context using `InkInterpreter`.

After dialogue is complete (`InkOutput.Text.should_close_on_completion == true`), you can clear the last context by calling `reset()`. `is_interpretation_complete()` is only determined if the state has ran into the final `done` command.

*Extends Node*

# InkInterpreter

Keeps track of interpretation state such as the call stack and whether interpretation must wait for input or an external function call. Buffers the output.

*Extends Object.*

## InkOutput

(this is basically a namespace and is not meant to be instantiated)

### `InkOutput.Base`

Abstract Base Class. *Extends Object.*

### `InkOutput.Text`

Normal dialogue text; the default. *Extends Base*

- `options: Array[InkOutput.Option]`: ChoicePoint frontend
- `text`: Display text
- `tags`: metadata
- `should_close_on_completion`: has done been called on this iteration?

### `InkOutput.ExternCall`

External function call. *Extends Base.*

***Incomplete Implementation***

- `function`: Function name
- `args`
- `_state`: ????


### `InkOutput.Option`

ChoicePoint implementation. *Extends Object.*

- `text`: Option Display Text
- `select()`: Called on selection by InkInterpreter


# InkResource

The parsed output of the importer half of this plugin. It stores the JSON tree provided by inklecate using `InkNode` derived objects. *Extends Resource.*

## InkResourceSet

Solution to connecting dialogue trees from two different files. Top level path is changed to `<file_name>.<path>` - `start_request()` and `start_from_path()` will be effected.

# InkDialogueRequest

Pushes every path to the call stack so that they are ran in order without breaks.

## InkNode

An element of the interpretation tree. *Extends Resource.*

`func run(state: InkInterpreter)`: the primary functionality that determines how this node affects the state.

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
