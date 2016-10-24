include("/home/randi/randi/julia2016/Julia/Newton_method_logistic.jl")

import DataStructures
import StatsBase
include("/home/randi/randi/julia2016/Julia/simulation_multicenters_logistic.jl")

include("/home/randi/randi/julia2016/Julia/logistic_stat.jl")
include("/home/randi/randi/julia2016/Julia/meta_analysis.jl")

# simulate data - single snp
bb = reshape(repeat([2.0, 2.0, -1], inner=5), 5, 3)

sim_dat = sim_logistic(5, 500, bb, 0.7, ['b',]; strata=true, seed=2016)

sim_dat[2][2]

# distributed logisitic regression
nw2 = newton_distributed2(logistic_loglik, logistic_gradient, logistic_hessian,
                          zeros(7), sim_dat[1], sim_dat[2])
result = zeros(7,4)
result[:,1] = nw2[1]
result[:,2] = nw2[2]
result[:,3] = nw2[6]
result[:,4] = nw2[7]
result

# meta
logstat = logistic_stat(sim_dat[1], sim_dat[2], 3, 2)
meta2 = meta_logistic(logstat[1],logstat[2],logstat[3], logstat[4])

meta2[1:4]




# simulate data - 1000 snp
"""setting
beta = (2, 2, -1) #> all the same thoughtout centers
ncenter = 5
nsample = 500
nsnp = 1000
without center indicator
"""

ncenter = 5
nsample = 500
nsnp = 1000

# type I error
bb = reshape(repeat([2.0, 0.0, -1], inner=5), 5, 3)

result = zeros(nsnp, 12)

for i in 1:nsnp
    sim_dat = sim_logistic(ncenter, nsample, bb, 0.7, ['b',]; seed=1234)
    nw2 = newton_distributed2(logistic_loglik, logistic_gradient, logistic_hessian,
                              zeros(3), sim_dat[1], sim_dat[2])
    result[i,1] = nw2[1][2]
    result[i,2] = nw2[2][2]
    result[i,3] = nw2[6][2]
    result[i,4] = nw2[7][2]

    logstat = logistic_stat(sim_dat[1], sim_dat[2], 3, 2)
    meta2 = meta_logistic(logstat[1],logstat[2],logstat[3], logstat[4])

    result[i,5] = meta2[1]
    result[i,6] = sqrt(meta2[2])
    result[i,7] = meta2[3]
    result[i,8] = meta2[4]

    result[i,9] = meta2[5][2]
    result[i,10] = sqrt(meta2[6][2,2])
    result[i,11] = meta2[7][2]
    result[i,12] = meta2[8][2]
end


result
sum(result[:,4] .< 0.05)/nsnp
sum(result[:,8] .< 0.05)/nsnp
sum(result[:,12] .< 0.05)/nsnp

# power
bb = reshape(repeat([2.0, 0.3, -1], inner=5), 5, 3)

result = zeros(nsnp, 12)

for i in 1:nsnp
    sim_dat = sim_logistic(ncenter, nsample, bb, 0.7, ['b',]; seed=1234)
    nw2 = newton_distributed2(logistic_loglik, logistic_gradient, logistic_hessian,
                              zeros(3), sim_dat[1], sim_dat[2])
    result[i,1] = nw2[1][2]
    result[i,2] = nw2[2][2]
    result[i,3] = nw2[6][2]
    result[i,4] = nw2[7][2]

    logstat = logistic_stat(sim_dat[1], sim_dat[2], 3, 2)
    meta2 = meta_logistic(logstat[1],logstat[2],logstat[3], logstat[4])

    result[i,5] = meta2[1]
    result[i,6] = sqrt(meta2[2])
    result[i,7] = meta2[3]
    result[i,8] = meta2[4]

    result[i,9] = meta2[5][2]
    result[i,10] = sqrt(meta2[6][2,2])
    result[i,11] = meta2[7][2]
    result[i,12] = meta2[8][2]
end


result
sum(result[:,4] .< 0.05)/nsnp
sum(result[:,8] .< 0.05)/nsnp
sum(result[:,12] .< 0.05)/nsnp


# beta not equal - different intercept

# type I error
bb = [3.5 0.0 -1.0;
      2.5 0.0 -1.0;
      2.0 0.0 -1.0;
      1.2 0.0 -1.0;
      1.5 0.0 -1.0]

result = zeros(nsnp, 12)

# with/without center indicator
for i in 1:nsnp
    sim_dat = sim_logistic(ncenter, nsample, bb, 0.7, ['b',]; strata=true, seed=1234)
    nw2 = newton_distributed2(logistic_loglik, logistic_gradient, logistic_hessian,
                              zeros(7), sim_dat[1], sim_dat[2])
    result[i,1] = nw2[1][2]
    result[i,2] = nw2[2][2]
    result[i,3] = nw2[6][2]
    result[i,4] = nw2[7][2]

    logstat = logistic_stat(sim_dat[1], sim_dat[2], 3, 2)
    meta2 = meta_logistic(logstat[1],logstat[2],logstat[3], logstat[4])

    result[i,5] = meta2[1]
    result[i,6] = sqrt(meta2[2])
    result[i,7] = meta2[3]
    result[i,8] = meta2[4]

    nw3 = newton_distributed2(logistic_loglik, logistic_gradient, logistic_hessian,
                              zeros(3), sim_dat[1], sim_dat[3])

    result[i,9] = nw3[1][2]
    result[i,10] = nw2[2][2]
    result[i,11] = nw2[6][2]
    result[i,12] = nw2[7][2]
end

sum(result[:,4] .< 0.05)/nsnp
sum(result[:,8] .< 0.05)/nsnp
sum(result[:,12] .< 0.05)/nsnp



bb[:,2] = 0.1

result = zeros(nsnp, 12)

# with/without center indicator
for i in 1:nsnp
    sim_dat = sim_logistic(ncenter, nsample, bb, 0.7, ['b',]; strata=true, seed=1234)
    nw2 = newton_distributed2(logistic_loglik, logistic_gradient, logistic_hessian,
                              zeros(7), sim_dat[1], sim_dat[2])
    result[i,1] = nw2[1][2]
    result[i,2] = nw2[2][2]
    result[i,3] = nw2[6][2]
    result[i,4] = nw2[7][2]

    logstat = logistic_stat(sim_dat[1], sim_dat[2], 3, 2)
    meta2 = meta_logistic(logstat[1],logstat[2],logstat[3], logstat[4])

    result[i,5] = meta2[1]
    result[i,6] = sqrt(meta2[2])
    result[i,7] = meta2[3]
    result[i,8] = meta2[4]

    nw3 = newton_distributed2(logistic_loglik, logistic_gradient, logistic_hessian,
                              zeros(3), sim_dat[1], sim_dat[3])

    result[i,9] = nw3[1][2]
    result[i,10] = nw2[2][2]
    result[i,11] = nw2[6][2]
    result[i,12] = nw2[7][2]
end

sum(result[:,4] .< 0.05)/nsnp
sum(result[:,8] .< 0.05)/nsnp
sum(result[:,12] .< 0.05)/nsnp
