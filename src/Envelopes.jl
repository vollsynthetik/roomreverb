export createconstantenvelope

function createconstantenvelope(c::Number) 
    _ -> c
end

function createlinearenvelope(m::Number, n::Number)
    i -> m*i + n
end
