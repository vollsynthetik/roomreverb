using FFTW

export Noise, WhiteNoise, PinkNoise, BrownNoise

abstract type Noise <: Sound end

"Represents a discrete white noise."
mutable struct WhiteNoise <: Noise
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
    buffer::Array{Sample{Float64}, 1}
    WhiteNoise(duration, samplerate, lowestfrequency, highestfrequency, amplitude) =
        new(duration, samplerate, lowestfrequency, highestfrequency, amplitude, Array{Sample{Float64},1}())
end

"Represents a discrete pink noise."
mutable struct PinkNoise <: Noise
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
    buffer::Array{Sample{Float64}, 1}
    PinkNoise(duration, samplerate, lowestfrequency, highestfrequency, amplitude) =
        new(duration, samplerate, lowestfrequency, highestfrequency, amplitude, Array{Sample{Float64},1}())
end

"Represents a discrete brown noise."
mutable struct BrownNoise <: Noise
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
end

"Gives a sample at a time for the given white noise definition."
function generatesample(noise::WhiteNoise, number::Int)
    if isempty(noise.buffer)
        generatewhitenoise(noise)
    end
    noise.buffer[number]
end

"Generates white noise corresponding to the given white noise definiton"
function generatewhitenoise(noise::WhiteNoise)::Array{Sample{Float64}, 1}
    fft = zeros(Complex{Float64}, noise.samplerate)
    for frequency in noise.lowestfrequency:noise.highestfrequency
        value = Complex{Float64}(noise.amplitude * rand(1)[1] * (noise.samplerate/2), 0)
        fft[frequency + 1] = value
        fft[noise.samplerate - (frequency - 1)] = value
    end
    samples = (v -> Sample{Float64}(v)).(real.(ifft(fft)))
    noise.buffer = samples
    samples
end

"Gives a sample at a time for the given pink noise definition."
function generatesample(noise::PinkNoise, number::Int)
    if isempty(noise.buffer)
        generatepinknoise(noise)
    end
    noise.buffer[number]
end

"Generates pink noise corresponding to the given pink noise definiton"
function generatepinknoise(noise::PinkNoise)::Array{Sample{Float64}, 1}
    fft = zeros(Complex{Float64}, noise.samplerate)
    for frequency in noise.lowestfrequency:noise.highestfrequency
        drop = 2^(log(2,noise.lowestfrequency)-log(2,frequency))
        value = Complex{Float64}(noise.amplitude * drop * rand(1)[1] * (noise.samplerate/2), 0)
        fft[frequency + 1] = value
        fft[noise.samplerate - (frequency - 1)] = value
    end
    samples = (v -> Sample{Float64}(v)).(real.(ifft(fft)))
    noise.buffer = samples
    samples
end

"Gives a sample at a time for the given brown noise definition."
function generatesample(noise::BrownNoise, number::Int)
end
