export Sound, iterate, play

abstract type Sound end

"Iterates over the given discrete sound."
function Base.iterate(S::Sound, state=1)
    state > S.duration * S.samplerate ? nothing : (generatesample(S, state), state + 1)
end

function play(Sounds::AbstractArray{T, 1} where T <: Sound, state=1)::Array{Sample{Float64}, 1}
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