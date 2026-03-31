# Julia Abdel-Monem, 2025
# Polymorphic Games


@tool
extends EditorImportPlugin


var check_font: Font = null
var create_localization_file: bool = false

func _get_importer_name() -> String:
    return "polymorphic.ink.importer"

func _get_visible_name() -> String:
    return "Ink Script"

func _get_save_extension() -> String:
    return "tres"

func _get_recognized_extensions() -> PackedStringArray:
    return ["ink"]

func _get_resource_type() -> String:
    return "InkResource"

func _get_preset_count():
    return 0

func _get_import_options(_path, _preset_index):
    return [
        {
            "name": "font_to_check_against",
            "default_value": "",
            "hint_text": "Path to font resource to check against"
        }
        # possibly path to inklecate?
    ]

func _get_option_visibility(_path, _option_name, _options):
    return true


func _get_priority() -> float:
    return 1.0

func _get_import_order() -> int:
    return 0

func handle_string(data: String) -> InkNode:
    if data[0] == '^':
        var temp = InkString.new(data.erase(0))

        if check_font != null:
            for chr in temp.value:
                if not check_font.get_supported_chars().contains(chr):
                    push_error("%s: string '%s' contains an unsupported character '%s' " % [_get_importer_name(), temp.value, char])

        return temp
    else:
        if data == "\n":
            data = "newline"
        var temp = InkCommand.new(data)
        return temp

# converts all paths to absolute paths
func handle_path(cwd: String, path: String) -> String:
    var spl = path.split('.')

    var wd = cwd.split('.')

    if spl[0] != "":
        return path
    else:
        var is_first_parent: bool = true
        for x in spl:
            if x == "":
                continue
            elif x == '^':
                if not is_first_parent:
                    wd.reverse()
                    wd.remove_at(0)
                    wd.reverse()
                else:
                    is_first_parent = false
            else:
                wd.push_back(x)


        return '.'.join(wd)

func handle_dict(data: Dictionary, path: String) -> InkNode:
    match data.keys()[0]:
        '->':
            return InkDivert.new(handle_path(path, data['->']), data.get("var", false))
        'f()':
            return InkDivert.new(handle_path(path, data['f()']), false, InkDivert.DivertType.FUNCTION)
        '->t->':
            return InkDivert.new(handle_path(path, data['->t->']), false, InkDivert.DivertType.TUNNEL)
        'x()':
            return InkDivert.new(data['x()'], false, InkDivert.DivertType.EXTERN, int(data.get('exArgs', "0")))
        'VAR=':
            return InkAssign.new(data['VAR='], true, data.get('re', false))
        'temp=':
            return InkAssign.new(data['VAR='], false, data.get('re', false))
        'VAR?':
            return InkReference.new(data["VAR?"])
        'CNT?':
            return InkReadCount.new(data['CNT?'])
        '*':
            return InkChoicePoint.new(handle_path(path, data['*']), data['flg'])
        '^->':
            return InkLambda.new(handle_path(path, data['^->']))
        '^var':
            return InkPointer.new(data['^var'])
        _:
            return null

func make_container(data: Array, path: String) -> InkContainer:
    var container: InkContainer = InkContainer.new()
    container.path = path

    var counter: int = 0
    for x in data:
        if x is Array:
            var temp = make_container(x, "%s.%s" % [path, counter] if path != "" else "%s" % counter)
            counter += 1
            container.arr.append(temp)
        elif x is Dictionary:
            var temp = handle_dict(x, path)
            if temp != null:
                container.arr.append(temp)
                counter += 1
            else:
                for key in x.keys():
                    if key == '#n':
                        container.name = x[key]
                    elif key == '#f':
                        container.flags = int(x[key])
                    else:
                        temp = make_container(x[key], "%s.%s" % [path, key] if path != "" else "%s" % key)
                        container.dict[key] = temp
        elif x is String:
            var temp = handle_string(x)
            container.arr.append(temp)
            counter += 1


    return container

func _import(source_file, save_path, options, _r_platform_variants, _r_gen_files):
    create_localization_file = false
    var font_to_check_against = options['font_to_check_against']

    if font_to_check_against != "":
        check_font = load(font_to_check_against)

    # var file = FileAccess.open(source_file, FileAccess.READ)
#
    # if file == null:
    # 	return FileAccess.get_open_error()

    var json = []

    print("make sure to run `npm install` at res://addons/ink/inklecate")
    print("parsing %s" % source_file)
    var result = OS.execute("node", ["addons/ink/inklecate/compiler.js", ProjectSettings.globalize_path(source_file)], json)

    print("returned %s" % result)
    print(json)

    if result != 0:
        return

    var data = JSON.parse_string(json[0])

    if data == null:
        return null

    var res = InkResource.new()


    res.version = data.get("inkVersion", null)

    if res.version == null:
        return null

    res.root = make_container(data['root'], '')


    return ResourceSaver.save(res, "%s.%s" % [save_path, _get_save_extension()])
