function write_data(k,Sk,fSk,Sinc,finc,N,tipo)
    if tipo == 1
        fprintf('%s','   ------------------------------------------------------------------------------------------------');
        fprintf('\n   %s               %s                  %s               %s                %s\n','Iteração','Solução','fo','Incumbente','fo');
        fprintf('%s','   ------------------------------------------------------------------------------------------------');
        fprintf('\n      %d       %s',k,string(Sk(1)))
        for i = 2:N
            fprintf('%s',string(Sk(i)))
        end
        fprintf('    %d    %s',fSk,string(Sinc(1)))
        for i = 2:N
            fprintf('%s',string(Sinc(i)))
        end
        fprintf('      %d',finc)
    end
    if tipo == 0
        fprintf('\n      %d       %s',k,string(Sk(1)))
        for j = 2:N
            fprintf('%s',string(Sk(j)))
        end
        fprintf('    %d    %s',fSk,string(Sinc(1)))
        for j = 2:N
            fprintf('%s',string(Sinc(j)))
        end
        fprintf('      %d',finc)
    end
    if tipo == 2
        fprintf('\n%s\n','   -------------------------------------------');
    end
    if tipo == 3
        fprintf('%s','   Solução: ');
        fprintf(' %d',Sinc);
        fprintf('      \n','');
    end
end