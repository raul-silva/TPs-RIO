pkg load statistics
lambda = 0.01;
[N,M] = poisson_circ(lambda);
M = M';
p = 0.01;
n = 1;
X = binornd (n, p, N, 1);
user = M(find(X),:);
nuser = length(user);

phi = linspace(0,2*pi,1000);
r = 320;
x = r.*cos(phi);
y = r.*sin(phi);

figure(1)
plot(M(:,1),M(:,2),'.k');
hold on
plot(x,y,'g','linewidth',2);
hold on
plot(user(:,1),user(:,2),'.r',"markersize", 10);
grid on;

C = 162e3;
w = 180e3;
SNRmin=0.1;
K= 1e6;
gamma = 2.8;
qmax = ceil(C/(w*log2(1+SNRmin)));


S = 160:180;
F = zeros(10000,1);

for i = 1:10000
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Simulating the process
  [N,M] = poisson_circ(0.01);
  M = M';
  X = binornd (n, p, N, 1);
  user = M(find(X),:);
  ruser= sqrt(user(:,1).^2+user(:,2).^2);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  q = ceil(C./(w.*log2(1+K./ruser.^gamma)));
  F(i) = sum(q);
endfor

outage = zeros(21,1);
for i = 1:length(S)
  outage(i) = sum(F > S(i));
endfor

% alpha et beta par la formule
beta = qmax;
alpha = sqrt(lambda*p*pi)*beta*r;
Py = [];
for y = ceil(mean(F)):2*max(F)
  Py = [Py;sum(F >= y)/length(F)];
endfor

y = [ceil(mean(F)):2*max(F)]-ceil(mean(F));
Pyt= exp( -(y./beta +(alpha/beta)^2) .* log(1+beta.*y./alpha^2) + y./beta);

figure()
semilogy(y+ceil(mean(F)),Py);
hold on; grid on;
semilogy(y+ceil(mean(F)),Pyt);
plot(243,0.01,'o');
legend('Courbe experimental','Courbe theorique');
## Etude de cas
outage_etude = zeros(8,1);
S= ceil(mean(F))+y(find(Pyt<0.01)(1));

## Observation:
## j = 1,2 variation lambda +/- 10%
## j = 3,4 variation lambda +/- 20%
## j = 5,6 variation gamma +/- 5%
## j = 7,8 variation gamma +/- 2%
## L'execution de cette partie prend du temps

 for j = 1:8
  switch(j)
    case 1
      lambdan = 0.9*lambda;
      gamman = gamma;
    case 2
      lambdan = 1.1*lambda;
      gamman = gamma;
    case 3
      lambdan = 0.8*lambda;
      gamman = gamma;
    case 4
      lambdan = 1.2*lambda;
      gamman = gamma;
    case 5
      lambdan = lambda;
      gamman = 0.95*gamma;
    case 6
      lambdan = lambda;
      gamman = 1.05*gamma;
    case 7
      lambdan = lambda;
      gamman = 0.98*gamma;
    case 8
      lambdan = lambda;
      gamman = 1.02*gamma;
  endswitch
  
  for i = 1:10000
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulating the process
    [N,M] = poisson_circ(lambdan);
    M = M';
    X = binornd (n, p, N, 1);
    user = M(find(X),:);
    ruser= sqrt(user(:,1).^2+user(:,2).^2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    q = ceil(C./(w.*log2(1+K./ruser.^gamman)));
    
    if (sum(q) >= S)
      outage_etude(j) += 1;
    endif
    
  endfor
  
endfor

outage_etude /= 10000
save('results.m', 'outage_etude','S','Py','Pyt');

