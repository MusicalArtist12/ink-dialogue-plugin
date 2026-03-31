# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkCommand extends InkControl

@export_storage var command: String

func _init(cmd: String = "") -> void:
    command = cmd

func run(state: InterpreterState):
    match command:
        "ev":
            assert(state.current_state == InterpreterState.InterpreterStateEnum.OUTPUT)
            state.current_state = InterpreterState.InterpreterStateEnum.LOGICAL
        "/ev":
            assert(state.current_state == InterpreterState.InterpreterStateEnum.LOGICAL)
            state.current_state = InterpreterState.InterpreterStateEnum.OUTPUT
        "str":
            assert(state.current_state == InterpreterState.InterpreterStateEnum.LOGICAL)
            state.current_state = InterpreterState.InterpreterStateEnum.CONTENT
        "/str":
            assert(state.current_state == InterpreterState.InterpreterStateEnum.CONTENT)
            state.current_state = InterpreterState.InterpreterStateEnum.LOGICAL
            state.eval_stack.push_front(InkString.new(state.content_buffer))
            state.content_buffer = ""
        "#":
            state.interpret_as_tag = true
        "/#":
            state.interpret_as_tag = false
        "newline":
            state.handle_newline()
        "done":
            print("ran into done!")
            if state.num_ignore_dones > 0:
                state.num_ignore_dones -= 1
                print("but this is a compound request...")
                return

            state.complete = true
            state.print_call_stack()
