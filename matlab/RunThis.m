%% Trabalho de Otimização Heurística 2 - 02NOV22
% Cristyan Lisbôa e Ederson Machado
% Problema de N-rainhas
% Objetivo: Dispor n-rainhas em um tabuleiro de nXn tal que não ocorram
% ataques
%% Parâmetros do método
clearvars, close all; clc              % limpa variáveis, console e fecha figuras
%soma = 0;
%for l = 1:100
N    = 40;                              % número de rainhas
kmax = 50;                             % número máximo de iterações
Nviz = N*(N-1)/2;                      % número de vizinhos por permutação entre duas linhas
Vi   = zeros(Nviz,1);                  % armazena vizinhos
Vj   = Vi;                             % armazena vizinhos
NA   = Vi;                             % número de ataques
fSj  = Vi;                             % valor da fo
Smj  = zeros(Nviz,N+3);                % matriz de soluções e fo

% Passo 1
k    = 0;                              % contador de iterações
T    = zeros(N,N);                     % matriz dos tabus
%mov  = zeros(N,N);                     % matriz dos movimentos
Dmin = 5;                              % duração mínima dos tabus
Dmax = 2*Dmin;                         % duração máxima dos tabus
%S0   = [4 5 3 6 7 1 2];                % solução inicial fixa
%S0 = [14,11,13,10,18,4,19,2,20,7,15,6,9,17,8,5,16,1,21,3,12];
%S0 = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21];
%S0 = [72,63,3,88,36,79,98,29,37,48,25,73,27,100,42,11,8,62,20,91,65,18,35,90,57,94,46,64,70,93,66,19,97,89,4,92,96,9,1,80,53,76,51,61,44,54,2,13,95,16,15,82,31,69,68,22,60,23,74,43,50,41,59,87,45,33,85,24,5,7,77,21,71,58,49,17,32,83,12,84,55,30,56,99,78,52,10,75,28,14,6,40,86,67,34,38,81,39,26,47];
%S0 = [6,15,24,27,41,9,4,19,1,18,37,34,29,10,38,7,12,48,30,11,32,14,2,13,8,45,28,39,43,23,33,31,21,44,36,46,16,25,40,47,50,17,26,3,42,22,20,49,5,35];
%S0 = [26,24,40,22,12,2,17,31,10,28,30,27,25,35,20,14,11,39,29,15,4,9,37,8,23,5,7,1,16,13,3,36,18,38,32,19,21,6,33,34];
S0 = [26,24,40,22,12,2,17,31,10,28,30,27,25,35,20,14,11,39,29,15,4,9,37,8,23,5,7,1,16,13,3,36,18,38,32,19,21,6,33,34];
%S0   = randperm(N);                    % solução inicial aleatória
% Cálculo da função objetivo
Lin  = 1:N;                            % vetor auxiliar
IDS  = Lin - S0;                       % ataques diagonais secundárias
IDP  = Lin + S0;                       % ataques diagonais principais
fS0  = 2*N - length(unique(IDS)) - length(unique(IDP)); % valor da fo - calcula NA
% Usar duas funções objetivo: número de ataques e função objetivo incremental
% Esta fo não considera ataques entre rainhas nas diagonais: usar laço for
% Considerar apenas um método de cômputo de ataques - tabela aula errada
Sinc = S0;                             % solução incumbente
finc = fS0;                            % valor da solução incumbente
Sk   = S0;                             % solução inicial da iteração
fSk  = finc;                           % valor da iteração k
write_data(k,Sk,fSk,Sinc,finc,N,1)       % exibe solução no command window
% Processo iterativo
for k = 0:kmax
    % Passo 2
    % Geração de vizinhos por permuta entre linhas
    kk = 1;                            % contador de vizinhos
    for k1 = 1:N-1
        for k2 = k1+1:N
            Sj        = Sk;            % vizinho Sj
            Sj(k1)    = Sk(k2);        % alterna posicao k1 == k2
            Sj(k2)    = Sk(k1);        % alterna posicao k2 == k1
            IDS       = Lin - Sj;      % ataques diagonais secundárias
            IDP       = Lin + Sj;      % ataques diagonais principais
            fSj(kk,1) = 2*N - length(unique(IDS)) - length(unique(IDP)); % valor da fo - calcula NA
            %mov(k1,k2)= kk;            % movimento que deu origem a Sj
            Smj(kk,:) = [Sj fSj(kk,1) k1 k2];% matriz de soluções e fo
            kk        = kk + 1;        % incrementa contador de vizinhos
        end
    end
    
    % Passo 3
    % Verificar se não é tabu e atualizar incumbente
    [ii, jj] = sort(fSj);              % vetores ordenados de NA e posições
    for i = 1:Nviz
        % Passo 4
        if fSj(jj(i),1) < finc         % critério de aspiração
            Sk   = Smj(jj(i),1:N);     % atualiza solução corrente
            fSk  = Smj(jj(i),N+1);     % atualiza valor da solução corrente
            Sinc = Sk;                 % solução incumbente
            finc = fSk;                % valor da solução incumbente
            % Passo 5
            k    = k + 1;              % atualiza contador k
            write_data(k,Sk,fSk,Sinc,finc,N,0); % exibe solução no command window
            % Passo 6
            D    = randi([Dmin Dmax]); % gera duração aleatória do tabu
            T(Smj(jj(i),end-1),Smj(jj(i),end)) = k + D; % preenche tabu
            break                      % sai fora do laco for
        end
        % Entra quando não é tabu
        if (T(Smj(jj(i),end-1),Smj(jj(i),end)) == 0) || (k > T(Smj(jj(i),end-1),Smj(jj(i),end)))
            Sk   = Smj(jj(i),1:N);     % atualiza solução corrente
            fSk  = Smj(jj(i),N+1);     % atualiza valor da solução corrente
            % Passo 5
            k    = k + 1;              % atualiza contador k
            write_data(k,Sk,fSk,Sinc,finc,N,0); % exibe solução no command window
            % Passo 6
            D    = randi([Dmin Dmax]); % gera duração aleatória do tabu
            T(Smj(jj(i),end-1),Smj(jj(i),end)) = k + D; % preenche tabu
            break                      % sai fora do laco for
        end
    end
    % Critério de parada
    if fSk == 0
        %soma = soma + k;
        fprintf('\n')
        break
    end
end
%end

% Gerar outros tipos de vizinhança
% 1) apenas rainhas em ataque
% 2) até encontrar um solução melhor