# loglikelihood function - logistic regression model
function logistic_loglik(y::Vector{Int64},
                         X::Array{Float64},
                         Beta::Vector{Float64})
  n = length(y)
  res = zeros(n)
  for i = 1:n
    res[i] = y[i] * vecdot(X[i,:], Beta) - log(1 + exp(vecdot(X[i,:], Beta)))
  end
  return sum(res)
end



# test function
arr1 = [1.0 2 3 4 ;
        5 6 7 8 ;
        1 2 3 4 ;
        5 6 7 8]
v = collect(1:4.0)
b = [0,1,0,1]

logistic_loglik(b, arr1, v)


# gradient
function logistic_gradient(y::Vector{Int64},
                           X::Array{Float64},
                           Beta::Vector{Float64})
  n = length(y)
  nbeta = length(Beta)
  g = zeros(nbeta)

  for j = 1:nbeta
    res = zeros(n)
    for i = 1:n
      res[i] = y[i] * (X[i,j] - exp(vecdot(X[i,:], Beta))/(1 + exp(vecdot(X[i,:], Beta))))
    end
    g[j] = sum(res)
  end

  return g
end


logistic_gradient(b, arr1, v)



# hessian matrix
function logsitic_hessian(y::Vector{Int64},
                           X::Array{Float64},
                           Beta::Vector{Float64})
  n = length(y)
  nbeta = length(Beta)
  h = Array(Float64, nbeta, nbeta)

  for k = 1:nbeta
    for j = 1:nbeta
      res = zeros(n)
      for i = 1:n
        res[i] = -1 * X[i,k] * X[i,j] *
                  exp(vecdot(X[i,:], Beta)) / (1 + exp(vecdot(X[i,:], Beta)))^2
      end
      h[k,j] = sum(res)
    end
  end

  return(h)
end

logsitic_hessian(b, arr1, v)


# simulation - logistic regression
M = [1.0 0.5;
     0.5 1.0]
nobs = 1000
nvars = size(M, 1)
L = chol(M)

using Distributions

srand(12345)

r = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
r = r'
z = *(r, [2 1]') + 1
y = Array(Int64, 1, nobs)
for i = 1:nobs
  y[i] = rand(Binomial(1, 1/(1+exp(-1*z[i]))),1)[1]
end


Pkg.add("GLM")
using GLM

y1 = Array(Bool, 1, nobs)
for i = 1:length(y)
  y1[i] = convert(Bool, y[i])
end
y1

#data = DataFrame(Y=vec(y), X1=vec(r[:,1]), X2=vec(r[:,2]))
dat = convert(DataFrame, r) #> convert array to dataframe
dat[:Y] = @data(vec(y1))

fit1 = glm(Y ~ x1 + x2, dat, Binomial(), LogitLink())
fit1
vcov(fit1)
est1 = coef(fit1)

dat1 = dat[:, [:Y, :x1, :x2]]
dat1[:, :Y] = 1.0
dat1 = convert(Array, dat1)

h1 = logsitic_hessian(vec(y), dat1, est1)
inv(-1*h1)
