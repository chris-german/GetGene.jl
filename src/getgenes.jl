#Code to extract genes from NCBI database using their API 
#API found here: https://api.ncbi.nlm.nih.gov/variation/v0/

#takes "rs" out of snpids/rsids if they start with "rs###"
function getSNPID(snpid)
    id = ""
    try
        id = match(r"(?<=rs)\w+", snpid).match
    catch
        id = snpid   
    end
    return id 
end

#checks if gene information is present, if not, return no gene found
function genecheck(info)
    locus = ""
    try 
        locus = info["primary_snapshot_data"]["allele_annotations"][1]["assembly_annotation"][1]["genes"][1]["locus"]
    catch
        locus = "No gene listed"
    end
    return locus
end

function httpcheck(snpid)   
    http = HTTP.Messages.Response()
    try
        http = HTTP.get("https://api.ncbi.nlm.nih.gov/variation/v0/beta/refsnp/" * snpid)
    catch
        http = HTTP.Messages.Response()
    end
    return http
end

function getgenes(snpids)
    snpids = getSNPID.(snpids)
    loci = Vector{String}(undef, 0)
    for snpid in snpids
        http = httpcheck(snpid)
        if isempty(http.body)
            locus = "snpid not in database"
        else 
            str = String(http.body)
            info = LazyJSON.parse(str)
            locus = genecheck(info)
        end
        push!(loci, locus)
    end
    return loci
end