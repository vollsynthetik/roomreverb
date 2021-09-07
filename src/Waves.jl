export SineWave

"Represents a sine wave at a given frequency"
struct SineWave <: Sound
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Any
    SineWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, createconstantenvelope(1))
    SineWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given sine wave definition."
function generatesample(sinewave::SineWave, number::Int)
    a0 = sinewave.amplitude * sinewave.envelope(number)
    x = number / sinewave.samplerate
    Sample(a0 * sin(2 * pi * sinewave.frequency * x))
end
