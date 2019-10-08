[N,M] = poisson_circ(0.01);
M = M';
p = 0.01;
n = 1;
X = binornd (n, p, N, 1);
user = M(find(X),:);
nuser = length(user);
ruser= sqrt(user(:,1).^2+user(:,2).^2);

figure(1)
plot(M(:,1),M(:,2),'.k');
phi = linspace(0,2*pi,1000);
r = 320;
x = r.*cos(phi);
y = r.*sin(phi);
hold on
plot(x,y,'g','linewidth',2);
plot(user(:,1),user(:,2),'.r',"markersize", 10);
grid on;

C = 162e3;
w = 180e3;
SNRmin=0.1;
K= 1e6;
gamma = 2.8;
qmax = ceil(C/(w*log2(1+SNRmin)));


S = 160;
F = zeros(21,10000);
outage = zeros(21,1);

for j = 1:21
  for i = 1:10000
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulation du process
    [N,M] = poisson_circ(0.01);
    M = M';
    X = binornd (1, 0.01, N, 1);
    user = M(find(X),:);
    
    ruser= sqrt(user(:,1).^2+user(:,2).^2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    q = ceil(C./(w.*log2(1+K./ruser.^gamma)));
    F(j,i) = sum(q);
    if (sum(q) >= S)
      outage(j) += 1;
    endif
  endfor
  S +=1;
endfor

% alpha et beta mesurés par les formules
% 
F = F(:);
Py = [];
for y = mean(F):max(F)
  Py = [Py;sum((F >= y))/length(F)];
endfor

yt = linspace(mean(F),max(F),max(F)-mean(F)+1);
Pyt = exp( -(yt/beta + (alpha/beta)^2) .* ln(1+beta*yt/alpha^2) + yt/beta )

figure(3)
plot(y, Py);
hold on
plot(yt, Pyt,'r');
legend('courbe partique', 'courbe teorique');
xlabel('E(F) + y');
ylabel('P(F>= E(F) + y)');

