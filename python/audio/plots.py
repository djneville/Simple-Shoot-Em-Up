import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import spectrogram, square

from audio.utils import generate_noise

# Constants
FIGURE_SIZE_WAVEFORM = (10, 4)
FIGURE_SIZE_SPECTROGRAM = (10, 4)
FIGURE_SIZE_FFT = (12, 6)
FIGURE_SIZE_TIME_DOMAIN = (12, 8)
FIGURE_SIZE_RECONSTRUCTED = (12, 6)
FIGURE_SIZE_COMBINED = (12, 6)

FACE_COLOR = 'black'
LINE_COLOR_WAVEFORM = 'white'
LINE_COLOR_SPECTROGRAM = 'viridis'
LINE_COLOR_FFT = 'cyan'
LINE_COLOR_ORIGINAL = 'white'
LINE_COLOR_RECONSTRUCTED = 'red'
LINE_COLOR_COMBINED = 'yellow'
TITLE_COLOR = 'white'
LABEL_COLOR = 'white'
GRID_COLOR = 'gray'
TICK_COLOR = 'white'

LEGEND_LOC_WAVEFORM = 'upper right'
LEGEND_LOC_RECONSTRUCTED = 'upper right'
LEGEND_LOC_COMBINED = 'upper right'
WINDOW_TYPE_FFT = 'hann'

DEFAULT_CUTOFF = 8000  # Hz
DEFAULT_ORDER = 5

PEAK_HEIGHT = -60  # dB
PEAK_DISTANCE = 100  # samples
PEAK_TOP_N = 10

AUDIO_DURATION = 1.0  # seconds
NFFT_SPECTROGRAM = 1024

# GBA Sound Channel Definitions
GBA_CHANNEL_COLORS = ['cyan', 'magenta', 'yellow', 'lime']  # Distinct colors for channels
GBA_CHANNEL_NAMES = ['Pulse 1', 'Pulse 2', 'Wave', 'Noise']  # Channel names

def _setup_plot(figure_size):
    plt.figure(figsize=figure_size, facecolor=FACE_COLOR)
    ax = plt.gca()
    ax.set_facecolor(FACE_COLOR)
    ax.tick_params(axis='x', colors=TICK_COLOR)
    ax.tick_params(axis='y', colors=TICK_COLOR)
    for spine in ax.spines.values():
        spine.set_visible(False)
    plt.tight_layout()

def plot_waveform(audio, sample_rate, title):
    """
    Plots the waveform of the audio signal.

    Parameters:
        audio (np.ndarray): Audio signal slice.
        sample_rate (int): Sampling rate of the audio.
        title (str): Title of the plot.
    """
    times = np.arange(len(audio)) / sample_rate
    _setup_plot(FIGURE_SIZE_WAVEFORM)
    plt.plot(times, audio, color=LINE_COLOR_WAVEFORM)
    plt.title(title, color=TITLE_COLOR)
    plt.xlabel("Time [s]", color=LABEL_COLOR)
    plt.ylabel("Amplitude", color=LABEL_COLOR)
    plt.show()

def plot_spectrogram(audio, sample_rate, title):
    """
    Plots the spectrogram of the audio signal.

    Parameters:
        audio (np.ndarray): Full audio signal.
        sample_rate (int): Sampling rate of the audio.
        title (str): Title of the plot.
    """
    f, t, Sxx = spectrogram(audio, fs=sample_rate, window=WINDOW_TYPE_FFT, nperseg=NFFT_SPECTROGRAM)
    _setup_plot(FIGURE_SIZE_SPECTROGRAM)
    plt.pcolormesh(t, f, 10 * np.log10(Sxx + 1e-10), shading='gouraud', cmap=LINE_COLOR_SPECTROGRAM)
    plt.title(title, color=TITLE_COLOR)
    plt.xlabel('Time [s]', color=LABEL_COLOR)
    plt.ylabel('Frequency [Hz]', color=LABEL_COLOR)
    plt.colorbar(label='Magnitude [dB]')
    plt.show()

def plot_fft(xf, magnitude, sample_rate, title):
    """
    Plots the FFT magnitude spectrum.

    Parameters:
        xf (np.ndarray): Frequency bins.
        magnitude (np.ndarray): Magnitude spectrum in dB.
        sample_rate (int): Sampling rate of the audio.
        title (str): Title of the plot.
    """
    _setup_plot(FIGURE_SIZE_FFT)
    plt.plot(xf, magnitude, color=LINE_COLOR_FFT)
    plt.title(title, color=TITLE_COLOR)
    plt.xlabel('Frequency [Hz]', color=LABEL_COLOR)
    plt.ylabel('Magnitude [dB]', color=LABEL_COLOR)
    plt.grid(True, which='both', linestyle='--', linewidth=0.5, color=GRID_COLOR)
    plt.xlim(0, sample_rate / 2)
    plt.ylim(-100, np.max(magnitude) + 10)
    plt.show()


# plots.py

