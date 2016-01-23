function I = graphinfo(G,oracle)
% Returns relevant graph parameters of G for comparing performance of S2,
% BFS, and Approximate S2

n=size(G,1);

Vp=find(oracle==1);
Vn=find(oracle==-1);

C=find(G(Vp,Vn));

deltaC=boundary(G,oracle);

deltaCn = deltaC(oracle(deltaC)==-1);

I = [n, length(Vp), length(C), length(deltaC), length(deltaCn)];

end