# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkLambda extends InkValue

@export_storage var path: String

func _init(p: String = "") -> void:
    path = p
