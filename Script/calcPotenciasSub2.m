function [P, Q] = calcPotenciasSub2(V, ang, Ybus)
    nb = length(V);
    S = zeros(nb,1);
    for k = 1:nb
        Vk = V(k) * exp(1j * ang(k));
        Ik = Ybus(k,:) * (V .* exp(1j * ang));
        S(k) = Vk * conj(Ik); % Potência aparente S = V * conj(I)
    end
    P = real(S);
    Q = -imag(S); % Sinal negativo pois é potência gerada
end
