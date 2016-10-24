"""
logistic simulation - multiple centers
--------------------------------------

input
1. k - number of centers
2. n - number of observation in each center
3. beta - beta coefficient (includeing intercept), each row contains presetting
          beta coefficients for each center. beta[1] is intercept. beta[2] is
          the predictor of interest.
4. hwe - Hardy–Weinberg equilibrium. p(AA)
5. tp - type of predictor: b for binary; c for continuous. length is equal to
        the number of beta in each center minus 2, (intercept + predictor of
        interest). In addition, length should be greater than or equal to 0.
6. seed - random seed

output:
1. respone - y; outcome
2. dat - X; predictors

"""

function sim_logistic(K::Int64, n::Int64,
                      beta::Array{Float64}, hwe::Float64,
                      tp = Vector(); strata = false, seed=0)
    # check input
    K == size(beta, 1) || error("Please check the number of centers in beta!")
    length(tp)+2 == size(beta,2) || error("Please check the number in tp!")

    # random seed
    seed == 0 || srand(seed)

    # throughout centers
    response = Dict()           #> save as Dict
    dat = Dict()                #> save as Dict
    dat_org = Dict()
    weight = [(1-hwe)^2, 2*hwe*(1-hwe), hwe^2]

    for k in 1:K
        y = [0 for x in 1:n]
        x = zeros(n,size(beta,2))
        for j in 1:n
            xtemp = zeros(size(beta,2))
            xtemp[1] = 1                                        #> intercept
            xtemp[2] = sample([2.0, 1.0, 0.0], WeightVec(weight), 1)[1]  #> snp 2:aa, 1:Aa, 0:AA
            if length(tp) > 0    #> if any covariates
                for i in 1:length(tp)
                    # either binary or normal
                    tp[i] == 'b' ? xtemp[i+2] = rand(Binomial(1, 0.5),1)[1] : xtemp[i+2] = rand(Normal(),1)[1]
                end
            end
            x[j,:] = xtemp
            y[j] = convert(Int64, rand(Binomial(1, 1/(1+exp(-1*sum(beta[k,:] .* xtemp)))),1)[1]) #> type, Int64
        end
        response[k] = y
        if strata == false
            dat[k] = x
        else
            indmat = zeros(n, K)
            indmat[:,k] = 1
            dat[k] = hcat(x, indmat[:,2:K])
            dat_org[k] = x
        end
    end

    # sort Dict
    response_sort = SortedDict(response)
    dat_sort = SortedDict(dat)

    if strata == false
        return response_sort, dat_sort
    else
        dat_org_sort = SortedDict(dat_org)
        return response_sort, dat_sort, dat_org_sort
    end
end
