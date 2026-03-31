# Julia Abdel-Monem, 2025
# Polymorphic Games

class_name InkResource extends Resource

@export_storage var root: InkContainer
@export_storage var version: int

@export_storage var source_path: String

func get_node_at_path(path: String):
    var spl = path.split('.')

    var node = root

    for point in spl:
        assert(node is InkContainer)
        if point.is_valid_int():
            node = node.arr[int(point)]
        else:
            node = node.dict[point]

    return node
