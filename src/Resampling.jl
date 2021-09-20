export resample2

using FFTW

struct SinusoidalInterpolation <: Sound
    duration::Number
    samplerate::Unsigned
    f::Function
end

"Resampling based on sinusoidal interpolation."
function resample2(samples::AbstractVector{T} where T <: Real, sourcesamplerate::Integer, targetsamplerate::Integer)::Vector{Float64}
    sourceNyquist = div(sourcesamplerate, 2)
    return play(SinusoidalInterpolation(
        length(samples) / sourcesamplerate,
        targetsamplerate,
        generateinterpolationfunction(
            sourcesamplerate,
            targetsamplerate,
            (s->s/sourceNyquist).(fft(samples)[1:sourceNyquist])
            )
        ))
end

function generateinterpolationfunction(sourcesamplerate::Integer, targetsamplerate::Integer, fbins::Vector{Complex{T}} where T <: Real)::Function
    sourceNyquist = div(sourcesamplerate, 2)
    targetNyquist = div(targetsamplerate, 2)
    sinusoidscount = targetsamplerate < sourcesamplerate ? targetNyquist : sourceNyquist
    return function (t::Number)
        sum = 0.
        for k in 0:sinusoidscount-1
            sum += fbins[k + 1] * exp(im * 2 * pi * k * ((t - 1) / targetsamplerate))
        end
        real(sum / sinusoidscount) * targetNyquist
    end
end

"Gives a sample at a time for the given sinusoidal interpolation definition."
function generatesample(interpolation::SinusoidalInterpolation, number::Integer)::Float64
    interpolation.f(number)
end
