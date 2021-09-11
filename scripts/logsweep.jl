using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samples = Array{Sample, 1}()

samplingrate = 1024

sweep = LogarithmicSweep(1, samplingrate, 100, 400, 1)
samples = play(sweep)
sweepfft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:512]))

writedlm("ffts/logsweepfft.csv", sweepfft)

println("Done.")
