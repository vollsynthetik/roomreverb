export Sample, add, value

abstract type AbstractSample end

"Represents a single sample."
struct Sample{T<:Number} <: AbstractSample
    value::T
end

"Helper function. Returns the value of the sample."
function value(s::Sample{T})::T where T <: Number
    s.value
end

"Composes two sample sequences into one by calculating the arithmetic mean."
function add(s1::Array{Sample{T}}, s2::Array{Sample{T}}) where T <: Number
    shorterarray = s1
    longerarray = s2
    if size(s1)[1] > size(s2)[1]
        shorterarray = s2
        longerarray = s1
    end
    resultingarray = Array{Sample{T},1}()
    index = 1
    while index <= size(longerarray)[1]
        if size(shorterarray)[1] < index
            push!(resultingarray, Sample(longerarray[index].value))
        else
            push!(resultingarray, Sample(shorterarray[index].value + longerarray[index].value))
        end
        index += 1
    end
    resultingarray
end