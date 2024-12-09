import soundfile as sf
import numpy as np
from scipy.signal import butter, filtfilt, find_peaks, square
from scipy.fft import fft, fftfreq

# Constants
WINDOW_TYPE_FFT = 'hann'
FFT_ZERO_PADDING = 4

HARMONIC_TOLERANCE = 10  # Hz
HARMONIC_MULTIPLES = [2, 3]  # Typically harmonics are multiples of 2, 3, etc.
MAX_FUNDAMENTALS = 4  # GBA has 4 sound channels

PEAK_HEIGHT = -60  # dB
PEAK_DISTANCE = 100  # samples
PEAK_TOP_N = 20

AUDIO_DURATION = 1.0  # seconds


def read_wav(path, mono=False):
    data, sample_rate = sf.read(path)
    if mono and data.ndim == 2:
        data = data.mean(axis=1)
    return data, sample_rate

def normalize(audio):
    max_val = np.max(np.abs(audio))
    return audio / max_val if max_val > 0 else audio


def low_pass_filter(audio, sample_rate, cutoff=8000, order=5):
    nyquist = 0.5 * sample_rate
    cutoff = min(cutoff, nyquist - 1)
    normal_cutoff = cutoff / nyquist
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return filtfilt(b, a, audio)


def compute_fft(audio, sample_rate, zero_padding=FFT_ZERO_PADDING, window=WINDOW_TYPE_FFT):
    N = len(audio)
    N_fft = 2 ** (int(np.ceil(np.log2(N))) + zero_padding)
    if window == 'hann':
        window_func = np.hanning(len(audio))
    elif window == 'none':
        window_func = np.ones(len(audio))
    else:
        raise ValueError(f"Unsupported window type: {window}")
    yf = fft(audio * window_func, n=N_fft)
    xf = fftfreq(N_fft, 1 / sample_rate)
    idx = xf >= 0
    xf = xf[idx]
    yf = yf[idx]
    magnitude = 20 * np.log10(np.abs(yf) + 1e-6)  # Added epsilon to avoid log(0)
    return xf, magnitude


def detect_peaks(xf, magnitude, height=PEAK_HEIGHT, distance=PEAK_DISTANCE, top_n=PEAK_TOP_N):
    peaks, properties = find_peaks(magnitude, height=height, distance=distance)
    peak_freqs = xf[peaks]
    peak_magnitudes = magnitude[peaks]
    if len(peak_freqs) > top_n:
        sorted_indices = np.argsort(peak_magnitudes)[::-1]
        top_indices = sorted_indices[:top_n]
        peak_freqs = peak_freqs[top_indices]
        peak_magnitudes = peak_magnitudes[top_indices]
    return peak_freqs, peak_magnitudes


def group_harmonics(peak_freqs, peak_magnitudes, tolerance=HARMONIC_TOLERANCE, multiples=HARMONIC_MULTIPLES):
    fundamentals = []
    harmonics = {}
    fundamental_magnitudes = []
    sorted_indices = np.argsort(peak_magnitudes)[::-1]
    sorted_peaks = peak_freqs[sorted_indices]
    sorted_magnitudes = peak_magnitudes[sorted_indices]

    for freq, mag in zip(sorted_peaks, sorted_magnitudes):
        if any(abs(freq - f) < tolerance for f in fundamentals):
            continue
        fundamentals.append(freq)
        fundamental_magnitudes.append(mag)
        harmonics[freq] = [freq]
        for multiple in multiples:
            harmonic_freq = freq * multiple
            harmonic_peaks = sorted_peaks[np.abs(sorted_peaks - harmonic_freq) < tolerance]
            for hp in harmonic_peaks:
                if hp not in harmonics[freq]:
                    harmonics[freq].append(hp)
        if len(fundamentals) >= MAX_FUNDAMENTALS:
            break  # Limit to the number of GBA sound channels
    return fundamentals, fundamental_magnitudes, harmonics

# utils.py

def generate_noise(t, sample_rate, seed=42):
    np.random.seed(seed)  # Fixed seed for reproducibility
    white_noise = np.random.normal(0, 1, len(t))
    return white_noise * 0.5


def generate_waveform(freq, t, waveform_type='sine'):
    """
    Generates different types of waveforms based on the GBA sound channels.

    Parameters:
        freq (float): Frequency of the waveform.
        t (np.ndarray): Time array.
        waveform_type (str): Type of waveform ('sine', 'square', 'noise').

    Returns:
        np.ndarray: Generated waveform.
    """
    if waveform_type == 'sine':
        return np.sin(2 * np.pi * freq * t)
    elif waveform_type == 'square':
        return square(2 * np.pi * freq * t)
    elif waveform_type == 'noise':
        return generate_noise(t, freq)  # Use pink noise instead of random normal
    else:
        raise ValueError(f"Unsupported waveform type: {waveform_type}")


def reconstruct_signal(fundamentals, magnitudes_db, sample_rate, duration, waveform_types=None):
    """
    Reconstructs a signal from its fundamental frequencies using GBA-like waveforms,
    scaling each waveform based on its magnitude in dB.

    Parameters:
        fundamentals (list): List of fundamental frequencies.
        magnitudes_db (list): List of magnitudes in dB corresponding to each fundamental.
        sample_rate (int): Sampling rate of the audio.
        duration (float): Duration of the reconstructed signal in seconds.
        waveform_types (list): List of waveform types corresponding to each fundamental.

    Returns:
        np.ndarray: Reconstructed audio signal.
    """
    if waveform_types is None:
        waveform_types = ['sine'] * len(fundamentals)  # Default to sine waves

    num_samples = int(sample_rate * duration)
    t = np.linspace(0, duration, num_samples, endpoint=False)
    reconstructed = np.zeros(num_samples)

    # Convert dB magnitudes to linear scale
    magnitudes_linear = [10 ** (mag_db / 20) for mag_db in magnitudes_db]

    for freq, mag, wave_type in zip(fundamentals, magnitudes_linear, waveform_types):
        waveform = generate_waveform(freq, t, waveform_type=wave_type)
        reconstructed += waveform * mag  # Scale waveform by its magnitude

    # Normalize the reconstructed signal to prevent clipping
    if len(fundamentals) > 0:
        max_val = np.max(np.abs(reconstructed))
        if max_val > 0:
            reconstructed /= max_val
    return reconstructed
