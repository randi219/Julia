"""
simulation - multiple centers
-----------------------------
1. simplest case - all centers has same effect
2. different intercepts & center indicator

setting:
1. three centers
2. nuisance parameter - intercept & one
3. number in each center = 500
"""

include("/home/randi/randi/julia2016/Julia/Newton_method_logistic.jl")

using Distributions

## scenario 1 - all equal effect
M = [1.0 0.0;
     0.0 1.0]  #> assuming no correlation between predictors
nobs = 500     #> number in each center
nvars = size(M, 1) #> number of predictors
L = chol(M)
beta_s = [1,2]
intercept_s = 3


srand(2016)
# center 1
r1 = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
z1 = *(r1', beta_s) + intercept_s
y1 = Array(Int64, 1, nobs)
for i = 1:nobs
  y1[i] = rand(Binomial(1, 1/(1+exp(-1*z1[i]))),1)[1]
end

# center 2
r2 = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
z2 = *(r2', beta_s) + intercept_s
y2 = Array(Int64, 1, nobs)
for i = 1:nobs
  y2[i] = rand(Binomial(1, 1/(1+exp(-1*z2[i]))),1)[1]
end

# center 3
r3 = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
z3 = *(r3', beta_s) + intercept_s
y3 = Array(Int64, 1, nobs)
for i = 1:nobs
  y3[i] = rand(Binomial(1, 1/(1+exp(-1*z3[i]))),1)[1]
end

# predictors
X1 = hcat(fill(1.0, (nobs,1)), r1')
X2 = hcat(fill(1.0, (nobs,1)), r2')
X3 = hcat(fill(1.0, (nobs,1)), r3')

# pooled
X = vcat(X1, X2, X3)
y = [x::Int for x in hcat(y1,y2,y3)] #> convert to vector of int

# initial values
w0 = [0.0, 0.0, 0.0]
# estimation
fitnm = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                      w0, y, X)

fitnm1 = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                       w0, vec(y1), X1)

fitnm2 = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                       w0, vec(y2), X2)

fitnm3 = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                        w0, vec(y3), X3)

# distributed
fitnmd = newton_method_distributed(logistic_loglik, logistic_gradient, logistic_hessian,
                                   w0, vec(y1), X1, vec(y2), X2, vec(y3), X3)
fitnm




## scenario 2
intercept_s1 = 3
intercept_s2 = 4
intercept_s3 = 5

srand(2016)
# center 1
r1 = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
z1 = *(r1', beta_s) + intercept_s1
y1 = Array(Int64, 1, nobs)
for i = 1:nobs
  y1[i] = rand(Binomial(1, 1/(1+exp(-1*z1[i]))),1)[1]
end

# center 2
r2 = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
z2 = *(r2', beta_s) + intercept_s2
y2 = Array(Int64, 1, nobs)
for i = 1:nobs
  y2[i] = rand(Binomial(1, 1/(1+exp(-1*z2[i]))),1)[1]
end

# center 3
r3 = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
z3 = *(r3', beta_s) + intercept_s3
y3 = Array(Int64, 1, nobs)
for i = 1:nobs
  y3[i] = rand(Binomial(1, 1/(1+exp(-1*z3[i]))),1)[1]
end

"""predictors
since we have 3 centers, we need three dummy variables c1, c2, c3
            c1      c2
center1     0       0
center2     1       0
conter3     0       1
"""

X11 = hcat(X1, fill(0,(nobs,1)), fill(0,(nobs,1)))
X21 = hcat(X2, fill(1,(nobs,1)), fill(0,(nobs,1)))
X31 = hcat(X3, fill(0,(nobs,1)), fill(1,(nobs,1)))

w01 = zeros(5)

fitnmd1 = newton_method_distributed(logistic_loglik, logistic_gradient, logistic_hessian,
                                   w01, vec(y1), X11, vec(y2), X21, vec(y3), X31)
