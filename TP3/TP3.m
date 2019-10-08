# TP 3 Fitting
clear all
close all
id = tic();
% Pour appliquer a d'autres fichiers changez juste ces deux prochaines lignes
% le reste ce fera automatiquement
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changez orange_gsm par le nom du fichier que vous voulez
load('Fichiersmatlab/free_lte.mat');
% Changez orange_gsm par le nom du fichier que vous voulez
plan = free_lte;
disp("Traitement du fichier: free_lte")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = abs(plan(:,1))<5000;
v = abs(plan(:,2))<3000;
inner = plan(find(u.*v),:);   % Points dedans le carre

figure()
plot(plan(:,1),plan(:,2),'o');
m = linspace(-3000,3000,1200)';
n = linspace(-5000,5000,2000)';
hold on;
plot(repmat(-5000,1200,1),m,'k');
plot(repmat(5000,1200,1),m,'k');
plot(n,repmat(-3000,2000,1),'k');
plot(n,repmat(3000,2000,1),'k');
plot(inner(:,1),inner(:,2),'ro'); % Verifier les points dedans le carré
xlabel('Distance [m]');
ylabel('Distance [m]');
title('Carte des stations de base de Paris');
print -djpg carte_free_lte.jpg

lambda = length(inner)/(6000*10000); % lambda = Nbre de elements/surface

% Variables lourdes et inutiles 
clear m n u v


% Vecteur des rayons a tester de 0.01 a 700 m
rs = linspace(0.01, 700, 70000)';
% Distance d'un point du carre a la bts la plus proche
dist_point = zeros(length(rs),1);
% Distance d'une bts a la bts la plus proche
dist_bs = zeros(length(rs),1);
% Nombre de points testes dans le carre M/dx x N/dy
E = 1000*600;
% Initialisation au coin du carre

for i = 1:E
  pt = [-5000,-3000]+[10000.0,6000.0].*rand(1,2);
  dists = sqrt(sum((pt-plan).^2,2)); % Distance du point a tous les bts
  d = min(dists);                       % Plus proche voisin
  dist_point += rs>d; 
endfor

%% Formule
Fc = dist_point/E;

for i = 1:length(inner)
  % Distance d'une bts a toutes les autres
  dists = sqrt(sum((inner(i,:)-plan).^2,2));
  d = min(dists(dists>0)); % plus proche voisin (sauf lui-même)
  dist_bs += rs>d;
endfor
% Variables lourdes et inutiles 
clear dists
% Formule
Gc = dist_bs/length(inner);

% Formule
Jc = (1-Gc)./(1-Fc);

% Plot
figure()
plot(rs,Fc,'b');
hold on; grid;
plot(rs,Gc,'r');
xlabel('Rayon [m]');
ylabel('Probabilite');
legend('F','G');
title("Probabilites F et G definies dans le TP");
print -djpg FG_free_lte.jpg

figure()
plot(rs,Jc,'g');
xlabel('Rayon [m]');
ylabel('Probabilite');
title("Fonction J definies dans le TP");
print -djpg J_free_lte.jpg

% Vecteur des rayons a tester de 0.01 a 300 m (deja au carre)
rs = rs(1:30000);
r2 = rs.^2;
% Jc de ses rayons
Jh = Jc(1:30000);
% Variables lourdes et inutiles 
% clear rs Jc Fc Gc

% Moindres carrés iteratif
beta = 0.01;
J = (1 ./(1-beta+beta.*exp(-lambda.*pi.*r2./beta)));
err = sum((Jh-J).^2);
errmin = err;
betamin = beta;
while beta<=1
  beta+=0.01; % Si vous voulez accompagner les iterations enlevez le ; ici
  J = (1 ./(1-beta+beta*exp(-lambda*pi*r2/beta)));
  err = sum((Jh-J).^2);
  if (err < errmin)
    errmin = err;
    betamin = beta;
  endif
endwhile
J = (1 ./(1-betamin+betamin*exp(-lambda*pi*r2/betamin)));
lambda
betamin
err
figure()
plot(rs,J,"b");
hold on
plot(rs,Jh,"r");
xlabel('Rayon [m]');
ylabel('J');
legend('J','Jestime');
title("Fonction J definie dans le TP");
print -djpg JJ_free_lte.jpg

toc(id)