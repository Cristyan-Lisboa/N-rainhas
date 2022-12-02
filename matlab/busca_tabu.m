%% Busca Tabu - problema das n-rainhas
close all
clear all
clc

N = 7;
kmax = 40;
N = 10;
kmax = 20*N^2;
S = [];

Vj1 = 1:N;
Vj2 = [[2:N] 1];
fSj = zeros(N,1);
%% Passo #1
k = 0;
T = zeros(N,N);
Dmin = 1;
Dmax = 3;
Dmin = 1 + floor(N/4);
Dmax = 1 + floor(N/2);
% Determinacao solucao inicial
[tmp,S0] = sort(rand(1,N));
%S0  = [4 5 3 6 7 1 2];
II = 1:N;
ImJ = II - S0;
IpJ = II + S0;
% Numero de ataques
fS0 = 2*N - length(unique(ImJ)) - length(unique(IpJ));
% Solucao incumbente
Sinc = S0;
finc = fS0;
% define a solucao inicial
Sk = S0; 
fSk = fS0;
%[k fSk Sk]
%% Procedimento iterativo
while k < kmax
    %% Passo #2 - vizinhanca
    for k1 = 1:N
        Sj          = Sk;
        Sj(Vj1(k1)) = Sk(Vj2(k1));
        Sj(Vj2(k1)) = Sk(Vj1(k1));
        
        ImJ = II - Sj;
        IpJ = II + Sj;
        fSj(k1) = 2*N - length(unique(ImJ)) - length(unique(IpJ));        
    end
    % Passo 3
    [~, jj] = sort(fSj);
    for k1 = 1:length(fSj)
        ki = Vj1(jj(k1));
        kj = Vj2(jj(k1));
        
        if fSj(jj(k1)) < finc
            Sj = Sk;
            Sj(ki) = Sk(kj);
            Sk = Sj;
            fSk = fSj(jj(k1));
            finc = fSk;
            Sinc = Sk;
            k = k + 1;
            % Satisfaz aspiracao
            D = randi([Dmin Dmax]);
            T(jj(ki)) = k + D;
            %[k fSk Sk]
            break
        end
        
        %if (T(jj(k1)) == 0) ||  (k > T(jj(k1)))
        if k > T(jj(k1))
            Sj = Sk;
            Sj(ki) = Sk(kj);
            Sj(kj) = Sk(ki);
            Sk = Sj;
            fSk = fSj(jj(k1));
            % Passo 5 
            k = k + 1;
            D = randi([Dmin Dmax]);
            T(jj(ki)) = k + D;
            %[k fSk Sk]
            break
        end
    end
    
    if fSk == 0
        S = [S; Sk];
        %break
    end
end
S
