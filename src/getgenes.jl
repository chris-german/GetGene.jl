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

#checks to make sure the HTTP has valid information
function httpcheck(snpid)   
    http = HTTP.Messages.Response()
    try
        http = HTTP.get("https://api.ncbi.nlm.nih.gov/variation/v0/beta/refsnp/" * snpid)
    catch
        http = HTTP.Messages.Response()
    end
    return http
end


"""
    getgenes(data::DataFrame; idvar::AbstractString)

# Position arguments

- `data::DataFrame`: A DataFrame containing a column with the Ref SNP IDs. By default, assumes that the variable name is "snpid". The variable name can be specified using the `idvar` keyword.

# Keyword arguments

- `idvar::AbstractString`: the variable name in the dataframe that specifies the Ref SNP ID (rsid).


    getgenes(snps::AbstractArray)

# Position arguments

- `snps::AbstractArray`: Ref SNP IDs (rsid) to get loci names for. 

# Output

Returns an array of gene loci associated to the Ref SNP IDs.

"""
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

function getgenes(df::DataFrame; idvar::AbstractString = "snpid")
    rsidsym = Meta.parse(idvar)
    if !(rsidsym in names(df))
        throw(ArgumentError(idvar * " is not in the dataframe. Please rename 
        the column of rsids to `snpid` or specify the correct name using the `idvar` argument"))
    end
    getgenes(df[rsidsym])
end