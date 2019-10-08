#N moyen

n = 100; #number of iterations
somme = 0;
for i = 1:n
  N = poisson();
  somme = somme + N;
endfor

N_moyen = somme/n
