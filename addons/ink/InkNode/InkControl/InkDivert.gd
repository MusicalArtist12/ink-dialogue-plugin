# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkDivert extends InkControl

@export_storage var path: String
@export_storage var divert_target_variable: bool
@export_storage var ex_args: int
@export_storage var extern_function_name: String

enum DivertType {
    STANDARD,
    FUNCTION,
    TUNNEL,
    EXTERN		# args come from the stack, pushed in-order
}

@export_storage var divert_type: DivertType

func _init(p: String = "", dtv: bool = false, type: DivertType = DivertType.STANDARD, args: int = 0) -> void:
    if type != DivertType.EXTERN:
        path = p
    else:
        extern_function_name = p

    divert_target_variable = dtv
    ex_args = args
    divert_type = type

func run(state: InkInterpreter):
    match divert_type:
        DivertType.STANDARD:
            state.pop()
            var node = state.resource.get_node_at_path((state.resource_set_root + '.' + path) if state.resource_set_root != "" else path)

            state.push(node.iterate(false))
        DivertType.TUNNEL:
            var node = state.resource.get_node_at_path((state.resource_set_root + '.' + path) if state.resource_set_root != "" else path)
            state.push(node.iterate(false))
        DivertType.EXTERN:
            state.handle_external_function_call(extern_function_name, ex_args)
