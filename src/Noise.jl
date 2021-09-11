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
    buffer::Array{Sample{Float64}, 1}
    BrownNoise(duration, samplerate, lowestfrequency, highestfrequency, amplitude) =
        new(duration, samplerate, lowestfrequency, highestfrequency, amplitude, Array{Sample{Float64},1}())
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
    fftwidth = noise.samplerate * noise.duration
    fft = zeros(Complex{Float64}, fftwidth)
    lowerBound = noise.lowestfrequency * noise.duration
    upperBound = noise.highestfrequency * noise.duration
    for frequencyindex in lowerBound:upperBound
        value = Complex{Float64}(noise.amplitude * rand(1)[1] * (fftwidth/2), 0)
        fft[frequencyindex + 1] = value
        fft[fftwidth - (frequencyindex - 1)] = value
    end
    samples = (v -> Sample{Float64}(v)).(real.(ifft(fft)))
    noise.buffer = samples
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
    fftwidth = noise.samplerate * noise.duration
    fft = zeros(Complex{Float64}, fftwidth)
    lowerBound = noise.lowestfrequency * noise.duration
    upperBound = noise.highestfrequency * noise.duration
    for frequencyindex in lowerBound:upperBound
        drop = 2^(log(2, noise.lowestfrequency)-log(2, (frequencyindex / noise.duration)))
        value = Complex{Float64}(noise.amplitude * drop * rand(1)[1] * (fftwidth/2), 0)
        fft[frequencyindex + 1] = value
        fft[fftwidth - (frequencyindex - 1)] = value
    end
    samples = (v -> Sample{Float64}(v)).(real.(ifft(fft)))
    noise.buffer = samples
end

"Gives a sample at a time for the given brown noise definition."
function generatesample(noise::BrownNoise, number::Int)
    if isempty(noise.buffer)
        generatebrownnoise(noise)
    end
    noise.buffer[number]
end

"Generates brown noise corresponding to the given brown noise definiton"
function generatebrownnoise(noise::BrownNoise)::Array{Sample{Float64}, 1}
    fftwidth = noise.samplerate * noise.duration
    fft = zeros(Complex{Float64}, fftwidth)
    lowerBound = noise.lowestfrequency * noise.duration
    upperBound = noise.highestfrequency * noise.duration
    for frequencyindex in lowerBound:upperBound
        drop = 2^(2*log(2,noise.lowestfrequency)-2*log(2,(frequencyindex / noise.duration)))
        value = Complex{Float64}(noise.amplitude * drop * rand(1)[1] * (fftwidth/2), 0)
        fft[frequencyindex + 1] = value
        fft[fftwidth - (frequencyindex - 1)] = value
    end
    samples = (v -> Sample{Float64}(v)).(real.(ifft(fft)))
    noise.buffer = samples
end
