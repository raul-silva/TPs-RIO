##F = F(:);
##% alpha et beta par la formule
##beta = max(F)
##alpha = sqrt(lambda*pi)*beta*r;
##mu = ceil(mean(F));
##yt = [mu:max(F)]-mu;
##Py = sum(F >= yt+mu)/length(F);
##Pyt= exp( -(yt./beta +(alpha/beta)^2).*log(1+beta.*yt./alpha^2) + yt./beta);
##
##figure(2)
##plot(yt,Py,'r');
##hold on; grid on;
##plot(yt,Pyt,'b');

## Etude de cas
outage_etude = zeros(8,1);
S= 170;

## Observation:
## j = 1,2 variation lambda +/- 10%
## j = 3,4 variation lambda +/- 20%
## j = 5,6 variation gamma +/- 5%
## j = 7,8 variation gamma +/- 2%
for j = 1:8
  switch(j)
    case 1
      disp("case 1")
      lambdan = 0.9*lambda;
      gamman = 2.8;
    case 2
      disp("case 2")
      lambdan = 1.1*lambda;
      gamman = 2.8;
    case 3
      disp("case 3")
      lambdan = 0.8*lambda;
      gamman = 2.8;
    case 4
      disp("case 4")
      lambdan = 1.2*lambda;
      gamman = 2.8;
    case 5
      disp("case 5")
      lambdan = lambda;
      gamman = 2.8*0.95;
    case 6
      disp("case 6")
      lambdan = 1.1*lambda;
      gamman = 2.8*1.05;
    case 7
      disp("case 7")
      lambdan = 1.1*lambda;
      gamman = 2.8*0.98;
    case 8
      disp("case 8")
      lambdan = 1.1*lambda;
      gamman = 2.8*1.02;
    otherwise
      ans;
  endswitch
  
  for i = 1:10000
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulating the process
    [N,M] = poisson_circ(lambdan);
    M = M';
    X = binornd (1, 0.01, N, 1);
    user = M(find(X),:);
    ruser= sqrt(user(:,1).^2+user(:,2).^2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    qmax = ceil(C./(w.*log2(1+K./ruser.^gamman)));
    if (sum(qmax) >= S)
      outage_etude(j) += 1;
    endif
  endfor
endfor



