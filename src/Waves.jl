export Wave, SineWave, SquareWave, PulseWave, TriangularWave, SawtoothWave

abstract type Wave <: Sound end

"Represents a sine wave at a given frequency"
struct SineWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Envelope
    SineWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, ConstantEnvelope(1))
    SineWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given sine wave definition."
function generatesample(sinewave::SineWave, number::Int)
    a0 = sinewave.amplitude * sinewave.envelope.f(number)
    x = (number - 1) / sinewave.samplerate
    a0 * sin(2 * pi * sinewave.frequency * x)
end

"Represents a square wave for a given frequency."
struct SquareWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Envelope
    SquareWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, ConstantEnvelope(1))
    SquareWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given square wave definition."
function generatesample(wave::SquareWave, number::Int)
    a0 = wave.amplitude * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    mod(number - 1, modulo) < (modulo * 0.5) ? a0 : -a0
end

"Represents a pulse wave for a given frequency."
struct PulseWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    pulsewidth::Number
    envelope::Envelope
    PulseWave(duration, samplerate, frequency, amplitude, pulsewidth) = 
        new(duration, samplerate, frequency, amplitude, pulsewidth, ConstantEnvelope(1))
    PulseWave(duration, samplerate, frequency, amplitude, pulsewidth, envelope) = 
        new(duration, samplerate, frequency, amplitude, pulsewidth, envelope)
end

"Gives a sample at a time for the given pulse wave definition."
function generatesample(wave::PulseWave, number::Int)
    a0 = wave.amplitude * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    mod(number - 1, modulo) < (modulo * wave.pulsewidth) ? a0 : -a0
end

"Represents a triangluar wave for a given frequency."
struct TriangularWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Envelope
    TriangularWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, ConstantEnvelope(1))
    TriangularWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given triangluar wave definition."
function generatesample(wave::TriangularWave, number::Int)
    a0 = wave.amplitude * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    x = mod(number - 1, modulo)
    m = (2 * a0) / (modulo / 2)
    x < (modulo / 2) ? (m*x - a0) : (-m*x + 3 * a0)
end

"Represents a saw tooth wave for a given frequency."
struct SawtoothWave <: Wave
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
    envelope::Envelope
    SawtoothWave(duration, samplerate, frequency, amplitude) = 
        new(duration, samplerate, frequency, amplitude, ConstantEnvelope(1))
    SawtoothWave(duration, samplerate, frequency, amplitude, envelope) = 
        new(duration, samplerate, frequency, amplitude, envelope)
end

"Gives a sample at a time for the given saw tooth wave definition."
function generatesample(wave::SawtoothWave, number::Int)
    a0 = wave.amplitude * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    x = mod(number - 1, modulo)
    m = (2 * a0) / modulo
    m*x - a0
end
