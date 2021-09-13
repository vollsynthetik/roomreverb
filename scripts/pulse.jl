using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Vector{Real}()

samplingrate = 32768

wave = PulseWave(1, samplingrate, 220, 0., 0.3)
samples = play(wave)
pulsefft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:16384]))

writedlm("ffts/pulsefft.csv", pulsefft)

println("Done.")
