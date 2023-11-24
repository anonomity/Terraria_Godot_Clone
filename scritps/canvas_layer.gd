extends CanvasLayer


var selected_panel = 0
@onready var h_box_container = $ColorRect/HBoxContainer
const SELECTED_PANEL = preload("res://data/selected_panel.tres")
const NORMAL_PANEL = preload("res://data/normal_panel.tres")

	

func _process(delta):
	if Input.is_action_just_pressed("scroll_up"):
		if selected_panel == h_box_container.get_child_count() -1:
			selected_panel = 0
		else:
			selected_panel += 1
		update_panel()
	if Input.is_action_just_pressed("scroll_down"):
		if selected_panel == 0:
			selected_panel = h_box_container.get_child_count() -1
		else:
			selected_panel -=1
		update_panel()

func update_panel():
	for i in range(h_box_container.get_child_count()):
		if i == selected_panel:
			var panel : Panel = h_box_container.get_child(i)
			panel.add_theme_stylebox_override("panel", SELECTED_PANEL)
		else:
			var panel : Panel = h_box_container.get_child(i)
			panel.add_theme_stylebox_override("panel", NORMAL_PANEL)
	
	if selected_panel == 0:
		EventBus.emit_signal("have_sword")
	elif selected_panel == 1:
		EventBus.emit_signal("have_pickaxe")
