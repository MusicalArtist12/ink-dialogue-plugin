# combines a set of InkResources with a subpath

class_name InkResourceSet extends InkResource

## the key the path name
@export var dict: Dictionary[String, InkResource]

func get_node_at_path(path: String):
    var spl = path.split('.')

    var top_level = spl[0]

    spl.remove_at(0)

    var rest = ".".join(spl)


    assert(dict.has(top_level), "this node does have path %s. it has children %s" % [path, ", ".join(dict.keys())])

    return dict[top_level].get_node_at_path(rest)
