export Sound, iterate, play, generatefft

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
        samples = Array{Float64, 1}()
        for sample in sound
            push!(samples, sample)
        end
        all = all .+ samples
    end
    all
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