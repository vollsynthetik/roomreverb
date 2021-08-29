module Sweeps

export Sweep, iterate, generatesample

include("Samples.jl")

using RoomReverb.Samples

struct Sweep
    duration::Int
    samplerate::Int
end

function generatesample(number::Int)
    Sample(number * number)
end

function Base.iterate(S::Sweep, state=1)
    state > S.duration * S.samplerate ? nothing : (generatesample(state), state + 1)
end

end