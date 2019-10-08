% TP RIO207
clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Asumptions:
## Limiting link: downlink
## Environment: Urban
## Deep indoor propagation
## Approximate Shannon formula: C ~ alpha*W*log_2(1+SNR/beta)
f = 2.6e9;
transmit_antenna = 2;
transmit_power = 46; % dBm
sigma = 6;
W = 20e6;
Nharq = 4;
cable_loss =3; % dB, use of TMA
Pout = 0.05;
alpha = 0.75;
beta = 1.25;
eta = 0.75;
antenna_gain = 19; % dBi
D = 3e6;
FDPS = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Assumptions
T = 290;
k = 1.38064852e-23;
NF = 2.4;
N = 10*log10(1000*k*T*W)+NF;
K = 1.64*sigma;
cable = 3.5;
m_penetration = 18; % 15 urbain + 3 2nd wall
SNR = 10*log10(beta*2^(D/(alpha*W))-1);
Mi = 10*log10(1+10^(SNR/10));
marges = K + m_penetration + Mi + cable;
S = SNR+N;
MAPL = transmit_power+3+antenna_gain-S-marges; % +3 two antennas
##  Look for charge in page 103
A = 141.65;
B = 35.22;
C = -2.94;

Rmax = 10^((MAPL-A+C)/B)

%%%%%%%%%%%%%%%%%%%%%%% Placement Optimization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Creation des sites des antennes %%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = 10e3;
S = 196;
x = linspace(0,L,sqrt(S)+2);
x = x(2:end-1);
pos_antennes = [];
for i = 1:length(x)
  for j = 1:length(x)
    pos_antennes = [pos_antennes;x(i),x(j)];
  endfor
endfor

%%%%%%%%%%%%%%%%% On tire les positions des utilisateurs %%%%%%%%%%%%%%%%%%%%%%
R = 1e3; % Rayon de concentration des utilisateurs
phi = 2*pi*rand(1,250);
r = R*sqrt(rand(1,250));
x = r.*cos(phi);
y = r.*sin(phi);
matrice = [x;y];
cent = R + (L-2*R)*rand(1,2);
pos_users = matrice' + cent;
x = L*rand(1,250);
y = L*rand(1,250);
matrice = [x',y'];
pos_users = [pos_users;matrice];
 
clear x y phi r y a R matrice

Nue = 500;
w = 15;
Ru = 1;
Cb = 5;
Bmax = 30;


antennes = pos_antennes(ceil(S*rand(w,1)),:); % Positionnement de |w| antennes

% Calcul de distance utilisateurs-antennes
dist = zeros(length(pos_users),length(antennes));
for i = 1:length(antennes)
  dist(:,i) = sqrt(sum((pos_users-antennes(i,:)).^2,2));
endfor
% Calcul du nombre d'utilisateurs servis
cell_proche = min(dist,[],2);
Nw = sum(cell_proche < (Rmax*1000));

%%%%%%%%%%%%%%%%% Demonstration conditions initiales %%%%%%%%%%%%%%%%%%%%%%%%%%%
figure();
plot(antennes(:,1),antennes(:,2),'kx');
#plot(pos_antennes(:,1),pos_antennes(:,2),'b*');
hold on;
plot(pos_users(:,1),pos_users(:,2),'ro');
phi = linspace(0,2*pi,100);
x = 1000*Rmax*cos(phi);
y = 1000*Rmax*sin(phi);
for i = 1:length(antennes)
  plot(x+antennes(i,1),y+antennes(i,2),'b');
endfor
print -djpg start.jpg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m =0;
Zo = 1e3;
Z = Zo;
Ut = [-Ru*Nw+Cb*w];
wt = [w];
while (Z > 1e-5)
  m+=1;
##  if mod(m,10) ==0
##    m
##    Z
##    U
##  endif
  U = -Ru*Nw+Cb*w;
  % Tirage aleatoire
  r = rand();
  if (r<=1/3)
    % Addition d'une antenne
    if (size(antennes)(1) <30)
      c = 1;
      while (c!=0)
        new = pos_antennes(ceil(S*rand()),:);
        c = sum(sum(antennes(:,1:2)==new,2)==2);
      endwhile
      nantennes = [antennes;new];
      nw=w+1;
    endif
  elseif (r>2/3)
    % Suppression d'une antenne
    if (size(antennes)(1)>1)
      p = ceil(w*rand());
      if (p==w)
        p-=1;
      endif
      nantennes = [antennes(1:p-1,:);antennes(p+1:w,:)];
      nw=w-1;
    endif
  else
    % Changement d'une antenne
    p = ceil(w*rand());
    c = 1;
    while (c!=0)
      new = pos_antennes(ceil(S*rand()),:);
      c = sum(sum(antennes(:,1:2)==new,2)==2);
    endwhile
    nantennes =antennes;
    antennes(p,:) = new;
    nw = w;
  endif
  dist = zeros(size(pos_users)(1),size(nantennes)(1));
  for i = 1:size(nantennes)(1)
    dist(:,i) = sqrt(sum((pos_users-nantennes(i,:)).^2,2));
  endfor
  % Calcul du nombre d'utilisateurs servis
  cell_proche = min(dist,[],2);
  nNw = sum(cell_proche < (Rmax*1000));
  Un = -Ru*nNw+Cb*nw;
  Xi = min(1,exp(-(Un-U)/Z));
  p = rand();
  Z = Z*0.999;

  if(p<Xi)
    w = nw;
    Nw = nNw;
    antennes = nantennes; 
    Ut = [Ut;Un];
    wt = [wt;nw];
  endif
endwhile
%%%%%%%%%%%%%%%%% Demonstration conditions finales %%%%%%%%%%%%%%%%%%%%%%%%%%%

U
nw
Nw

figure();
plot(antennes(:,1),antennes(:,2),'kx');
#plot(pos_antennes(:,1),pos_antennes(:,2),'b*');
hold on;
plot(pos_users(:,1),pos_users(:,2),'ro');
phi = linspace(0,2*pi,100);
x = 1000*Rmax*cos(phi);
y = 1000*Rmax*sin(phi);
for i = 1:length(antennes)
  plot(x+antennes(i,1),y+antennes(i,2),'b');
endfor
print -djpg fin.jpg
%w=12 U=-252 N=312
figure();
plot(Ut);
title('Evolution de l`énergie au fil des itérations');
print -djpg Ut.jpg
figure();
plot(wt);
title('Evolution du nombre de stations de base au fil des itérations');
print -djpg wt.jpg