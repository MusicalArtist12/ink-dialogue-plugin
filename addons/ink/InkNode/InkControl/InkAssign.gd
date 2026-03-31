# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkAssign extends InkControl

@export_storage var name: String
@export_storage var glbl: bool
@export_storage var reassn: bool

func _init(var_name: String = "", global: bool = false, reassign: bool = false) -> void:
    name = var_name
    glbl = global
    reassn = reassign
