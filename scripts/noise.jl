using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Vector{Real}()

samplingrate = 32768

noise = WhiteNoise(1, samplingrate, 220, 880, 0.)
samples = play(noise)
noisefft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:16384]))

writedlm("ffts/noisefft.csv", noisefft)

println("Done.")
