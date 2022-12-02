function [fS0] = objective(N,IDS,IDP,fS0,tipo)
    if tipo == 1
        fS0  = 2*N - length(unique(IDS)) - length(unique(IDP)); % valor da fo - calcula NA
    end
    if tipo == 2
        kkk  = 1;
        for i = 1-N:N-1
            if length(find(IDS == i)) >= 3
                Nb(1,kkk) = length(find(IDS == i));
                fS0 = fS0 + factorial(Nb(1,kkk))/(factorial(Nb(1,kkk)-2)*factorial(2)) - (Nb(1,kkk) - 1);
                kkk = kkk + 1;
            end
        end
        for i = 2:2*N
            if length(find(IDP == i)) >= 3
                Nb(1,kkk) = length(find(IDP == i));
                fS0 = fS0 + factorial(Nb(1,kkk))/(factorial(Nb(1,kkk)-2)*factorial(2)) - (Nb(1,kkk) - 1);
                kkk = kkk + 1;
            end
        end
    end
end