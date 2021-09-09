export Wave, SineWave, SquareWave, PulseWave, TriangularWave, SawtoothWave

abstract type Wave <: Sound end

"Represents a sine wave at a given frequency"
struct SineWave <: Wave
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
    x = (number - 1) / sinewave.samplerate
    Sample(a0 * sin(2 * pi * sinewave.frequency * x))
end

"Represents a square wave for a given frequency."
struct SquareWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Any
    SquareWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, createconstantenvelope(1))
    SquareWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given square wave definition."
function generatesample(wave::SquareWave, number::Int)
    a0 = wave.amplitude * wave.envelope(number)
    modulo = wave.samplerate / wave.frequency
    Sample{Float64}(mod(number - 1, modulo) < (modulo * 0.5) ? a0 : -a0)
end

"Represents a pulse wave for a given frequency."
struct PulseWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    pulsewidth::Number
    envelope::Any
    PulseWave(duration, samplerate, frequency, amplitude, pulsewidth) = 
        new(duration, samplerate, frequency, amplitude, pulsewidth, createconstantenvelope(1))
    PulseWave(duration, samplerate, frequency, amplitude, pulsewidth, envelope) = 
        new(duration, samplerate, frequency, amplitude, pulsewidth, envelope)
end

"Gives a sample at a time for the given pulse wave definition."
function generatesample(wave::PulseWave, number::Int)
    a0 = wave.amplitude * wave.envelope(number)
    modulo = wave.samplerate / wave.frequency
    Sample{Float64}(mod(number - 1, modulo) < (modulo * wave.pulsewidth) ? a0 : -a0)
end

"Represents a triangluar wave for a given frequency."
struct TriangularWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Any
    TriangularWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, createconstantenvelope(1))
    TriangularWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given triangluar wave definition."
function generatesample(wave::TriangularWave, number::Int)
    a0 = wave.amplitude * wave.envelope(number)
    modulo = wave.samplerate / wave.frequency
    x = mod(number - 1, modulo)
    m = (2 * a0) / (modulo / 2)
    Sample{Float64}(x < (modulo / 2) ? (m*x - a0) : (-m*x + 3 * a0))
end

"Represents a saw tooth wave for a given frequency."
struct SawtoothWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Any
    SawtoothWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, createconstantenvelope(1))
    SawtoothWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given saw tooth wave definition."
function generatesample(wave::SawtoothWave, number::Int)
    a0 = wave.amplitude * wave.envelope(number)
    modulo = wave.samplerate / wave.frequency
    x = mod(number - 1, modulo)
    m = (2 * a0) / modulo
    Sample{Float64}(m*x - a0)
end
