function [N,matrice] = poisson_circ(lambda)
  #Question 1
  #This function gives the number "N" of users/base stations
  #(using Poisson's distribution) and its corresponding position in space
  #(by using a Uniform distribution), which is stored in the matrix "matrice".
  #
  #lambda: intensity of Poisson's distribution (en km^-2)
  #show: when show = 1, the function makes a plot. When show = 0, it does not
  #make a plot.
  #
  #N: number of users/base stations
  #matrice: matrix of dimensions 2xN. Each column is a pair of x and y
  #coordinates.
  #------------------ On tire les N v.a. de Poisson -------------
  R = 320;
  area = pi*R^2;
  uni = rand(1);
  expo = (-1/(lambda*area))*log(uni);
  
  k = 1;
  somme = expo;
  while (somme <= 1)
    uni = rand(1);
    expo = (-1/(lambda*area))*log(uni);
    k = k + 1;
    somme = somme + expo;
  endwhile
  
  N = k - 1;
  #---------------- On tire les positions des points -------------
  phi = 2*pi*rand(1,N);
  r = R*sqrt(rand(1,N));
  x = r.*cos(phi);
  y = r.*sin(phi);
  matrice = [x;y];

endfunction 