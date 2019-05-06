__precompile__()

module GetGene

using HTTP, LazyJSON, DataFrames

export
    getgenes
include("getgenes.jl")

end
