using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Array{Sample, 1}()

samplingrate = 32768

wave = TriangularWave(1, samplingrate, 220, 1)
samples = play(wave)
triangularfft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:16384]))

writedlm("ffts/triangularfft.csv", triangularfft)

println("Done.")
