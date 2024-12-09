import os
import shutil
import sounddevice as sd
import soundfile as sf

def read_wav(path, mono=False):
    data, sample_rate = sf.read(path)
    if mono and data.ndim == 2:
        data = data.mean(axis=1)
    return data, sample_rate

def play(audio, sample_rate):
    sd.play(audio, sample_rate)
    sd.wait()

def play_audio_files(file_mapping):
    for original_name in file_mapping.keys():
        wav = f"assets/{original_name}"
        audio_data, sample_rate = read_wav(wav)
        print(f"Playing {wav}...")
        play(audio_data, sample_rate)

def rename_and_move_files():
    original_folder = "assets"
    destination_folder = "copied_sounds"

    os.makedirs(destination_folder, exist_ok=True)

    file_mapping = {
        "534.wav": "534_ocarina.wav",
        "114.wav": "114_classic_puzzle_sound.wav",
        "115.wav": "115_echoy.wav",
        "230.wav": "230_echoy.wav",
        "127.wav": "127_justgoodsound.wav",
        "137.wav": "137_industrial.wav",
        "246.wav": "246_shwa.wav",
        "247.wav": "247_shwa.wav",
        "133.wav": "133_echoy.wav",
        "249.wav": "249_alien_dolphin.wav",
        "413.wav": "413_alien_dolphin_1.wav",
        "428.wav": "428_alien_dolphin_3.wav",
        "451.wav": "451_cool_dolphin_trick.wav",
        "326.wav": "326_sad_alien_depress.wav",
        "431.wav": "431_painful_dolphin.wav",
        "477.wav": "477_dolphin.wav",
        "256.wav": "256_bad_sound_bzz.wav",
        "259.wav": "259_futuristic.wav",
        "405.wav": "405_futuruey.wav",
        "343.wav": "343_echoy.wav",
        "322.wav": "322_echoy.wav",
        "261.wav": "261_scary_bell.wav",
        "425.wav": "425_echoy.wav",
        "452.wav": "452_airplane_lift_off_ufo.wav",
        "454.wav": "454_alien.wav",
        "305.wav": "305_barrel_wooden.wav",
        "365.wav": "365_crash_with_buzz.wav",
        "353.wav": "353_bubbly_gross_thick_water.wav",
        "379.wav": "379_bubbly_gross.wav",
        "380.wav": "380_bubbly_gross_2.wav",
        "383.wav": "383_gooey.wav",
        "433.wav": "433_scary_blackness_portal.wav",
        "462.wav": "462_bubbly.wav",
        "466.wav": "466_futuristic_bubbly.wav",
        "469.wav": "469_splash.wav",
        "391.wav": "391_footsteps_running_away.wav",
        "266.wav": "266_some_sound.wav",
        "377.wav": "377_snowy_shwa.wav",
        "541.wav": "541_bwuoo.wav",
        "542.wav": "542_bwouaaa.wav",
        "544.wav": "544_metal_ice_shard.wav",
        "545.wav": "545_metal_ice_shard.wav",
        "135.wav": "135_bubbly_downfall_drown.wav",
    }

    for original_name, new_name in file_mapping.items():
        original_path = os.path.join(original_folder, original_name)
        new_path = os.path.join(destination_folder, new_name)
        if os.path.exists(original_path):
            shutil.copy(original_path, new_path)
    return file_mapping

if __name__ == "__main__":
    # Run rename and move method and get file mapping
    file_mapping = rename_and_move_files()
    # Play audio files using the same file mapping
    play_audio_files(file_mapping)
