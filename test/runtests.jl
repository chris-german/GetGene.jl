using Test, GetGene, DataFrames

snps = ["rs113980419", "rs17367504", 
"rs113980419", "rs2392929", "rs11014171",
"78067132", "1465537", "Affx-4150211"]
loci = ["C1orf167", "MTHFR", "C1orf167", 
"No gene listed", "CACNB2", "No gene listed",
"No gene listed", "snpid not in database"]

df = DataFrame(rsid = snps)

@testset "snpid match" begin
    @test getgenes(snps) == loci
    @test getgenes(df; idvar = "rsid") == loci
end

@testset "Argument Error" begin
    @test_throws ArgumentError getgenes(df)
end


