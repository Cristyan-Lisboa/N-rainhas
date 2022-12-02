%% Trabalho de Otimiza��o Heur�stica 2 - 02NOV22
% Cristyan Lisb�a e Ederson Machado
% Problema de N-rainhas
% Objetivo: Dispor n-rainhas em um tabuleiro de nXn tal que n�o ocorram
% ataques
%% Par�metros do m�todo
clearvars, close all; clc              % limpa vari�veis, console e fecha figuras
%soma = 0;
%for l = 1:100
N    = 40;                              % n�mero de rainhas
kmax = 50;                             % n�mero m�ximo de itera��es
Nviz = N*(N-1)/2;                      % n�mero de vizinhos por permuta��o entre duas linhas
Vi   = zeros(Nviz,1);                  % armazena vizinhos
Vj   = Vi;                             % armazena vizinhos
NA   = Vi;                             % n�mero de ataques
fSj  = Vi;                             % valor da fo
Smj  = zeros(Nviz,N+3);                % matriz de solu��es e fo

% Passo 1
k    = 0;                              % contador de itera��es
T    = zeros(N,N);                     % matriz dos tabus
%mov  = zeros(N,N);                     % matriz dos movimentos
Dmin = 5;                              % dura��o m�nima dos tabus
Dmax = 2*Dmin;                         % dura��o m�xima dos tabus
%S0   = [4 5 3 6 7 1 2];                % solu��o inicial fixa
%S0 = [14,11,13,10,18,4,19,2,20,7,15,6,9,17,8,5,16,1,21,3,12];
%S0 = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21];
%S0 = [72,63,3,88,36,79,98,29,37,48,25,73,27,100,42,11,8,62,20,91,65,18,35,90,57,94,46,64,70,93,66,19,97,89,4,92,96,9,1,80,53,76,51,61,44,54,2,13,95,16,15,82,31,69,68,22,60,23,74,43,50,41,59,87,45,33,85,24,5,7,77,21,71,58,49,17,32,83,12,84,55,30,56,99,78,52,10,75,28,14,6,40,86,67,34,38,81,39,26,47];
%S0 = [6,15,24,27,41,9,4,19,1,18,37,34,29,10,38,7,12,48,30,11,32,14,2,13,8,45,28,39,43,23,33,31,21,44,36,46,16,25,40,47,50,17,26,3,42,22,20,49,5,35];
%S0 = [26,24,40,22,12,2,17,31,10,28,30,27,25,35,20,14,11,39,29,15,4,9,37,8,23,5,7,1,16,13,3,36,18,38,32,19,21,6,33,34];
S0 = [26,24,40,22,12,2,17,31,10,28,30,27,25,35,20,14,11,39,29,15,4,9,37,8,23,5,7,1,16,13,3,36,18,38,32,19,21,6,33,34];
%S0   = randperm(N);                    % solu��o inicial aleat�ria
% C�lculo da fun��o objetivo
Lin  = 1:N;                            % vetor auxiliar
IDS  = Lin - S0;                       % ataques diagonais secund�rias
IDP  = Lin + S0;                       % ataques diagonais principais
fS0  = 2*N - length(unique(IDS)) - length(unique(IDP)); % valor da fo - calcula NA
% Usar duas fun��es objetivo: n�mero de ataques e fun��o objetivo incremental
% Esta fo n�o considera ataques entre rainhas nas diagonais: usar la�o for
% Considerar apenas um m�todo de c�mputo de ataques - tabela aula errada
Sinc = S0;                             % solu��o incumbente
finc = fS0;                            % valor da solu��o incumbente
Sk   = S0;                             % solu��o inicial da itera��o
fSk  = finc;                           % valor da itera��o k
write_data(k,Sk,fSk,Sinc,finc,N,1)       % exibe solu��o no command window
% Processo iterativo
for k = 0:kmax
    % Passo 2
    % Gera��o de vizinhos por permuta entre linhas
    kk = 1;                            % contador de vizinhos
    for k1 = 1:N-1
        for k2 = k1+1:N
            Sj        = Sk;            % vizinho Sj
            Sj(k1)    = Sk(k2);        % alterna posicao k1 == k2
            Sj(k2)    = Sk(k1);        % alterna posicao k2 == k1
            IDS       = Lin - Sj;      % ataques diagonais secund�rias
            IDP       = Lin + Sj;      % ataques diagonais principais
            fSj(kk,1) = 2*N - length(unique(IDS)) - length(unique(IDP)); % valor da fo - calcula NA
            %mov(k1,k2)= kk;            % movimento que deu origem a Sj
            Smj(kk,:) = [Sj fSj(kk,1) k1 k2];% matriz de solu��es e fo
            kk        = kk + 1;        % incrementa contador de vizinhos
        end
    end
    
    % Passo 3
    % Verificar se n�o � tabu e atualizar incumbente
    [ii, jj] = sort(fSj);              % vetores ordenados de NA e posi��es
    for i = 1:Nviz
        % Passo 4
        if fSj(jj(i),1) < finc         % crit�rio de aspira��o
            Sk   = Smj(jj(i),1:N);     % atualiza solu��o corrente
            fSk  = Smj(jj(i),N+1);     % atualiza valor da solu��o corrente
            Sinc = Sk;                 % solu��o incumbente
            finc = fSk;                % valor da solu��o incumbente
            % Passo 5
            k    = k + 1;              % atualiza contador k
            write_data(k,Sk,fSk,Sinc,finc,N,0); % exibe solu��o no command window
            % Passo 6
            D    = randi([Dmin Dmax]); % gera dura��o aleat�ria do tabu
            T(Smj(jj(i),end-1),Smj(jj(i),end)) = k + D; % preenche tabu
            break                      % sai fora do laco for
        end
        % Entra quando n�o � tabu
        if (T(Smj(jj(i),end-1),Smj(jj(i),end)) == 0) || (k > T(Smj(jj(i),end-1),Smj(jj(i),end)))
            Sk   = Smj(jj(i),1:N);     % atualiza solu��o corrente
            fSk  = Smj(jj(i),N+1);     % atualiza valor da solu��o corrente
            % Passo 5
            k    = k + 1;              % atualiza contador k
            write_data(k,Sk,fSk,Sinc,finc,N,0); % exibe solu��o no command window
            % Passo 6
            D    = randi([Dmin Dmax]); % gera dura��o aleat�ria do tabu
            T(Smj(jj(i),end-1),Smj(jj(i),end)) = k + D; % preenche tabu
            break                      % sai fora do laco for
        end
    end
    % Crit�rio de parada
    if fSk == 0
        %soma = soma + k;
        fprintf('\n')
        break
    end
end
%end

% Gerar outros tipos de vizinhan�a
% 1) apenas rainhas em ataque
% 2) at� encontrar um solu��o melhor