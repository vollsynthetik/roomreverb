export SineWave

"Represents a sine wave at a given frequency"
struct SineWave <: Sound
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Method
    SineWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, x -> 1)
    SineWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given sine wave definition."
function generatesample(sinewave::SineWave, nunmber::Int)
    a0 = sinewave.amplitude * envelope(number)
    x = number / sinewave.samplerate
    Sample(a0 * sin(2 * pi * sinewave.frequency * x))
end
