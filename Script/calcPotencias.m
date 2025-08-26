function [pCalc, qCalc] = calcPotencias(V, ang, Ybus, indexP, indexQ)
    nb = length(V);
    pCalc = zeros(nb, 1);
    qCalc = zeros(nb, 1);

    % Calcula somente para as barras que importam
    for k = indexP(:)'  % P para PV + PQ
        for m = 1:nb
            Y = Ybus(k, m);
            theta = ang(k) - ang(m);
            G = real(Y);
            B = imag(Y);
            pCalc(k) = pCalc(k) + V(k)*V(m)*(G*cos(theta) + B*sin(theta));
        end
    end

    for k = indexQ(:)'  % Q só para PQ
        for m = 1:nb
            Y = Ybus(k, m);
            theta = ang(k) - ang(m);
            G = real(Y);
            B = imag(Y);
            qCalc(k) = qCalc(k) + V(k)*V(m)*(G*sin(theta) - B*cos(theta));
        end
    end
 %disp('P calculado:');
 %disp(pCalc);
 %disp('Q calculado:');
 %disp(qCalc);
end
