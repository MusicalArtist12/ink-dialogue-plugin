# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name DialogueOutputClasses

class Option:
    var text: String
    var on_selection: Callable

    func _init(txt: String, on_sel: Callable) -> void:
        text = txt
        on_selection = on_sel

# variant
class Base:
    pass

class Text extends Base:
    var options: Array[Option]
    var text: String
    var tags: Array[String]
    var should_close_on_completion: bool = false

    func _init(txt: String) -> void:
        text = txt

## make sure to call ExternCall.resolve
class ExternCall extends Base:
    var function: String
    var args: Array[InkValue]
    var _state: InterpreterState

    func _init(s: InterpreterState):
        _state = s

    func resolve():
        print("%s external call has been resolved" % function)
        _state.waiting_for_extern_func_call = false
