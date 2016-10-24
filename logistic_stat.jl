"""
calculate statistics for each center
------------------------------------

input:
1. y: a dict contains repsone
2. dat: a dict contains explanatories
3. nbeta: number of estimators (including intercept)
4. ninst: predictor of interest

output:
1. ests: estimator
2. vars: variance of estimator, convert nbetaXnbeta to 1Xnbeta^2
3. estint: estimator of interest
4. varint: variance of interest

"""

function logistic_stat(y, dat, nbeta::Int64, ninst::Int64)

    length(y) == length(dat) || error("y and dat must have the same length.")
    1 < ninst <= nbeta || error("Which one is the predictor of insterest?")

    n = length(y)       #> number of centers

    ests = zeros(n, nbeta)
    vars = zeros(n, nbeta*nbeta)

    estint = zeros(n)
    varint = zeros(n)

    for i in keys(y)
        ytemp = y[i]
        xtemp = dat[i][:,1:nbeta]
        w0 = zeros(nbeta)
        fit = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                             w0, vec(ytemp), xtemp)
        esttemp = fit[1]
        vartemp = inv(-1*fit[4])

        ests[i,:] = esttemp
        vars[i,:] = reshape(vartemp, 1, nbeta*nbeta)

        estint[i] = esttemp[ninst]
        varint[i] = vartemp[ninst, ninst]
    end

    return ests, vars, estint, varint
end
