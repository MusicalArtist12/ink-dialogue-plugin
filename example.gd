extends Label

@export var dialouge_runner: InkDialogueRunner


var should_close_on_completion: bool
var paused: bool = false

func continue():
    paused = false

func add_option(txt: String, on_select: Callable):
    print("adding option: %s" % text)

    var button = Button.new()
    # position and location, etc
    button.text = txt
    button.pressed.connect(on_select)
    button.pressed.connect(continue)
    add_child(button)

func set_dialogue(dialogue: InkOutput.Text):
    # remove option buttons...

    text = dialogue.text

    for x in dialogue.options:
        add_option(x.text, x.select)

    if dialogue.should_close_on_completion == true:
        print("setting should_close_on_completion")
        should_close_on_completion = true

func _process(delta: float) -> void:

    if not paused and current_dialogue_runner != null:
        if current_dialogue_runner.has_next():
            var next: InkOutput.Base = current_dialogue_runner.get_next()
            paused = true
            if next is InkOutput.Text:
                set_dialogue(next)
