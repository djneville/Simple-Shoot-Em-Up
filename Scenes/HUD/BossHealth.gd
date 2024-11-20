extends Control

@onready var progress_bar := $VBoxContainer/ProgressBar


func update_health(value: int) -> void:
    progress_bar.value = value
