# Julia Abdel-Monem, 2025
# Polymorphic Games

class_name InkDialogueRunner extends Node
## Lookahead interpreter - one step may produce many outputs

@export var dialogue: InkResource

var state: InkInterpreter = null

var path_queue: Array[String]

signal on_start(path: String)

func is_interpretation_complete():
    return state.complete

func reset():

    state = null

func start():
    if state != null:
        reset()

    if state == null:
        # print("Emitting on_start")
        state = InkInterpreter.new(dialogue)

        on_start.emit()

func start_request(request: InkDialogueRequest):
    pass
    if state != null:
        reset()

    if state == null:
        state = InkInterpreter.new(dialogue, request.paths)


## for use only with stubs, do not rely on this to return back to main
func start_at_path(path: String):
    print("Dialogue Runner: Starting from %s" % path)
    reset()
    state = InkInterpreter.new(dialogue, [path])

    on_start.emit(path)


func has_next() -> bool:
    assert(state != null)
    return state.output_queue.size() > 0 or path_queue.size() > 0

func get_next() -> InkOutput.Base:

    var node: InkOutput.Base = state.output_queue.pop_front()
    #print("getting next: output qeueue size: %s" % state.output_queue.size())
    #print("has emitted complete: %s" % state.complete)

    if state.complete and state.output_queue.size() == 0:
        # print("should close on completion")
        node.should_close_on_completion = true

    return node

# one single step
func step():
    var head = state.head()

    if head != null:
        if head.is_interpretation_complete():
            state.pop()
            return

        if head.is_root:
            state.resource_set_root = head.resource_set_root

        for x in head:
            x.run(state)
            if state.must_break:
                state.must_break = false
                break


func _process(_delta: float) -> void:
    if state != null:

        while state.can_continue_interpretation():
            step()
