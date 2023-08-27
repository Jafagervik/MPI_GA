using MPI, MPISort
using Statistics
using Random

# include("sorting.jl")

MPI.Init()

const ROOT = 0
const MAX_POP = 1000
const IND_SIZE = 20
const MAX_GENERATIONS = 20
const T = eltype(Float64)

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
nprocs = MPI.Comm_size(comm)


mutable struct Individual
    data::Vector{Bool}
    
    function Individual(data::String)
        return new(map(x -> x == '1', collect(data)))
    end
end


# These ones should be ran serially on each process
# It's mainly splitting the population and those algorithms that needs 
# to be considered
size(bs::Individual) = length(bs.data)
ones(bs::Individual) = count(c -> c, bs.data)
zeros(bs::Individual) = count(c -> !c, bs.data)

function flip_at!(bs::Individual, idx::Integer)
  bs.data[idx] = !bs.data[idx]
end

function flip_all!(bs::Individual)
  for i in eachindex(bs.data)
    flip_at!(bs, i)
  end
end

function flip_random_n!(bs::Individual, n::Integer)
  idxs = randperm(IND_SIZE)[1:n]

    for i in idxs
    flip_at!(bs, i)
  end
end


"""
    Total population should live on proc 0
"""
mutable struct Population
    pop::Vector{Individual}
    size::Integer

    Population(pop::Vector{Individual}) = new(pop, length(pop))
end

# NOTE: requires population to be sorted
best(p::Population) = ones(first(p.pop))

popsize(p::Population) = p.size

function generate_random_population(n::Integer)
    population_array = Vector{Individual}(undef, n)
    # TODO: thread this code?
    for i in 1:n
        individual_string = join(rand(["0", "1"]) for _ in 1:IND_SIZE)
        population_array[i] = Individual(individual_string)
    end
    return Population(population_array)
end


################################
#     Selection
################################

"""
    Get the best parents
    Mate these 
    return the new children
    sort
"""
function tournament_selection()::Vector{Individual}

end


################################
#    Crossover 
################################
function crossover(parents::Vector{T})::Vector{Individual}

end


################################
#   Mutation 
################################
function mutation(children::Vector{T})::Vector{Individual}

end


################################
#  Evaluation function 
################################
fitness_evaluation_ranking(p::Population) = ones(p.pop[1]) == IND_SIZE



function main()
    population = generate_random_population(MAX_POP)

    # TODO: Sort populaiton in parallel
    rank == ROOT && sort!(population.pop, by=ind->zeros(ind))

    found_ideal = false
    gen = 1

    while gen < MAX_GENERATIONS
        # Check if we've found the best 
        if rank == ROOT && fitness_evaluation_ranking(population)
            found_ideal = true
            break
        end


        gen += 1
    end

    rank == ROOT && println("Found best element in $gen generations.")

    MPI.Finalize()
end



Random.seed!(42)
main()
