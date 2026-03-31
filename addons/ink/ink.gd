# Julia Abdel-Monem, 2025
# Polymorphic Games

@tool
extends EditorPlugin

var import_plugin
var inspector_plugin

func _enter_tree() -> void:
	inspector_plugin = preload("res://addons/ink/inspector_plugin.gd").new()
	import_plugin = preload("res://addons/ink/import_plugin.gd").new()

	add_inspector_plugin(inspector_plugin)
	add_import_plugin(import_plugin)

func _exit_tree() -> void:

	remove_import_plugin(import_plugin)
	remove_inspector_plugin(inspector_plugin)
	import_plugin = null
	inspector_plugin = null
