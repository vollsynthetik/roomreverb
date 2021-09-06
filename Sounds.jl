export Sound, iterate, play, fft

"abstract base type for all sound definitions."
abstract type Sound end

"Iterates over the given discrete sound."
function Base.iterate(S::Sound, state=1)
    state > S.duration * S.samplerate ? nothing : (generatesample(S, state), state + 1)
end

"Plays all of the given sounds at once."
function play(Sounds::AbstractArray{T, 1} where T <: Sound)::Array{Sample{Float64}, 1}
    all = Array{Sample{Float64}, 1}()
    for sound in Sounds
        samples = Array{Sample{Float64}, 1}()
        for sample in sound
            push!(samples, sample)
        end
        all = add(all, samples)
    end
    all
end

"Generates the complex fft of the given sounds played at once."
function fft(Sounds::AbstractArray{T, 1} where T <: Sound)::Array{Complex, 1}
    samples = play(Sounds)
    fft(value.(samples))
end