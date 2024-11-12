extends Control

@onready var progress_bar = $VBoxContainer/ProgressBar

func update_health(value):
    progress_bar.value = value
