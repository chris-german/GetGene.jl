using Test, GetGene

snps = ["rs113980419", "rs17367504", 
"rs113980419", "rs2392929", "rs11014171"]
loci = ["C1orf167", "MTHFR", "C1orf167", 
"No gene found", "CACNB2"]


@testset "snpid match" begin
    @test getgenes(snps) == loci
end



