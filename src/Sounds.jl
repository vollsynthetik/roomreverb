export Sound, iterate, play, generatefft, dBFS2Float, float2dBFS, setvolume!

using FFTW

"abstract base type for all sound definitions."
abstract type Sound end

"Iterates over the given discrete sound."
function Base.iterate(S::Sound, state=1)
    state > S.duration * S.samplerate ? nothing : (generatesample(S, state), state + 1)
end

"Plays the given sound definition."
function play(Sound::Sound)::Array{Float64, 1}
    samples = Array{Float64, 1}()
    for sample in Sound
        push!(samples, sample)
    end
    samples
end

"Plays all of the given sounds at once."
function play(Sounds::AbstractArray{T, 1} where T <: Sound)::Array{Float64, 1}
    all = Array{Float64, 1}()
    for sound in Sounds
        all = add(all, sound)
    end
    all
end

"Adds a sound to the given array of samples from the beginning of the array 'samples'."
function add(target::AbstractArray{Float64, 1}, sound::Sound)::AbstractArray{Float64, 1}
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
function generatefft(Sound::Sound)::Array{Complex, 1}
    samples = play(Sound)
    FFTW.fft(value.(samples))
end

"Generates the complex fft of the given sounds played at once."
function generatefft(Sounds::AbstractArray{T, 1} where T <: Sound)::Array{Complex, 1}
    samples = play(Sounds)
    FFTW.fft(value.(samples))
end

function float2dBFS(value::Float64)::Float64
    20 * log(10, value)
end

function dBFS2Float(dBFS::Float64)::Float64
    10 ^ (dBFS / 20)
end

function setvolume!(samples::Array{Float64, 1}, dBFS::Float64 = 0)
    volume = dBFS2Float(dBFS)
    maxofsamples = maximum(abs.(samples))
    broadcast!((sample -> sample * volume / maxofsamples), samples, samples)
end