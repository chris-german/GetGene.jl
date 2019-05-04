__precompile__()

module GetGene

using HTTP, LazyJSON

export
    getgenes
include("getgenes.jl")

end
