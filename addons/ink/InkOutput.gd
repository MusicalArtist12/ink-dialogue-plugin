# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkOutput

class Option:
    var text: String
    var select: Callable

    func _init(txt: String, on_sel: Callable) -> void:
        text = txt
        select = on_sel

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
    var _state: InkInterpreter

    func _init(s: InkInterpreter):
        _state = s

    func resolve():
        print("%s external call has been resolved" % function)
        _state.waiting_for_extern_func_call = false
