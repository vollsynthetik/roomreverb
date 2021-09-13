using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Vector{Real}()

samplingrate = 1024

wave = SquareWave(1, samplingrate, 220, 0.)
samples = play(wave)
squarefft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:512]))

writedlm("ffts/squarefft.csv", squarefft)

println("Done.")
