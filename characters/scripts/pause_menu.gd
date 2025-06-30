extends CanvasLayer

@onready var resume_btn: Button = $menu_holder/resume_btn

func _ready():
	visible = false
	
func _process(delta: float):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		resume_btn.grab_focus()

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_menu_prin_btn_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://interface/main_menu.tscn")
	MusicMenu.play_music()
	
func _on_resume_btn_mouse_entered() -> void:
	$HouverSound.play()

func _on_menu_prin_btn_2_mouse_entered() -> void:
	$HouverSound.play()
