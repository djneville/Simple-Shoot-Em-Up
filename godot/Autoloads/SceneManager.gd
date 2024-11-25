extends Node

const MAIN_MENU: String = "res://godot/Menus/MainMenu.tscn"

const MAIN_GAME_LOOP: String = "res://godot/Scenes/MainScene.tscn"

const BOSS_FIGHT: String = "res://godot/Scenes/BossFight.tscn"

const LEVEL_SELECT: String = "res://godot/Menus/LevelSelectScreen.tscn"

const PAUSE: String = "res://godot/Menus/PauseScreen.tscn"

const GAME_OVER: String = "res://godot/Menus/GameOverScreen.tscn"

const LEVEL_COMPLETE: String = "res://godot/Menus/LevelCompleteScreen.tscn"

#TODO: fix the pause screen to not be able to show up during other menus being open
var pause_screen_scene: PackedScene = preload(PAUSE)
var pause_screen_instance: PauseScreen

#TODO: optional (saves the progress of the game loop)
var game_over_screen_paused: PackedScene = preload(GAME_OVER)
var game_over_screen_paused_instance: GameOverScreen

# Added variables for fade transition
var color_rect: ColorRect

func _ready() -> void:
    set_process_input(true)
    process_mode = Node.PROCESS_MODE_ALWAYS  # Ensure input is processed when paused
    #TODO: this can also allow for a gameover screen to only serve as a pause screen
    # so player doesnt have to start from the beginning again
    SignalBus.game_over.connect(change_scene.bind(GAME_OVER))
    SignalBus.level_complete.connect(change_scene.bind(LEVEL_COMPLETE))

    # Initialize ColorRect
    color_rect = ColorRect.new()
    color_rect.size = get_viewport().size
    color_rect.color = Color(0, 0, 0, 0)  # Black, fully transparent
    add_child(color_rect)

func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("pause"):
        if get_tree().paused:
            unpause()
        else:
            pause()
    if Input.is_action_just_pressed("fade_in"):
        fade_in()
    if Input.is_action_just_pressed("fade_out"):
        fade_out()

func pause() -> void:
    get_tree().paused = true
    if not pause_screen_instance:
        pause_screen_instance = pause_screen_scene.instantiate()
        pause_screen_instance.process_mode = Node.PROCESS_MODE_ALWAYS
        #TODO: not sure if i like this logic in here. Feel like it should be in the pause screen???
        pause_screen_instance.resume_game.connect(unpause)
        pause_screen_instance.quit_to_menu.connect(_on_quit_to_menu)
        pause_screen_instance.quit_game.connect(_on_quit_game)
        get_tree().get_root().add_child(pause_screen_instance)
    pause_screen_instance.show()

func unpause() -> void:
    get_tree().paused = false
    if pause_screen_instance:
        pause_screen_instance.hide()

func _on_quit_to_menu() -> void:
    unpause()
    self.change_scene(MAIN_MENU)

func _on_quit_game() -> void:
    unpause()
    get_tree().quit()

func _on_gameover_pause_progress() -> void:
    pass

#get_tree().paused = true
#if not game_over_screen_paused_instance:
#game_over_screen_paused_instance = pause_screen_scene.instantiate()
#game_over_screen_paused_instance.process_mode = Node.PROCESS_MODE_ALWAYS
#get_tree().get_root().add_child(pause_screen_instance)
#pause_screen_instance.show()

func change_scene(scene_path: String) -> void:
    fade_out()
    get_tree().change_scene_to_file(scene_path)
    fade_in()

func fade_out(duration: float = 1.5) -> void:
    var tween = create_tween()
    print("FADE IN!!!")
    tween.tween_property(color_rect, "modulate:a", 1.0, duration)
    await tween.finished

func fade_in(duration: float = 1.5) -> void:
    var tween = create_tween()
    print("FADE OUT!!!")
    tween.tween_property(color_rect, "modulate:a", 0.0, duration)
    await tween.finished