extends CanvasLayer


var selected_panel = 0
@onready var h_box_container = $ColorRect/HBoxContainer
const SELECTED_PANEL = preload("res://data/selected_panel.tres")
const NORMAL_PANEL = preload("res://data/normal_panel.tres")


func _input(event):
	handle_num(event)
	handle_scroll(event)	


func _process(delta):
	update_panel()

func handle_scroll(event: InputEvent):
	if event is InputEventMouse and Input.is_action_pressed("scroll_up"):
		if selected_panel == h_box_container.get_child_count() -1:
			selected_panel = 0
		else:
			selected_panel += 1
	if Input.is_action_pressed("scroll_down"):
		if selected_panel == 0:
			selected_panel = h_box_container.get_child_count() -1
		else:
			selected_panel -=1
			
func handle_num(event: InputEvent):
	if event is InputEventKey:
		if event.pressed :  # Check if the key is pressed, not released
			var pressed_keycode = event.get_physical_keycode();
			
			match pressed_keycode:	
				KEY_1:
					selected_panel = 0;
				KEY_2:
					selected_panel = 1;
				KEY_3:
					selected_panel = 2	

func update_panel():
	for i in range(h_box_container.get_child_count()):
		if i == selected_panel:
			var panel : Panel = h_box_container.get_child(i)
			panel.add_theme_stylebox_override("panel", SELECTED_PANEL)
		else:
			var panel : Panel = h_box_container.get_child(i)
			panel.add_theme_stylebox_override("panel", NORMAL_PANEL)
	
	match selected_panel:
		0:
			EventBus.emit_signal("have_sword")
		1:
			EventBus.emit_signal("have_pickaxe")
		2:
			EventBus.emit_signal("have_dirt")
