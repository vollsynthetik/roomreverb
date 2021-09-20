export resample2

using FFTW

struct SinusoidalInterpolation <: Sound
    f::Function
end

"Resampling based on sinusoidal interpolation."
function resample2(samples::AbstractVector{T} where T <: Real, sourcesamplerate::Integer, targetsamplerate::Integer)::Vector{Float64}
    sourceNyquist = div(sourcesamplerate, 2)
    return play(SinusoidalInterpolation(
        generateinterpolationfunction(
            sourcesamplerate,
            targetsamplerate,
            fft(samples)[1:sourceNyquist]
            )
        ))
end

function generateinterpolationfunction(sourcesamplerate::Integer, targetsamplerate::Integer, fbins::Vector{Complex{T}} where T <: Real)::Function
    sinusoidscount = sourcesamplerate < targetsamplerate ? sourcesamplerate : targetsamplerate
    return (t -> 
        sum = 0.
        for k in 0:sinusoidscount-1
            sum += fbins[k] * exp(im 2 * pi * k * (t / targetsamplerate))
        end
        sum / sinusoidscount
        )
end

"Gives a sample at a time for the given sinusoidal interpolation definition."
function generatesample(interpolationFunction::InterpolationFunction, number::Integer)::Float64
    interpolationFunction.f(number)
end
