export Noise, WhiteNoise, PinkNoise

abstract type Noise <: Sound end

"Represents a discrete white noise."
struct WhiteNoise <: Noise
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
end

"Represents a discrete pink noise."
struct PinkNoise <: Noise
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
end

"Gives a sample at a time for the given white noise definition."
function generatesample(noise::WhiteNoise, nunmber::Int)
end

"Gives a sample at a time for the given pink noise definition."
function generatesample(noise::PinkNoise, nunmber::Int)
end