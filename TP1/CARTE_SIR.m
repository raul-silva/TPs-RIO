% Creation de la carte SIR

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IGOR: NAO RODE O CODIGO DENOVO PARA NAO PERDERMOS AS VARIAVEIS UTILIZADAS NA%
% PRIMEIRA SIMULACAO. AS VARIAVEIS FORAM SALVAS JUSTAMENTE PARA PODER USA-LAS %
% DENOVO NAS OUTRAS SIMULACOES                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% utilisation de certaines fontions de statistiques
pkg load statistics

% Parametres fixes
a = 1000;
div = 101;
gamma = 2.5;
sigma = 2;

% generation d'un processus de poisson pour les stations de base
[N,k] = poisson(0);
k = [k(2,:);k(1,:)]';

% Discretisation de l'espace
x = linspace(0,a,div)';
X = [repmat(x(1),div,1),x];
for i = 2:length(x)
  X = [X;repmat(x(i),div,1),x];
endfor
% Conversion m => km
X = X/1000;

% Taille de la grille de discretisation
m = length(X);

% Calcul de la distance de chaque point par rapport à chaque antenne
dist = zeros(m,N);
for i = 1:N
  dist(:,i) = sqrt(sum((k(i,:)-X).^2,2));
endfor

% Distance minimale limite a 0.005
distc = dist;
distc(distc<0.005) = 0.005;

% Calcul de S
S = zeros(m,N);

for i = 1:m
  afad = exprnd(1,[N,1]);
  ashad = 10.^(sigma*randn([N,1])/10);
  P = rand([N,1]);
  S(i,:) = P.*afad.*ashad./(distc(i,:).^gamma)';
endfor

% Calcul de SIR: critere de la distance minimale
[~,j] = min(dist,[],2);
SIR = zeros(m,1);
for i = 1:m
    SIR(i) = S(i,j(i))/(sum(S(i,:))-S(i,j(i)));
endfor
SIR = 10*log10(SIR);

% Generation du graphique
scatter (X(:,1), X(:,2), 20, SIR, "filled");
hold on
voronoi(k(:,1),k(:,2));

% Calcul du SIR: critere du maximum de puissance
[~,j] = max(S,[],2);
SIR2 = zeros(m,1);
for i = 1:m
    SIR2(i) = S(i,j(i))/(sum(S(i,:))-S(i,j(i)));
endfor
SIR2 = 10*log10(SIR2);

% Generation du graphique
scatter (X(:,1), X(:,2), 40, SIR2, "filled");
hold on
voronoi(k(:,1),k(:,2));

% Saving variables
save('TP1.m','k','SIR','SIR2', 'S', 'X','P','dist')
% to work with these variable simply type:
% load(TP1.m)
