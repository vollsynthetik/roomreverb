using FFTW

export Noise, WhiteNoise, PinkNoise, BrownNoise

abstract type Noise <: Sound end

"Represents a discrete white noise."
mutable struct WhiteNoise <: Noise
    duration::Number
    samplerate::Integer
    lowestfrequency::Number
    highestfrequency::Number
    dBFS::Real
    buffer::Vector{Real}
    WhiteNoise(duration, samplerate, lowestfrequency, highestfrequency, dBFS) =
        new(duration, samplerate, lowestfrequency, highestfrequency, dBFS, Vector{Real}())
end

"Represents a discrete pink noise."
mutable struct PinkNoise <: Noise
    duration::Number
    samplerate::Integer
    lowestfrequency::Number
    highestfrequency::Number
    dBFS::Real
    buffer::Vector{Real}
    PinkNoise(duration, samplerate, lowestfrequency, highestfrequency, dBFS) =
        new(duration, samplerate, lowestfrequency, highestfrequency, dBFS, Vector{Real}())
end

"Represents a discrete brown noise."
mutable struct BrownNoise <: Noise
    duration::Number
    samplerate::Integer
    lowestfrequency::Number
    highestfrequency::Number
    dBFS::Real
    buffer::Vector{Real}
    BrownNoise(duration, samplerate, lowestfrequency, highestfrequency, dBFS) =
        new(duration, samplerate, lowestfrequency, highestfrequency, dBFS, Vector{Real}())
end

"Gives a sample at a time for the given white noise definition."
function generatesample(noise::WhiteNoise, number::Integer)::Real
    if isempty(noise.buffer)
        generatewhitenoise(noise)
        setvolume!(noise.buffer, noise.dBFS)
    end
    noise.buffer[number]
end

"Generates white noise corresponding to the given white noise definiton"
function generatewhitenoise(noise::WhiteNoise)::Vector{Real}
    fftwidth = noise.samplerate * noise.duration
    fft = zeros(Complex{Real}, fftwidth)
    lowerBound = noise.lowestfrequency * noise.duration
    upperBound = noise.highestfrequency * noise.duration
    for frequencyindex in lowerBound:upperBound
        value = Complex{Real}(rand(1)[1] * (fftwidth/2), 0)
        fft[frequencyindex + 1] = value
        fft[fftwidth - (frequencyindex - 1)] = value
    end
    samples = real.(ifft(fft))
    noise.buffer = samples
end

"Gives a sample at a time for the given pink noise definition."
function generatesample(noise::PinkNoise, number::Integer)::Real
    if isempty(noise.buffer)
        generatepinknoise(noise)
        setvolume!(noise.buffer, noise.dBFS)
    end
    noise.buffer[number]
end

"Generates pink noise corresponding to the given pink noise definiton"
function generatepinknoise(noise::PinkNoise)::Vector{Real}
    fftwidth = noise.samplerate * noise.duration
    fft = zeros(Complex{Real}, fftwidth)
    lowerBound = noise.lowestfrequency * noise.duration
    upperBound = noise.highestfrequency * noise.duration
    for frequencyindex in lowerBound:upperBound
        drop = 2^(log(2, noise.lowestfrequency)-log(2, (frequencyindex / noise.duration)))
        value = Complex{Real}(drop * rand(1)[1] * (fftwidth/2), 0)
        fft[frequencyindex + 1] = value
        fft[fftwidth - (frequencyindex - 1)] = value
    end
    samples = real.(ifft(fft))
    noise.buffer = samples
end

"Gives a sample at a time for the given brown noise definition."
function generatesample(noise::BrownNoise, number::Integer)::Real
    if isempty(noise.buffer)
        generatebrownnoise(noise)
        setvolume!(noise.buffer, noise.dBFS)
    end
    noise.buffer[number]
end

"Generates brown noise corresponding to the given brown noise definiton"
function generatebrownnoise(noise::BrownNoise)::Vector{Real}
    fftwidth = noise.samplerate * noise.duration
    fft = zeros(Complex{Real}, fftwidth)
    lowerBound = noise.lowestfrequency * noise.duration
    upperBound = noise.highestfrequency * noise.duration
    for frequencyindex in lowerBound:upperBound
        drop = 2^(2*log(2,noise.lowestfrequency)-2*log(2,(frequencyindex / noise.duration)))
        value = Complex{Real}(drop * rand(1)[1] * (fftwidth/2), 0)
        fft[frequencyindex + 1] = value
        fft[fftwidth - (frequencyindex - 1)] = value
    end
    samples = real.(ifft(fft))
    noise.buffer = samples
end
