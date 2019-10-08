%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%   TP4 - Topologie Algebrique   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

B0v = zeros(200,1);
B1v = zeros(200,1);
Xv = zeros(200,1);

for lambda = 1:200
  lambda
  B0m = 0;
  B1m = 0;
  Xm = 0;

  for N = 1:100
    area = 1;
    pos = poisson(lambda,area);
    epsilon = 0.1;
    phi = linspace(0,1,100);
    x = epsilon/2*cos(2*pi*phi);
    y = epsilon/2*sin(2*pi*phi);
    ##figure()
    ##hold on;
    ##for i = 1:size(pos)(1)
    ##  plot(pos(i,1),pos(i,2),'r.', 'markersize', 10);
    ##  plot(x+pos(i,1),y+pos(i,2),'b');
    ##endfor
    ##axis([-0.1 1.1 -0.1 1.1]);
    proches = zeros(size(pos)(1),size(pos)(1));
    d1 = [];
    d2 = [];
    ##figure()
    ##hold on;
    for i = 1:size(pos)(1)
      dist = sqrt(sum((pos(i,:) - pos).^2,2));
      proches(:,i) = dist<epsilon; 
      u = find(proches(:,i));
      
      v = u(find(u.*(u>i)));
      o = proches(:,i).*eye(size(proches(:,i))(1));
      n = zeros(size(pos)(1),size(v)(1));
      n(i,:) += ones(1,size(v)(1));
      n -= o(:,v);
      d1 = [d1 n];
      
    ##  for j = 1:size(u)(1)
    ##    dx = pos(u(j),1)-pos(i,1);
    ##    dy = pos(u(j),2)-pos(i,2);
    ##    a = phi*dx+pos(i,1);
    ##    b = phi*dy+pos(i,2);
    ##    plot(a,b,'g');
    ##    plot(pos(i,1),pos(i,2),'r.', 'markersize', 20);
    ##  endfor
    endfor
    ##axis([-0.1 1.1 -0.1 1.1]);

    arestas = (sum(proches(:))-size(pos)(1))/2;
    d0 = sum(proches)==1; 

    for i = 2:size(pos)(1) 
      u = find(proches(:,i));
      x = u(find(u.*(u<i)));
      for j = 1:size(x)(1)
        f = find(proches(:,i).*proches(:,u(j)));
        ind = f(find(f.*(f>i)));
        trig = zeros(size(d1)(2),size(ind)(1));
        for k =1:size(ind)(1)
          e = zeros(size(pos)(1),1);
          e(x(j)) = 1;
          e(i) = -1;
          p = find(sum(d1==e)==size(pos)(1));
          e(i) = 0;
          e(ind(k)) = -1;
          q = find(sum(d1==e)==size(pos)(1));
          e(x(j)) = 0;
          e(i) = 1;
          e(ind(k)) = -1;
          r = find(sum(d1==e)==size(pos)(1));
          trig(p,k)= 1;
          trig(q,k)= -1;
          trig(r,k)= 1;
        endfor
        d2 = [d2 trig];
      endfor
    endfor

    B0 = sum(d0==0)-rank(d1);
    B1 = size(d1)(2)-rank(d1)-rank(d2);
    X = B0-B1;

    
    B0m += B0; 
    B1m += B1;
    Xm += X;
  endfor
  B0v(lambda) = B0m/N;
  B1v(lambda) = B1m/N;
  Xv(lambda) = Xm/N;
endfor

figure()
plot(B0v);grid;
print -djpg B0.jpg
figure()
plot(B1v);grid;
print -djpg B1.jpg
figure()
plot(Xv);grid;
print -djpg X.jpg