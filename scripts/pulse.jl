using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Array{Sample, 1}()

samplingrate = 32768

wave = PulseWave(1, samplingrate, 220, 1, 0.3)
samples = play(wave)
pulsefft = (v -> v / (samplingrate/2)).(abs.(fft(value.(samples))[2:16384]))

writedlm("ffts/pulsefft.csv", pulsefft)

println("Done.")
