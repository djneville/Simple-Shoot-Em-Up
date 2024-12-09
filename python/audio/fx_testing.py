import os
import time
import sounddevice as sd
import soundfile as sf
from utils import (
    read_wav,
    normalize,
    low_pass_filter,
    detect_peaks,
    group_harmonics,
    reconstruct_signal,
    compute_fft,
)
from plots import (
    plot_waveform,
    plot_spectrogram,
    plot_fft,
    plot_individual_sines_fundamentals,
    plot_reconstructed_signal,
    plot_sine_waves_combined,
)
from fx import AudioEffect

# Constants
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
AUDIO_NAME = "541"
INPUT_WAV_PATH = os.path.join(SCRIPT_DIR, "../assets", f"{AUDIO_NAME}.wav")
OUTPUT_WAV_PATH = os.path.join(SCRIPT_DIR, "output/", f"{AUDIO_NAME}_GBA_reconstructed.wav")

# Visualization Configuration
VISUALIZE_CONFIG = {
    'plot_original': True,    # Plot the original audio waveform and spectrogram
    'plot_processed': False   # Plot the processed audio waveform and spectrogram
}

# Playback Configuration
PLAYBACK_ENABLED = True

# Plotting Duration (seconds)
PLOT_DURATION = 0.1  # Short duration to make sine waves visible

def play_audio(audio, sample_rate, description="Audio"):
    """
    Plays the given audio using the sounddevice library.

    Parameters:
        audio (np.ndarray): Audio signal to play.
        sample_rate (int): Sampling rate of the audio.
        description (str): Description of the audio being played.
    """
    if PLAYBACK_ENABLED:
        print(f"Playing {description}...")
        sd.play(audio, sample_rate)
        sd.wait()

def save_wav(audio, sample_rate, path, description="Reconstructed Audio"):
    """
    Saves the given audio signal to a WAV file with the specified sample rate.
    """
    # Optionally, resample to GBA's expected sample rate if necessary
    if sample_rate != 32768:
        import librosa
        audio = librosa.resample(audio, orig_sr=sample_rate, target_sr=32768)
        sample_rate = 32768
        print(f"Resampled audio to {sample_rate} Hz for GBA compatibility.")

    sf.write(path, audio, sample_rate)
    print(f"Saved {description} to {path}")


def play_reconstructed_audio_file(path, description="GBA Reconstructed Audio"):
    """
    Plays the reconstructed audio from a WAV file.

    Parameters:
        path (str): File path of the WAV file to play.
        description (str): Description of the audio being played.
    """
    data, samplerate = read_wav(path, mono=True)
    play_audio(data, samplerate, description)

def analyze_wav(audio, sample_rate, title="", plot_duration=0.1):
    """
    Analyzes the given audio by plotting its waveform, spectrogram, FFT,
    detecting peaks, grouping harmonics, and visualizing sine wave components.

    Parameters:
        audio (np.ndarray): Audio signal to analyze.
        sample_rate (int): Sampling rate of the audio.
        title (str): Title for the plots.
        plot_duration (float): Duration of the audio segment to plot (in seconds).
    """
    # Normalize the audio signal
    normalized_audio = normalize(audio)

    # Determine the number of samples for the desired plot duration
    num_plot_samples = int(sample_rate * plot_duration)
    num_plot_samples = min(num_plot_samples, len(normalized_audio))
    audio_slice = normalized_audio[:num_plot_samples]

    # Plot waveform and spectrogram for the sliced audio
    plot_waveform(audio_slice, sample_rate, f"{title} - Waveform (First {plot_duration}s)")
    plot_spectrogram(normalized_audio, sample_rate, f"{title} - Spectrogram")

    # Compute FFT and plot
    xf, magnitude = compute_fft(normalized_audio, sample_rate)
    plot_fft(xf, magnitude, sample_rate, f"{title} - FFT")

    # Detect peaks using default parameters
    peak_freqs, peak_magnitudes = detect_peaks(xf, magnitude)
    # Display detected peaks
    print("\nDetected Peaks:")
    for freq, mag in zip(peak_freqs, peak_magnitudes):
        print(f"Frequency: {freq:.2f} Hz, Magnitude: {mag:.2f} dB")

    # Group harmonics to identify fundamental frequencies
    fundamentals, fundamental_magnitudes, harmonics = group_harmonics(peak_freqs, peak_magnitudes)

    # Display fundamental frequencies and their harmonics
    print("\nIdentified Fundamental Frequencies and Their Harmonics:")
    for f, mag in zip(fundamentals, fundamental_magnitudes):
        print(f"Fundamental: {f:.2f} Hz, Magnitude: {mag:.2f} dB")
        print(f"Harmonics: {harmonics[f]}")

    # Define waveform types for each GBA channel
    waveform_types = ['square', 'square', 'sine', 'noise']  # Pulse 1, Pulse 2, Wave, Noise

    # Plot individual waveforms for fundamental frequencies
    plot_individual_sines_fundamentals(audio_slice, sample_rate, fundamentals, title, duration=plot_duration)

    # Reconstruct the entire audio signal from fundamental frequencies with magnitudes
    reconstructed_full = reconstruct_signal(fundamentals, fundamental_magnitudes, sample_rate,
                                            duration=len(audio) / sample_rate, waveform_types=waveform_types)

    # Plot reconstructed signal vs original (using the entire duration)
    plot_reconstructed_signal(normalized_audio, reconstructed_full, sample_rate, title, duration=len(audio)/sample_rate)

    # Plot combined sine waves (using the entire duration)
    plot_sine_waves_combined(fundamentals, sample_rate, duration=len(audio)/sample_rate)

    # Save the reconstructed audio to a WAV file
    save_wav(reconstructed_full, sample_rate, OUTPUT_WAV_PATH, description="GBA Reconstructed Audio")

    # Play the reconstructed audio if playback is enabled
    if PLAYBACK_ENABLED:
        play_reconstructed_audio_file(OUTPUT_WAV_PATH, description="GBA Reconstructed Audio")

def main():
    """
    Main function to execute the audio analysis and visualization workflow.
    """
    # Read and process the filtered audio
    audio_filtered, samplerate_filtered = read_wav(INPUT_WAV_PATH, mono=True)
    filtered_audio = low_pass_filter(audio_filtered, samplerate_filtered)
    analyze_wav(filtered_audio, samplerate_filtered, "Filtered Audio", plot_duration=PLOT_DURATION)

    # Read and process the original audio
    original_audio, samplerate_original = read_wav(INPUT_WAV_PATH, mono=True)
    normalized_original = normalize(original_audio)

    # Visualize the original audio if enabled
    if VISUALIZE_CONFIG.get('plot_original', False):
        analyze_wav(original_audio, samplerate_original, "Original Audio", plot_duration=PLOT_DURATION)

    # Play the original audio if playback is enabled
    if PLAYBACK_ENABLED:
        play_audio(original_audio, samplerate_original, "Original Audio")

    # Pause for a short duration
    time.sleep(1)

    # Apply audio effects (e.g., pitch shifting)
    processed_audio = (
        AudioEffect(original_audio, samplerate_original)
        .pitch_shift(semitones=4.0)
        .build()
    )
    normalized_processed = normalize(processed_audio)

    # Visualize the processed audio if enabled
    if VISUALIZE_CONFIG.get('plot_processed', False):
        analyze_wav(processed_audio, samplerate_original, "Processed Audio", plot_duration=PLOT_DURATION)

    # Play the processed audio if playback is enabled
    if PLAYBACK_ENABLED:
        play_audio(processed_audio, samplerate_original, "Processed Audio")

if __name__ == "__main__":
    main()
