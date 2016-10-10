"""
logistic simulation - multiple centers
--------------------------------------

input
1. k - number of centers
2. n - number of observation in each center
3. beta - beta coefficient (includeing intercept)
4. tp - type of predictor: b for binary; c for continuous
5. seed - random seed

output:
1. respone - y; outcome
2. dat - X; predictors

"""

function sim_logistic(k::Int64, n::Int64, beta::Vector, tp::Vector; seed=0)
    # random seed
    if seed != 0
        srand(seed)
    end
    # over centers
    response = Dict()
    dat = Dict()
    for k in 1:k
        y = [0 for x in 1:n]
        x = zeros(n,length(beta))
        for j in 1:n
            xtemp = zeros(length(beta))
            xtemp[1] = 1     #> intercept
            for i in 2:length(beta)
                # either binary or normal
                tp[i] == 'b' ? xtemp[i] = rand(Binomial(1, 0.5),1)[1] : xtemp[i] = rand(Normal(),1)[1]
            end
            x[j,:] = xtemp
            y[j] = convert(Int64, rand(Binomial(1, 1/(1+exp(-1*sum(beta .* xtemp)))),1)[1]) #> type, Int64
        end
        response[k] = y
        dat[k] = x
    end
    return response, dat
end
