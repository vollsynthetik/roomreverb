export Sound, iterate, play, generatefft, dBFS2Float, float2dBFS, setvolume!, resample

using FFTW

"abstract base type for all sound definitions."
abstract type Sound end

"Iterates over the given discrete sound."
function Base.iterate(S::Sound, state=1)
    state > S.duration * S.samplerate ? nothing : (generatesample(S, state), state + 1)
end

"Plays the given sound definition."
function play(Sound::Sound)::Vector{Float64}
    samples = Vector{Real}()
    for sample in Sound
        push!(samples, sample)
    end
    samples
end

"Plays all of the given sounds at once."
function play(Sounds::AbstractVector{T} where T <: Sound)::Vector{Float64}
    all = Vector{Float64}()
    for sound in Sounds
        all = add(all, sound)
    end
    all
end

"Adds a sound to the given array of samples from the beginning of the array 'samples'."
function add(target::AbstractVector{T} where T <: Real, sound::Sound)::Vector{Float64}
    samples = Float64[]
    for sample in sound
        push!(samples, sample)
    end
    for index in 1:length(samples)
        if length(target) < index
            push!(target, samples[index])
        else
            target[index] += samples[index]
        end 
    end
    target
end

"Generates the complex fft of the given sound."
function generatefft(Sound::Sound)::Vector{Complex}
    samples = play(Sound)
    FFTW.fft(value.(samples))
end

"Generates the complex fft of the given sounds played at once."
function generatefft(Sounds::AbstractVector{T} where T <: Sound)::Vector{Complex}
    samples = play(Sounds)
    FFTW.fft(value.(samples))
end

"Calculates the dBFS value from the given [-1..-1] range."
function float2dBFS(value::Real)::Real
    20 * log(10, value)
end

"Calculates the [-1..1] value from the given dBFS value."
function dBFS2Float(dBFS::Real)::Real
    10 ^ (dBFS / 20)
end

"Normalizes the sample vector to the given dBFS range."
function setvolume!(samples::Vector{T}, dBFS::Real = 0)::Vector{T} where T <: Real
    volume = dBFS2Float(dBFS)
    maxofsamples = maximum(abs.(samples))
    broadcast!((sample -> sample * volume / maxofsamples), samples, samples)
end

"Converts the given sample vector from source sample rate to target sample rate."
function resample(samples::Vector{T}, sourcesamplerate::Integer, targetsamplerate::Integer)::Vector{T} where T <: Real
    target = Vector{T}()
    
    if length(samples) == 0
        return target
    end

    if length(samples) == 1
        push!(target, samples[1])
        return target
    end

    ratio = sourcesamplerate // targetsamplerate
    i = 0

    sourcelength = length(samples)
    while i < sourcelength
        i += ratio

        base = floor(Integer, i)
        between = base == 0 ? i : mod(i, base)
        index = base + 1

        sample = index >= sourcelength ? samples[base] : (samples[index + 1] - samples[index]) * between + samples[index]

        if base <= sourcelength
            push!(target, sample)
        end
    end

    target
end