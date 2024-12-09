import numpy as np
import librosa
from scipy.signal import lfilter
from utils import normalize


def apply_eq(audio, sample_rate, frequency, gain_db, Q):
    A = 10 ** (gain_db / 40)
    omega = 2 * np.pi * frequency / sample_rate
    alpha = np.sin(omega) / (2 * Q)
    b0 = 1 + alpha * A
    b1 = -2 * np.cos(omega)
    b2 = 1 - alpha * A
    a0 = 1 + alpha / A
    a1 = -2 * np.cos(omega)
    a2 = 1 - alpha / A
    b = np.array([b0, b1, b2]) / a0
    a = np.array([1, a1 / a0, a2 / a0])
    return lfilter(b, a, audio)


def apply_pitch_shift(audio, sample_rate, semitones):
    return librosa.effects.pitch_shift(audio.astype(np.float32), sr=sample_rate, n_steps=semitones)


def apply_delay(audio, sample_rate, time_ms, feedback):
    delay_samples = int((time_ms / 1000.0) * sample_rate)
    out = np.copy(audio)
    out[delay_samples:] += out[:-delay_samples] * feedback
    return out


def apply_saturation(audio, drive):
    driven = audio * (1 + drive)
    return np.tanh(driven)


def apply_distortion(audio, gain, threshold):
    amplified = audio * gain
    return np.clip(amplified, -threshold, threshold)


def apply_reverb(audio, sample_rate, room_size, delays, decays):
    output = np.copy(audio)
    for delay, decay in zip(delays, decays):
        n_delay = int(delay * sample_rate)
        padded = np.pad(audio, (n_delay, 0), 'constant')[:len(audio)]
        output += padded * decay * room_size
    return normalize(output)


def apply_flanger(audio, sample_rate, delay_ms, depth_ms, rate_hz):
    delay_samples = int((delay_ms / 1000.0) * sample_rate)
    depth_samples = int((depth_ms / 1000.0) * sample_rate)
    L = len(audio)
    out = np.zeros(L)
    t = np.arange(L) / sample_rate
    mod = depth_samples * np.sin(2 * np.pi * rate_hz * t)
    for i in range(L):
        d = delay_samples + int(mod[i])
        if i - d >= 0:
            out[i] = audio[i] + audio[i - d]
        else:
            out[i] = audio[i]
    return normalize(out)


def apply_phaser(audio, sample_rate, rate_hz, depth):
    return audio


class AudioEffect:
    def __init__(self, audio, sample_rate):
        self.audio = audio.astype(np.float32) if audio.dtype != np.float32 else audio
        self.sample_rate = sample_rate
        self.effects = []

    def eq(self, frequency=1000.0, gain_db=5.0, Q=1.0):
        self.effects.append(lambda audio: apply_eq(audio, self.sample_rate, frequency, gain_db, Q))
        return self

    def pitch_shift(self, semitones=4.0):
        self.effects.append(lambda audio: apply_pitch_shift(audio, self.sample_rate, semitones))
        return self

    def delay(self, time_ms=500, feedback=0.3):
        self.effects.append(lambda audio: apply_delay(audio, self.sample_rate, time_ms, feedback))
        return self

    def saturation(self, drive=0.8):
        self.effects.append(lambda audio: apply_saturation(audio, drive))
        return self

    def distortion(self, gain=2.0, threshold=0.8):
        self.effects.append(lambda audio: apply_distortion(audio, gain, threshold))
        return self

    def reverb(self, room_size=0.8, delays=[0.01, 0.02, 0.03], decays=[0.5, 0.4, 0.3]):
        self.effects.append(lambda audio: apply_reverb(audio, self.sample_rate, room_size, delays, decays))
        return self

    def flanger(self, delay_ms=5.0, depth_ms=2.0, rate_hz=0.5):
        self.effects.append(lambda audio: apply_flanger(audio, self.sample_rate, delay_ms, depth_ms, rate_hz))
        return self

    def phaser(self, rate_hz=0.5, depth=0.7):
        self.effects.append(lambda audio: apply_phaser(audio, self.sample_rate, rate_hz, depth))
        return self

    def build(self):
        processed = self.audio
        for effect in self.effects:
            processed = effect(processed)
            processed = normalize(processed)
        return processed
