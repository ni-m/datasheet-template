# /// script
# requires-python = ">=3.10"
# dependencies = ["numpy", "scipy", "matplotlib>=3.6"]
# ///
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from matplotlib.backends.backend_pdf import PdfPages

plt.rcParams.update({"font.family": "sans-serif",
                    "font.size": 8,
                    "figure.figsize": (3, 2.2)})
w0, band = 2*np.pi*1e3, 2*np.pi*np.array([300, 3e3])
filters = {
    "lowpass":   signal.butter(4, w0, "low", analog=True),
    "highpass":  signal.butter(4, w0, "high", analog=True),
    "bandpass":  signal.butter(2, band, "bandpass", analog=True),
    "bandstop":  signal.butter(2, band, "bandstop", analog=True),
    "chebyshev": signal.cheby1(4, 1, w0, analog=True),
    "elliptic":  signal.ellip(4, 1, 40, w0, analog=True),
}
f = np.logspace(1, 5, 500)
pdf = PdfPages("plots.pdf")
for name, (b, a) in filters.items():
    _, h = signal.freqs(b, a, 2*np.pi*f)
    fig, ax = plt.subplots(layout="constrained")
    ax.semilogx(f, 20*np.log10(abs(h)), "b", lw=1)
    ax.set(xlabel="Frequency (Hz)",
           ylabel="Gain (dB)",
           xlim=(f[0], f[-1]),
           ylim=(-60, 5))
    ax.grid(which="both", lw=0.3)
    pdf.savefig(fig)
    plt.close(fig)
pdf.close()
