# Mutation
import Random

abstract type Mutator end

struct BitwiseMutatator <: Mutator
    λ # treshhold
end

function mutate(M::BitwiseMutatator)
    p = rand(length(ind))
    return @. (p < M.λ) != ind
end
