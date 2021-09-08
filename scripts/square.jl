using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Array{Sample, 1}()

samplingrate = 1024

wave = SquareWave(1, samplingrate, 220, 1)
samples = play(wave)
sweepfft = (v -> v / (samplingrate/2)).(abs.(fft(value.(samples))[2:512]))

writedlm("ffts/squarefft.csv", sweepfft)

println("Done.")
