# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkContainer extends InkNode

@export_storage var arr: Array[InkNode]
@export_storage var dict: Dictionary[String, InkNode]

@export_storage var name: String
@export_storage var flags: int
@export_storage var path: String


func _to_string() -> String:
    return "InkContainer '%s' (flags: %x)" % [name, flags]

## iterator for the container's array segmennt
## does not reset upon usage, only on new and .reset()
## this stored onto a stack
class Iter:
    var container: InkContainer
    var current: int
    var resource_set_root: String
    var is_root: bool

    func _init(c: InkContainer, isr: bool, rsr: String = "") -> void:
        current = 0
        resource_set_root = rsr
        is_root = isr

        container = c

    func increment():
        current += 1

    func _iter_init(_iter: Array) -> bool:
        return not is_interpretation_complete()

    func _iter_next(_iter: Array) -> bool:
        return not is_interpretation_complete()

    func _iter_get(_iter: Variant) -> Variant:
        var val = current
        increment()
        return container.arr[val]

    func reset():
        current = 0

    func is_interpretation_complete():
        return current >= container.arr.size()

    func _to_string() -> String:
        return "%s.%s: %s" % [resource_set_root, container.path, current]

func iterate(is_root: bool, rsr: String = "") -> Iter:
    return Iter.new(self, is_root, rsr)

func _init() -> void:
    arr = []
    dict = {}

func run(state: InkInterpreter):

    state.push(iterate(false))
