using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Vector{Real}()

samplingrate = 32768

wave = SawtoothWave(1, samplingrate, 220, 0.)
samples = play(wave)
sawtoothfft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:16384]))

writedlm("ffts/sawtoothfft.csv", sawtoothfft)

println("Done.")
