function J = montarJacobiano(V, ang, Ybus, p, q, indexPVPQ, indexPQ)

    npv = length(indexPVPQ);
    npq = length(indexPQ);
    n = npv + npq;

    J = zeros(n, n);

    % Submatriz H (?P/??)
    for a = 1:npv
        k = indexPVPQ(a);
        for b = 1:npv
            m = indexPVPQ(b);
            if k == m
                soma = 0;
                for m2 = 1:length(V)
                    if m2 ~= k
                        Y = Ybus(k, m2);
                        G = real(Y); B = imag(Y);
                        theta = ang(k) - ang(m2);
                        soma = soma + V(k)*V(m2)*(G*sin(theta) - B*cos(theta));
                    end
                end
                J(a,b) = -soma;
            else
                Y = Ybus(k, m);
                G = real(Y); B = imag(Y);
                theta = ang(k) - ang(m);
                J(a,b) = V(k)*V(m)*(G*sin(theta) - B*cos(theta));
            end
        end

        % Submatriz N (?P/?V)
        for b = 1:npq
            m = indexPQ(b);
            if k == m
                J(a,npv+b) = (p(k) + V(k)^2 * real(Ybus(k,k))) / V(k);
            else
                Y = Ybus(k, m);
                G = real(Y); B = imag(Y);
                theta = ang(k) - ang(m);
                J(a,npv+b) = V(k)*(G*cos(theta) + B*sin(theta));
            end
        end
    end

    % Submatriz M (?Q/??) e L (?Q/?V)
    for a = 1:npq
        k = indexPQ(a);
        row = npv + a;

        % M: ?Q/??
        for b = 1:npv
            m = indexPVPQ(b);
            if k == m
                soma = 0;
                for m2 = 1:length(V)
                    if m2 ~= k
                        Y = Ybus(k, m2);
                        G = real(Y); B = imag(Y);
                        theta = ang(k) - ang(m2);
                        soma = soma + V(k)*V(m2)*(G*cos(theta) + B*sin(theta));
                    end
                end
                J(row,b) = -soma;
            else
                Y = Ybus(k, m);
                G = real(Y); B = imag(Y);
                theta = ang(k) - ang(m);
                J(row,b) = -V(k)*V(m)*(G*cos(theta) + B*sin(theta));  % << Corrigido
            end
        end

        % L: ?Q/?V
        for b = 1:npq
            m = indexPQ(b);
            if k == m
                J(row,npv+b) = (q(k) - V(k)^2 * imag(Ybus(k,k))) / V(k);
            else
                Y = Ybus(k, m);
                G = real(Y); B = imag(Y);
                theta = ang(k) - ang(m);
                J(row,npv+b) = V(k)*(G*sin(theta) - B*cos(theta));
            end
        end
    end
end
