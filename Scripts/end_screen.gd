extends Control

func _on_restart_button_pressed():
    OS.set_restart_on_exit(true)

func _on_quit_button_pressed():
    get_tree().quit()
