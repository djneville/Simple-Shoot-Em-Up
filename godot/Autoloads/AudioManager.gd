extends Node

enum SoundType {
    SFX,
    MUSIC,
}

const POOL_SIZE: int = 10  # maximum number of simultaneous sounds
var audio_pool: Array[AudioStreamPlayer] = []
var available_stream_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
    for i in range(POOL_SIZE):
        var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
        audio_player.autoplay = false
        audio_player.bus = "SFX" #TODO: figure out what this is for signal handling?
        audio_player.finished.connect(_on_audio_finished.bind(audio_player))
        add_child(audio_player)
        audio_pool.append(audio_player)
        available_stream_players.append(audio_player)

    # TODO: remember this play sound will get an argument assigned to it during emission, so when entering it will have the sound name
    # TODO: python is corrupting the sounds upon play, but they work here??
    SignalBus.play_sfx.connect(self.play_sound)


func play_sound(sound_res: Resource, volume: float = 0.6) -> void:
    var audio_stream: AudioStream = sound_res as AudioStream #???
    if available_stream_players.is_empty():
        push_warning("AudioManager: No available AudioStreamPlayer in the pool to play sound - " + sound_res.resource_name)
        return

    var audio_player: AudioStreamPlayer = available_stream_players.pop_back()
    audio_player.stream = audio_stream
    audio_player.volume_db = linear_to_db(volume)
    audio_player.play()

func _on_audio_finished(audio_player: AudioStreamPlayer) -> void:
    audio_player.stop()
    #reset the stream
    audio_player.stream = null
    #put it back into the pool
    available_stream_players.append(audio_player)

func linear_to_db(linear: float) -> float:
    if linear <= 0.0:
        return -80.0  # Effectively silent
    return 20.0 * log(linear)

func stop_all_sfx() -> void:
    for audio_player in audio_pool:
        if audio_player.playing:
            audio_player.stop()
            available_stream_players.append(audio_player)
