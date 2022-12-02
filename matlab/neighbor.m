function [Sj,fSj,Smj,Vi,Vj,IDS,IDP] = neighbor(Sk,N,Lin,finc,tipo)
    kk = 1;                                % contador de vizinhos
    if tipo == 1
        % Geração de vizinhos por permuta entre linhas
        for k1 = 1:N-1
            for k2 = k1+1:N
                Vi(kk) = k1;
                Vj(kk) = k2;
                Sj        = Sk;            % vizinho Sj
                Sj(k1)    = Sk(k2);        % alterna posicao k1 == k2
                Sj(k2)    = Sk(k1);        % alterna posicao k2 == k1
                IDS       = Lin - Sj;      % ataques diagonais secundárias
                IDP       = Lin + Sj;      % ataques diagonais principais
                fSj(kk,1) = objective(N,IDS,IDP,0,1);
                fSj(kk,1) = objective(N,IDS,IDP,fSj(kk,1),2);
                Smj(kk,:) = [Sj fSj(kk,1) k1 k2];% matriz de soluções e fo
                kk        = kk + 1;        % incrementa contador de vizinhos
            end
        end
    end

    if tipo == 2
        % Geração de vizinhos por permuta entre linhas até encontrar um melhor
        k1 = 1;
        k2 = k1 + 1;
        while k1 <= N-1
            while k2 <= N
                Vi(kk) = k1;
                Vj(kk) = k2;
                Sj        = Sk;            % vizinho Sj
                Sj(k1)    = Sk(k2);        % alterna posicao k1 == k2
                Sj(k2)    = Sk(k1);        % alterna posicao k2 == k1
                IDS       = Lin - Sj;      % ataques diagonais secundárias
                IDP       = Lin + Sj;      % ataques diagonais principais
                fSj(kk,1) = objective(N,IDS,IDP,0,1);
                fSj(kk,1) = objective(N,IDS,IDP,fSj(kk,1),2);
                Smj(kk,:) = [Sj fSj(kk,1) k1 k2]; % matriz de soluções e fo
                k2 = k2 + 1;
                if fSj(kk,1) < finc
                    %fSj = fSj(kk,1);
                    %Smj = Smj(kk,:);
                    k1 = N;
                    k2 = N+1;
                    break
                end
                kk        = kk + 1;        % incrementa contador de vizinhos
            end
            k1 = k1 + 1;
            k2 = k1 + 1;
        end
    end
end