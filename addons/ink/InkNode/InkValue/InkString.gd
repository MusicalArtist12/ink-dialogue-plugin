# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkString extends InkValue

@export_storage var value: String

func _init(val: String = "") -> void:
    # print(val)

    value = val.rstrip(' ').lstrip(' ')

    # if value.length() == 0:
    # 	push_warning('an empty InkString exists!!!!')
    # print(value)

func run(state: InterpreterState):
    if state.interpret_as_tag:

        state.tag_buffer.append(value)
    else:
        match state.current_state:
            InterpreterState.InterpreterStateEnum.OUTPUT:
                if state.output_buffer == "":
                    state.output_buffer = value
                else:
                    state.output_buffer = "%s %s" % [state.output_buffer, value]
            InterpreterState.InterpreterStateEnum.CONTENT:
                if state.content_buffer == "":
                    state.content_buffer = value
                else:
                    state.content_buffer = "%s %s" % [state.content_buffer, value]
