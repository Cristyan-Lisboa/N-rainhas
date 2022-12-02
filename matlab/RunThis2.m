%% Trabalho de Otimização Heurística 2 - 23NOV22
% Cristyan Lisbôa
% Problema de N-rainhas
% Objetivo: Dispor n-rainhas em um tabuleiro de nXn tal que não ocorram ataques
%% Parâmetros do método
%clearvars -except corrente1
clear all, close all; clc              % limpa variáveis, console e fecha figuras
%figure(2), hold on
%soma = 0;
%for l = 1:100
N    = 40;                             % número de rainhas
kmax = 500;                            % número máximo de iterações
Nviz = N*(N-1)/2;                      % número de vizinhos por permutação entre duas linhas
Vi   = zeros(Nviz,1);                  % armazena vizinhos
Vj   = Vi;                             % armazena vizinhos
fSj  = Vi;                             % valor da fo
%Smj  = zeros(Nviz,N+3);                % matriz de soluções e fo

% Passo 1
k    = 0;                              % contador de iterações
T    = zeros(N,N);                     % matriz dos tabus
Dmin = 5;                              % duração mínima dos tabus
Dmax = 2*Dmin;                         % duração máxima dos tabus
%S0   = [5 4 3 6 7 1 2];                % solução inicial fixa
tipo_viz = 1;                          % 1 - todos, 2 - até o melhor
alpha = 0.9;                           % fator de relaxação do critério de aspiração entre
cont_finc = 0;                         % contador da solução incumbente
max_cont_finc = 5;                     % número de movimentos
movimentos_alterados = 3;              % número de momentos alerados na diversificação
S0   = randperm(N);                    % solução inicial aleatória
%S0 = [5,51,27,48,53,21,41,57,34,44,38,30,33,3,13,32,4,45,68,17,25,69,31,6,11,8,40,63,35,2,55,22,58,36,50,26,10,70,20,18,54,66,64,67,7,12,39,42,49,52,1,46,65,59,16,56,61,24,29,43,23,28,60,14,9,15,37,47,19,62];
%S0   = [2,10,18,5,17,11,4,6,14,21,19,16,12,3,13,9,8,15,7,20,1];
%S0   = [14,11,13,10,18,4,19,2,20,7,15,6,9,17,8,5,16,1,21,3,12];
%S0 = [14,19,7,3,16,15,20,2,9,12,21,11,13,8,6,1,5,4,18,17,10];
%S0 = [72,63,3,88,36,79,98,29,37,48,25,73,27,100,42,11,8,62,20,91,65,18,35,90,57,94,46,64,70,93,66,19,97,89,4,92,96,9,1,80,53,76,51,61,44,54,2,13,95,16,15,82,31,69,68,22,60,23,74,43,50,41,59,87,45,33,85,24,5,7,77,21,71,58,49,17,32,83,12,84,55,30,56,99,78,52,10,75,28,14,6,40,86,67,34,38,81,39,26,47];
S0 = [26,24,40,22,12,2,17,31,10,28,30,27,25,35,20,14,11,39,29,15,4,9,37,8,23,5,7,1,16,13,3,36,18,38,32,19,21,6,33,34];
%S0 = [20,8,21,40,48,22,13,28,29,14,26,50,47,36,4,31,10,41,46,42,7,16,15,6,34,44,11,30,32,25,43,5,2,27,1,19,37,35,12,33,49,9,3,45,23,18,39,17,24,38];
%for i = 1:N
%    S0(1,i) = i;                       % solução inicial com + ataques
%end
% Cálculo da função objetivo
Lin  = 1:N;                            % vetor auxiliar
IDS  = Lin - S0;                       % ataques diagonais secundárias
IDP  = Lin + S0;                       % ataques diagonais principais
fS0  = objective(N,IDS,IDP,0,1);       % função objetivo da aula
fS0  = objective(N,IDS,IDP,fS0,2);     % função objetivo calcula diagonal
l = 1; corrente = fS0;
Sinc = S0;                             % solução incumbente
finc = fS0;                            % valor da solução incumbente
Sk   = S0;                             % solução inicial da iteração
fSk  = finc;                           % valor da iteração k
write_data(k,Sk,fSk,Sinc,finc,N,1)     % exibe solução no command window
% Processo iterativo
for k = 0:kmax
    % Passo 2
    clearvars Sj fSj Smj Vi Vj IDS IDP ii jj
    [Sj,fSj,~,Vi,Vj,~,~] = neighbor(Sk,N,Lin,finc,tipo_viz); % geração dos vizinhos
    % Passo 3
    % Verificar se não é tabu e atualizar incumbente
    [ii, jj] = sort(fSj);              % vetores ordenados de NA e posições
    for i = 1:Nviz
        ki = Vi(jj(i));                % índice i da melhor solução
        kj = Vj(jj(i));                % índice j da melhor solução
        % Passo 4
        if fSj(jj(i),1) < finc         % critério de aspiração por objetivo
            Sj        = Sk;            % vizinho Sj
            Sj(ki)    = Sk(kj);        % alterna posicao k1 == k2
            Sj(kj)    = Sk(ki);        % alterna posicao k2 == k1
            Sk        = Sj;            % troca a solução corrente
            fSk = fSj(jj(i),1);        % atualiza valor da solução corrente
            l = l + 1; corrente(l) = fSk;
            Sinc = Sk;                 % solução incumbente
            finc = fSk;                % valor da solução incumbente
            cont_finc = 1;             % contador da solução incumbente
            % Passo 5
            k    = k + 1;              % atualiza contador k
            write_data(k,Sk,fSk,Sinc,finc,N,0); % exibe solução no command window
            % Passo 6
            D    = randi([Dmin Dmax]); % gera duração aleatória do tabu
            T(ki,kj) = k + D;          % preenche tabu
            T(kj,ki) = T(kj,ki) + 1;   % quantas vezes
            break                      % sai fora do laco for
        end
        % Entra quando não é tabu
        if (T(ki,kj) == 0) || (k > T(ki,kj)) %|| (fSj(jj(i),1)*alpha <= finc) % Verifica lista tabu 
            if fSj(jj(i),1) == 1
                cont_finc = cont_finc + 1; % atualiza contador finc
            end
            if cont_finc <= max_cont_finc
                Sj        = Sk;            % vizinho Sj
                Sj(ki)    = Sk(kj);        % alterna posicao k1 == k2
                Sj(kj)    = Sk(ki);        % alterna posicao k2 == k1
                Sk        = Sj;
                fSk = fSj(jj(i),1);        % atualiza valor da solução corrente
                l = l + 1; corrente(l) = fSk;
                % Passo 5
                k    = k + 1;              % atualiza contador k
                write_data(k,Sk,fSk,Sinc,finc,N,0); % exibe solução no command window
                % Passo 6
                D    = randi([Dmin Dmax]); % gera duração aleatória do tabu
                T(ki,kj) = k + D;          % preenche tabu
                T(kj,ki) = T(kj,ki) + 1;   % quantas vezes
                break                      % sai fora do laco for
            else                           % Critério de diversificação
                [linhas,colunas] = find(T==0); % Vizinhos não visitados
                cont_aux = 1;
                for ind = 1:length(linhas)
                    if linhas(ind) > colunas(ind)
                        indices(cont_aux,1:2) = [linhas(ind) colunas(ind)];
                        cont_aux = cont_aux + 1;
                    end
                end
                vetor = setdiff(randperm(length(indices)),1,'stable');
                for iii = 1:movimentos_alterados
                    ki = indices(vetor(iii),1);                
                    kj = indices(vetor(iii),2);
                    Sj        = Sk;            % vizinho Sj
                    Sj(ki)    = Sk(kj);        % alterna posicao k1 == k2
                    Sj(kj)    = Sk(ki);        % alterna posicao k2 == k1
                    Sk        = Sj;            % atualiza solucao corrente
                    IDS  = Lin - Sk;           % ataques diagonais secundárias
                    IDP  = Lin + Sk;           % ataques diagonais principais
                    fSk  = objective(N,IDS,IDP,0,1); % atualiza valor da solução corrente
                    fSk  = objective(N,IDS,IDP,fSk,2);
                    % Passo 6
                    D    = randi([Dmin Dmax]); % gera duração aleatória do tabu
                    T(kj,ki) = k + D;          % preenche tabu
                    T(ki,kj) = T(ki,kj) + 1;   % quantas vezes
                end
                % Passo 5
                k    = k + 1;              % atualiza contador k
                write_data(k,Sk,fSk,Sinc,finc,N,0); % exibe solução no command window
                cont_finc = 0;
                l = l + 1; corrente(l) = fSk;
                max_cont_finc = max_cont_finc + 3;
                clearvars linhas colunas indices vetor
                break
            end
        end
    end
    % Critério de parada
    if fSk == 0 || k == kmax
        %soma = soma + k;
        write_data(k,Sk,fSk,Sinc,finc,N,2); % exibe solução no command window
        write_data(k,Sk,fSk,Sinc,finc,N,3); % exibe solução no command window
        clearvars ii jj fSj fSk finc Smj Vi Vj tipo_viz Sk Sj Sinc Lin IDP IDS Dmax Dmin
        break
    end
end
%plot([0:length(corrente)-1],corrente,'Color',0.8*[1 1 1],'LineWidth',3);
%clearvars corrente
%end
%% Gráfico corrente
figure(1)
plot([0:length(corrente2)-1],corrente2,'r','LineWidth',3);
hold on
plot([0:length(corrente1)-1],corrente1,'k','LineWidth',3);
hold off
xlabel('Iterações')
ylabel('Função objetivo')
legend({'$T_v = 1$','$T_v = 2$'},'Interpreter','latex','Location','northeast','FontSize',26);

set(gca,'FontName','Arial')
set(gca,'FontSize',22)
xlim([0,110])
ylim([0,800])
%box('on')