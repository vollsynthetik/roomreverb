using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Vector{Real}()

samplingrate = 1024

sweep = LogarithmicSweep(1, samplingrate, 100, 400, 0.)
samples = play(sweep)
sweepfft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:512]))

writedlm("ffts/logsweepfft.csv", sweepfft)

println("Done.")
