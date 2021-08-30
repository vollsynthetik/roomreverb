export Sample

"Represents a single sample."
struct Sample{T<:Number}
    value::T
end

"Composes two sample sequences into one by calculating the arithmetic mean."
function add(s1::Array{Sample{T}}, s2::Array{Sample{T}}) where T <: Number
    shorterarray = s1
    longerarray = s2
    if s1.length > s2.length
        shorterarray = s2
        longerarray = s1
    end
    resultingarray = Array{Sample{T}}()
    for index in [1:longerarray.length]
        if shorterarray.length < index
            push!(resultingarray, Sample(longerarray[index]))
        else
            push!(resultingarray, Sample((shorterarray[index] + longerarray[index]) / 2))
        end
    end
end