def plot_individual_sines_fundamentals(audio, sample_rate, fundamentals, title, duration=AUDIO_DURATION,
                                       waveform_types=None):
    """
    Plots individual waveforms corresponding to fundamental frequencies alongside the original audio signal.

    Parameters:
        audio (np.ndarray): Audio signal slice.
        sample_rate (int): Sampling rate of the audio.
        fundamentals (list): List of fundamental frequencies.
        title (str): Title of the plot.
        duration (float): Duration of the plot in seconds.
        waveform_types (list): List of waveform types corresponding to each fundamental.
    """
    num_samples = int(sample_rate * duration)
    num_samples = min(num_samples, len(audio))
    t = np.linspace(0, duration, num_samples, endpoint=False)
    audio_slice = audio[:num_samples]
    _setup_plot(FIGURE_SIZE_TIME_DOMAIN)
    plt.plot(t, audio_slice, color=LINE_COLOR_ORIGINAL, alpha=0.5, label='Original Signal')

    if waveform_types is None:
        waveform_types = ['sine'] * len(fundamentals)

    for idx, (freq, wave_type) in enumerate(zip(fundamentals, waveform_types)):
        if wave_type == 'sine':
            waveform = np.sin(2 * np.pi * freq * t)
        elif wave_type == 'square':
            waveform = square(2 * np.pi * freq * t)
        elif wave_type == 'noise':
            waveform = generate_noise(t, sample_rate)  # Use the same noise generator
        else:
            waveform = np.sin(2 * np.pi * freq * t)  # Default to sine
        color = GBA_CHANNEL_COLORS[idx % len(GBA_CHANNEL_COLORS)]
        channel_name = GBA_CHANNEL_NAMES[idx % len(GBA_CHANNEL_NAMES)]
        plt.plot(t, waveform, label=f'{channel_name}: {freq:.2f} Hz', color=color, alpha=0.7)
        # Annotate the waveform
        plt.text(t[-1], waveform[-1], f'{channel_name}: {freq:.2f} Hz', color=color, fontsize=8,
                 verticalalignment='bottom')

    plt.title(f"{title} - GBA Sound Channels Waveforms", color=TITLE_COLOR)
    plt.xlabel("Time [s]", color=LABEL_COLOR)
    plt.ylabel("Amplitude", color=LABEL_COLOR)
    plt.legend(loc=LEGEND_LOC_WAVEFORM, fontsize='small', ncol=2)
    plt.show()


def plot_reconstructed_signal(original_audio, reconstructed_audio, sample_rate, title, duration=AUDIO_DURATION):
    """
    Plots the original audio signal alongside the reconstructed signal from fundamental frequencies.

    Parameters:
        original_audio (np.ndarray): Original audio signal slice.
        reconstructed_audio (np.ndarray): Reconstructed audio signal.
        sample_rate (int): Sampling rate of the audio.
        title (str): Title of the plot.
        duration (float): Duration of the plot in seconds.
    """
    num_samples = int(sample_rate * duration)
    t = np.linspace(0, duration, num_samples, endpoint=False)
    original_slice = original_audio[:num_samples]
    reconstructed_slice = reconstructed_audio[:num_samples]
    _setup_plot(FIGURE_SIZE_RECONSTRUCTED)
    plt.plot(t, original_slice, color=LINE_COLOR_ORIGINAL, alpha=0.5, label='Original Signal')
    plt.plot(t, reconstructed_slice, color=LINE_COLOR_RECONSTRUCTED, alpha=0.7, label='Reconstructed Signal')
    plt.title(f"{title} - Original vs. Reconstructed", color=TITLE_COLOR)
    plt.xlabel("Time [s]", color=LABEL_COLOR)
    plt.ylabel("Amplitude", color=LABEL_COLOR)
    plt.legend(loc=LEGEND_LOC_RECONSTRUCTED, fontsize='small')
    plt.show()

def plot_sine_waves_combined(fundamentals, sample_rate, duration=AUDIO_DURATION):
    """
    Plots individual sine waves for each fundamental frequency and their combined waveform.

    Parameters:
        fundamentals (list): List of fundamental frequencies.
        sample_rate (int): Sampling rate of the audio.
        duration (float): Duration of the plot in seconds.
    """
    num_samples = int(sample_rate * duration)
    t = np.linspace(0, duration, num_samples, endpoint=False)
    combined = np.zeros(num_samples)
    _setup_plot(FIGURE_SIZE_COMBINED)
    for idx, freq in enumerate(fundamentals):
        sine_wave = np.sin(2 * np.pi * freq * t)
        combined += sine_wave
        color = GBA_CHANNEL_COLORS[idx % len(GBA_CHANNEL_COLORS)]
        channel_name = GBA_CHANNEL_NAMES[idx % len(GBA_CHANNEL_NAMES)]
        plt.plot(t, sine_wave, label=f'{channel_name}: {freq:.2f} Hz', color=color, alpha=0.7)
    if fundamentals:
        combined /= len(fundamentals)
    plt.plot(t, combined, color=LINE_COLOR_COMBINED, label='Combined Sine Waves', linewidth=2)
    plt.title("Combined Fundamental Sine Waves", color=TITLE_COLOR)
    plt.xlabel("Time [s]", color=LABEL_COLOR)
    plt.ylabel("Amplitude", color=LABEL_COLOR)
    plt.legend(loc=LEGEND_LOC_COMBINED, fontsize='small', ncol=2)
    plt.show()
