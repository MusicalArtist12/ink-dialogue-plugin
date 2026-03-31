# Julia Abdel-Monem, 2025
# Polymorphic Games


class_name InkInterpreter



var _call_stack: Array[InkContainer.Iter] ## stores a custom iterator, which when not in use is stored at the next element to run
var resource_set_root: String = "" # set by the runner when a container is_root and has resource_set_root

var must_break: bool = false		# tells runner that the state has changed


var num_ignore_dones: int = 0

## Comms with InkDialogueRunner
var complete: bool = false

var waiting_for_input: bool = false # tells runner that interpretation is waiting for a choice

var waiting_for_extern_func_call: bool = false # tells runner that there is an external function in the queue and since it may change the state, wait for it

func can_continue_interpretation() -> bool:
    return not (waiting_for_input or waiting_for_extern_func_call or complete)

var resource: InkResource

var eval_stack: Array[InkValue]

# in str, /str stuff goes here. at /str it is moved to the eval stack
var content_buffer: String

var output_buffer: String
var tag_buffer: Array[String]

var option_buffer: Array[InkOutput.Option]



enum States {
    LOGICAL,
    CONTENT,
    OUTPUT
}

var interpret_as_tag: bool = false

var current_state: States = States.OUTPUT

var output_queue: Array[InkOutput.Base]



# call_stack operators push(), pop(), head()
#region
func push(iter: InkContainer.Iter):
    must_break = true
    _call_stack.push_front(iter)

    #print("push: size: %s, is_interpretation_complete? %s, waiting_for_input? %s" % [output_queue.size(), complete, waiting_for_input])
    #print_call_stack()

func enqueue(iter: InkContainer.Iter):
    _call_stack.push_back(iter)

func pop():
    _call_stack.pop_front()

    #print("pop: size: %s, is_interpretation_complete? %s, waiting_for_input? %s" % [output_queue.size(), complete, waiting_for_input])
    #print_call_stack()

    if not option_buffer.is_empty():
        handle_newline()
        waiting_for_input = true

    elif _call_stack.size() == 0:
        complete = true


func head() -> InkContainer.Iter:
    if _call_stack.is_empty():
        must_break = true
        push_error("call stack is empty for some reason")
        assert(false, "call stack is empty")
        return null

    return _call_stack.front()
#endregion


func select_option(iter: InkContainer.Iter):
    push(iter)
    waiting_for_input = false

func add_option(cp: InkChoicePoint):
    var text: InkString = eval_stack.pop_front()
    # print(_call_stack)

    var iter: InkContainer.Iter

    iter = resource.get_node_at_path((resource_set_root + '.' + cp.path) if resource_set_root != "" else cp.path).iterate(false)

    var option: InkOutput.Option = InkOutput.Option.new(text.value, select_option.bind(iter))
    option_buffer.push_back(option)

func handle_external_function_call(function: String, num_args: int):
    var args: Array[InkValue]

    for x in range(num_args):
        args.push_front(eval_stack.pop_front)

    print("calling %s with %s args" % [function, num_args])

    var output = InkOutput.ExternCall.new(self)
    output.function = function
    output.args = args

    waiting_for_extern_func_call = true

    output_queue.push_back(output)


func handle_newline():
    if output_buffer.length() > 0 or option_buffer.size() > 0:
        var output = InkOutput.Text.new(output_buffer.strip_edges())
        output.options = option_buffer.duplicate(true)
        output.tags = tag_buffer.duplicate(true)
        option_buffer = []
        tag_buffer = []
        output_buffer = ""

        output_queue.push_back(output)

func _init(res: InkResource = null, queue: Array[String] = []) -> void:
    _call_stack = []
    output_buffer = ""
    tag_buffer = []
    output_queue = []

    if res != null:
        resource = res
        if queue.size() == 0:
            assert(res is not InkResourceSet, "an empty queue does not make sense with an InkResourceSet")
            enqueue(res.root.iterate(true))
        else:
            num_ignore_dones = queue.size() - 1
            for path in queue:
                var node = res.get_node_at_path(path)
                if res is InkResourceSet:
                    var rsr = path.split('.')[0]
                    enqueue(node.iterate(true, rsr))
                else:
                    enqueue(node.iterate(true))


func print_call_stack():
    for x in _call_stack:
        print_debug("\t%s" % x.to_string())
