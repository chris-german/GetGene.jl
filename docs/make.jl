using Documenter, GetGene

ENV["DOCUMENTER_DEBUG"] = "true"

makedocs(
    format = :html,
    sitename = "GetGene",
    modules = [GetGene]
)

deploydocs(
    repo   = "github.com/OpenMendel/GetGene.jl.git",
    target = "build"
)