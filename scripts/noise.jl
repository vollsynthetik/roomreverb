using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Array{Sample, 1}()

samplingrate = 32768

noise = WhiteNoise(1, samplingrate, 220, 880, 1)
samples = play(noise)
noisefft = (v -> v / (samplingrate/2)).(abs.(fft(value.(samples))[2:16384]))

writedlm("ffts/noisefft.csv", noisefft)

println("Done.")
