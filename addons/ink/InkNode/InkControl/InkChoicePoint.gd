# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkChoicePoint extends InkNode

@export_storage var path: String
@export_storage var flg: int

func _init(p: String = "", _flags: int = 0) -> void:
    path = p

func run(state: InkInterpreter):
    # print('adding %s' % path)
    state.add_option(self)
