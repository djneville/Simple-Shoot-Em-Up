import sounddevice as sd
import soundfile as sf
def read_wav_file(path):
    audio_data, samplerate = sf.read(path)
    return audio_data, samplerate
def play(audio, sample_rate):
    sd.play(audio, sample_rate)
    sd.wait()

# name = "534"  # ocarina
# name = "114" # the calssic puzzle sound
# name = "115"  # echoy?
# name = "230" #echoy?
# name = "127"  # GOOOOOOOOD
# name = "137"  # INDUSTRIALLLL
# name = "246"  # and 247 shwaaaaa
# name = "133"  # echoy?
# name = "249"  # aliean dolphin??????
# name = "413"  # ^^???
# name = "428"  # ^^ ##GOOT
# name = "413"  # doplhinaa
# name = "451"  # cool dolphin trick
# name = "326"  # sad alien depress
# name = "431"  # painful dolphin
# name = "477"  # ??dolphin
# name = "256" # BAD SOUND BZZ
# name = "259"  # futuristic
# name = "405"  # futuruey?
# name = "343"  # echoy?
# name = "322"  # echoy?
# name = "261"  #  scary bell
# name = "425"  # echoy?
# name = "452"  # airplane lift off ufo idk
# name = "454"  # alien
# name = "305"  # barrel wtf wooden?
# name = "365"  # crash with buzz first
# name = "353"  # bubbly gross thick water
# name = "379"  # bubbly gross
# name = "380"  # ^^?
# name = "383"  # goooeeyy
# name = "433"  # scary blackness portal suck
# name = "462"  # bubbly
# name = "466"  # futuristically bubbley
# name = "469"  # splash?
# name = "391" #foot steps running away??
# name = "266"
# name = "377"  # snowy? shwa??
# name = "541"  # BWUOOO
# name = "542"  # BWOUAAAA
# name = "544"  # metal ice shard
# name = "545"  # metal ice shard
# name = "135" #bubbley down fall drwon?

def play_audio_files(file_names):
    for name in file_names:
        wav = f"assets/{name}.wav"
        try:
            audio_data, sample_rate = read_wav_file(wav)
            print(f"Playing {wav}...")
            play(audio_data, sample_rate)
        except Exception as e:
            print(f"Failed to play {wav}: {e}")

if __name__ == "__main__":
    file_names = [
        "534", "114", "115", "230", "127", "137", "246", "247", "133",
        "249", "413", "428", "451", "326", "431", "477", "256", "259",
        "405", "343", "322", "261", "425", "452", "454", "305", "365",
        "353", "379", "380", "383", "433", "462", "466", "469", "391",
        "266", "377", "541"
    ]
    play_audio_files(file_names)