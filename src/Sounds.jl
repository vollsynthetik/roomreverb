export Sound, iterate, play, generatefft, dBFS2Float, float2dBFS, setvolume!

using FFTW

"abstract base type for all sound definitions."
abstract type Sound end

"Iterates over the given discrete sound."
function Base.iterate(S::Sound, state=1)
    state > S.duration * S.samplerate ? nothing : (generatesample(S, state), state + 1)
end

"Plays the given sound definition."
function play(Sound::Sound)::Vector{Real}
    samples = Vector{Real}()
    for sample in Sound
        push!(samples, sample)
    end
    samples
end

"Plays all of the given sounds at once."
function play(Sounds::AbstractVector{T} where T <: Sound)::Vector{Real}
    all = Vector{Real}()
    for sound in Sounds
        all = add(all, sound)
    end
    all
end

"Adds a sound to the given array of samples from the beginning of the array 'samples'."
function add(target::AbstractVector{Real}, sound::Sound)::Vector{Real}
    samples = Real[]
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
function generatefft(Sounds::AbstractVector{T} where T <: Sound)::Vecetor{Complex}
    samples = play(Sounds)
    FFTW.fft(value.(samples))
end

function float2dBFS(value::Real)::Real
    20 * log(10, value)
end

function dBFS2Float(dBFS::Real)::Real
    10 ^ (dBFS / 20)
end

function setvolume!(samples::Vector{Real}, dBFS::Real = 0)
    volume = dBFS2Float(dBFS)
    maxofsamples = maximum(abs.(samples))
    broadcast!((sample -> sample * volume / maxofsamples), samples, samples)
end