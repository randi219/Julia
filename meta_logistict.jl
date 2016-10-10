"""
Meta analysis - logistic regression
-----------------------------------

input:
1. response - y; outcome
2. dat - X; predictors
3. np - number of predictors (including intercept)
4. pos - position (predictor of interest)

output:
1. est - estimator (all centers)
2. var - variance(all centers)
3. meta - summary statistic
4. metavar - variance
5. metall - summary statistic (all predictors)
6. metavalall - variance (all predictors)

"""

function logistic_meta(response::Dict, dat::Dict, np::Int64, pos::Int64)
    # check input
    if length(dat) != length(response)
        error("dat doesn't have the same length as that of response!")
    end
    n = length(response)     #> number of centers
    # restore result
    est = zeros(n)
    var = zeros(n)
    estall = Dict()          #> save estimator for all predictors (output?)
    varall = Dict()          #> save var for all predictors (output?)
    nom = 0.0                #> meta statistic nominator
    denom = 0.0              #> meta statistic denominator
    nomall = zeros(np)       #> meta statistic nominator - all predictors
    denomall = zeros(np, np) #> meta statistic denominator - all predictors
    # throughout all centers
    for i in keys(reponse)
        y = response[i]
        x = dat[i]
        w0 = zeros(np)
        fit = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                             w0, y, x)
        fitest = fit[1]
        fitvar = inv(-1*fit[4])
        est[i] = fitest[pos]
        var[i] = fitvar[pos, pos]
        estall[i] = fitest
        varall[i] = fitvar
        nom = nom + inv(var[i])*est[i]
        denom = denom + inv(var[i])
        nomall = nomall .+ *(inv(fitvar), fitest)
        denomall = denomal .+ inv(fitvar)
    end
    # result
    meta = nom / denom
    metavar = inv(denom)
    metall = nomall ./ denomall
    metavarall = 1 ./ denomall

    return est, var, meta, metavar, metall, metavarall
end        
