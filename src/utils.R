vect <- function(n = dimensions,
                 mean = 0,
                 sd = 1 / n) {
  #Generates and arbitary Vector of a particular dimension
  temp <- rnorm(n = n, mean = mean, sd = sd)
  temp <- normalize_vec(temp)
  return(temp)
}
angle <- function(x, y) {
  
  #Find angle between two vector
  
  Dot_Product = sum(x * y)
  Aplitude_product = (sum(x ^ 2) * sum(y ^ 2)) ^ .5
  Cos_theta <- Dot_Product / Aplitude_product
  Angle <- acos(Cos_theta)
  return(c(
    Angle_in_Radian = Angle,
    Angle_in_Degrees = Angle * 180 / pi
  ))
}
amp <- function(x)
  sqrt(sum(x ^ 2))

normalize_vec <- function(x,Disable = F,  Norm_rate = 1) {
  if (Disable == T) {
    return (x)
  } else {
    return (x / (Norm_rate * amp(x)))
  }
}

convol <- function(x, y, norm = FALSE) {
  temp <- Re(ifft(fft(x) * fft(y)))
  if (norm == TRUE) {
    temp <- normalize_vec(temp)
  }
  return(temp)
}

invert <- function(x) {
  return(x[c(1, length(x):2)])
}

inv_convol <- function(z, y) {
  inv_y <- y[c(1, 256:2)]
  temp <- convol(z, y)
  return(normalize_vec(temp))
}