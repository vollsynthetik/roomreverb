using FFTW
using DelimitedFiles

include("../src/RoomReverb.jl")

using Main.RoomReverb

samplingrate = 2048

sounds = Vector{Sound}()

for i in 1:10
    push!(sounds, SineWave(1,samplingrate,i*100,-3.))
end

samples = play(sounds)
sinesfft = (v -> v / (samplingrate/2)).(abs.(fft(samples)[2:1024]))

writedlm("ffts/sinesfft.csv", sinesfft)

println("Done.")