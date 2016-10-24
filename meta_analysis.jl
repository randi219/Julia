"""
meta analysis - logistic regression
-----------------------------------

input - output from logistic_stat()

output:
1. meta - summary statistic
2. metavar - variance
3. metall - summary statistic (all predictors)
4. metavalall - variance (all predictors)

"""

function meta_logistic(ests, vars, estint, varint)
    n = length(estint)      #> number of centers
    np = size(ests, 2)      #> number of predictors

    nom = 0.0                #> meta statistic nominator
    denom = 0.0              #> meta statistic denominator
    nomall = zeros(np)       #> meta statistic nominator - all predictors
    denomall = zeros(np, np) #> meta statistic denominator - all predictors

    for i in 1:n
        varstemp = reshape(vars[i, :], np, np)
        estemp = ests[i, :]

        nomall = nomall .+ *(inv(varstemp), estemp)
        denomall = denomall .+ inv(varstemp)

        nom = nom + inv(varint[i])*estint[i]
        denom = denom + inv(varint[i])
    end

    # result
    meta = nom / denom
    metavar = inv(denom)
    z = meta / sqrt(metavar)
    p = 2.0 * ccdf(Normal(), abs.(z))

    metall = *(inv(denomall), nomall)
    metavarall = (1 ./ denomall)
    zz = metall ./ sqrt(diag(metavarall))
    pp = 2.0 * ccdf(Normal(), abs.(zz))


    return meta, metavar, z, p, metall, metavarall, zz, pp
end
