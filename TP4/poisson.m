function [N,matrice] = poisson(lambda,area)
  #------------------ On tire les N v.a. de Poisson -------------

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
  x = rand(1,N)';
  y = rand(1,N)';
  matrice = [x,y];

endfunction 