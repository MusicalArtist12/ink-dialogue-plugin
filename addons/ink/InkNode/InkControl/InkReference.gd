# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkReference extends InkControl

@export_storage var name: String

func _init(var_name: String = "") -> void:
    name = var_name
