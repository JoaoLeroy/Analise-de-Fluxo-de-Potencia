function barras = fluxo_potencia_NR(barras, Ybus, tol, maxIter)

    SW = 1; PV = 2; PQ = 3;
    nb = size(barras, 1);
    tipo = barras(:, 2);

    % Índices para construção do vetor g(x) e atualização
    indexSlack = find(tipo == SW);
    indexPVPQ = find(tipo == PV | tipo == PQ);
    indexPQ = find(tipo == PQ);

    for it = 1:maxIter
        V = barras(:, 3);
        ang = barras(:, 4);

        [pCalc, qCalc] = calcPotencias(V, ang, Ybus, indexPVPQ, indexPQ);


        % Potências especificadas (PG - PD e QG - QD)
        pSpec = barras(:, 5) - barras(:, 7);
        qSpec = barras(:, 6) - barras(:, 8) + barras(:, 9);

        % Mismatch vetorial (g(x))
        deltaP = pSpec(indexPVPQ) - pCalc(indexPVPQ);
        deltaQ = qSpec(indexPQ)   - qCalc(indexPQ);

        gX = [deltaP; deltaQ];

        % Critério de parada
        if norm(gX, inf) < tol
            fprintf('Convergiu em %d iterações.\n', it);

            % Atualizar apenas QG nas PV e PQ (onde ele é calculado)
            barras(indexPQ, 6) = qCalc(indexPQ);    % QG atualizado para PQ
            barras(indexPVPQ, 5) = pCalc(indexPVPQ); % PG atualizado apenas para visualização

            if ~isempty(find(tipo == PV, 1))
                indexPV = find(tipo == PV);
                barras(indexPV, 6) = qCalc(indexPV);  % QG atualizado para PV (que é calculado)
            end

            return
        end

        % Jacobiana e atualização
        J = montarJacobiano(V, ang, Ybus, pCalc, qCalc, indexPVPQ, indexPQ);
        J= -J;
        deltaX = - inv(J) * gX;

        % Atualização de ângulo (deltaX_?) e tensão (deltaX_V)
        barras(indexPVPQ, 4) = barras(indexPVPQ, 4) + deltaX(1:length(indexPVPQ));
        barras(indexPQ, 3)   = barras(indexPQ, 3)   + deltaX(length(indexPVPQ)+1:end);
 %disp('Matriz de barras:');
 %disp(barras);
    end

    error('Não convergiu após %d iterações.', maxIter);
end
