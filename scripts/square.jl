using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Array{Sample, 1}()

samplingrate = 1024

wave = SquareWave(1, samplingrate, 220, 1)
samples = play(wave)
squarefft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:512]))

writedlm("ffts/squarefft.csv", squarefft)

println("Done.")
