export Fade, FadeIn, FadeOut, LinFadeIn, LinFadeOut, ExpFadeIn, ExpFadeOut, apply!

"Represents a fade."
abstract type Fade end

"Represents a fade in."
abstract type FadeIn <: Fade end

"Represents a fade out."
abstract type FadeOut <: Fade end

"Represents a linear fade in."
struct LinFadeIn <: FadeIn
    duration::Number
    samplerate::Unsigned
    f::Function
    LinFadeIn(duration, samplerate) =
        new(duration, samplerate, x -> (1 / (duration * samplerate)) * x)
end

"Represents a linear fade out."
struct LinFadeOut <: FadeOut
    duration::Number
    samplerate::Unsigned
    f::Function
    LinFadeOut(duration, samplerate) =
        new(duration, samplerate, x -> (-x / (duration * samplerate)) + 1)
end

"Represents a exponential fade in."
struct ExpFadeIn <: FadeIn
    duration::Number
    samplerate::Unsigned
    f::Function
    ExpFadeIn(duration, samplerate) =
        new(duration, samplerate, x -> 2 ^ (x / (duration * samplerate)) - 1)
end

"Represents a exponential fade out."
struct ExpFadeOut <: FadeOut
    duration::Number
    samplerate::Unsigned
    f::Function
    ExpFadeOut(duration, samplerate) =
        new(duration, samplerate, x -> 1 - log(2, (x / (duration * samplerate)) + 1))
end

"Applies the given fade-in to the given samples."
function apply!(fade::FadeIn, samples::Vector{T})::Vector{T} where T <: Real
    fadelength = ceil(Integer, fade.duration * fade.samplerate)
    for index in 1:fadelength
        samples[index] *= fade.f(index)
    end
    samples
end

"Applies the given fade-out to the given samples."
function apply!(fade::FadeOut, samples::Vector{T})::Vector{T} where T <: Real
    fadelength = ceil(Integer, fade.duration * fade.samplerate)
    lowerbound = length(samples) - fadelength
    upperbound = length(samples)
    for index in lowerbound:upperbound
        samples[index] *= fade.f(index - lowerbound)
    end
    samples
end