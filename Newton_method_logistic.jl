"""
Newton-Raphson method
---------------------
Newton's method for logistic regression
    loglikelihood function
    gradient function
    hessian function
    Newtion-Raphson function
"""


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
      res[i] = X[i,j] * (y[i] - exp(vecdot(X[i,:], Beta))/(1 + exp(vecdot(X[i,:], Beta))))
    end
    g[j] = sum(res)
  end

  return g
end


# hessian matrix
function logistic_hessian(y::Vector{Int64},
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


# Newton's method
function newton_method(f::Function, fp1::Function, fp2::Function,
                       b0, y, X;
                       tolerance=1e-6, maxiter=100)
  b = b0
  oldf = f(y, X, b)
  iter = 0

  for i = 1:maxiter
    iter = iter + 1
    #println(iter)
    newb = b - *(inv(fp2(y, X, b)), fp1(y, X, b))
    #println(newb)
    newf = f(y, X, newb)
    #println(newf)
    relative_change = abs(newf - oldf) / oldf
    #println(relative_change)
    if abs(relative_change) > tolerance
      b = newb
      oldf = newf
    else
      break
    end
  end

  iter < maxiter || error("Did not converge in ", maxiter, " steps.")

  loglik = oldf
  hessian = fp2(y, X, b)

  """return
  estimated beta coef, number of iteration, loglikelihood,
  and hessian"""
  return b, iter, loglik, hessian
end



# distributed - 3 centers
function newton_method_distributed(f::Function, fp1::Function, fp2::Function,
                                   b0, y1, X1, y2, X2, y3, X3;
                                   tolerance=1e-6, maxiter=100)
  b = b0

  oldf1 = f(y1, X1, b)
  oldf2 = f(y2, X2, b)
  oldf3 = f(y3, X3, b)
  oldf =  oldf1 + oldf2 + oldf3

  iter = 0

  for i = 1:maxiter
    iter = iter + 1
    newb = b - *(inv(fp2(y1, X1, b) + fp2(y2, X2, b) + fp2(y3, X3, b)),
                 (fp1(y1, X1, b) + fp1(y2, X2, b) + fp1(y3, X3, b)))
    newf1 = f(y1, X1, newb)
    newf2 = f(y2, X2, newb)
    newf3 = f(y3, X3, newb)
    newf = newf1 + newf2 + newf3

    relative_change = abs(newf - oldf) / oldf
    relative_change1 = abs(newf1 - oldf1) / oldf1
    relative_change2 = abs(newf2 - oldf2) / oldf2
    relative_change3 = abs(newf3 - oldf3) / oldf3
    #println(relative_change)
    if abs(relative_change) > tolerance ||
        abs(relative_change1) > tolerance ||
        abs(relative_change2) > tolerance ||
        abs(relative_change3) > tolerance
      b = newb
      oldf = newf
      oldf1 = newf1
      oldf2 = newf2
      oldf3 = newf3
    else
      break
    end
  end

  iter < maxiter || error("Did not converge in ", maxiter, " steps.")

  loglik = oldf
  hessian = fp2(y1, X1, b) + fp2(y2, X2, b) + fp2(y3, X3, b)

  """return
  estimated beta coef, number of iteration, loglikelihood,
  and hessian"""
  return b, iter, loglik, hessian
end
