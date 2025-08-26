function barras_resultado = subsistema_2(barras_convergido, barras, Ybus)
    % Tipos de barras
    SW = 1; PV = 2; PQ = 3;

    % Número de barras
    nb = size(barras_convergido, 1);

    % Tipos de cada barra
    tipo = barras_convergido(:, 2);

    % Índices
    indexSlack = find(tipo == SW);
    indexPV = find(tipo == PV);
    indexPQ = find(tipo == PQ);

    % Tensão e ângulo
    V = barras_convergido(:, 3);
    ang = barras_convergido(:, 4);

    % Calcula potências complexas S = V * conj(I) para TODAS as barras
    [Pcalc, Qcalc] = calcPotenciasSub2(V, ang, Ybus);

    % Cria uma cópia da matriz convergida
    barras_resultado = barras_convergido;

    % Atualiza valores calculados APENAS nas barras SW e PV
    barras_resultado(indexSlack, 5) = Pcalc(indexSlack); % Pgerado SW
    barras_resultado(indexSlack, 6) = Qcalc(indexSlack); % Qgerado SW
    barras_resultado(indexPV, 5)    = Pcalc(indexPV);    % Pgerado PV
    barras_resultado(indexPV, 6)    = Qcalc(indexPV);    % Qgerado PV

    % Restaura os valores originais de P e Q nas barras PQ
    barras_resultado(indexPQ, 5) = barras(indexPQ, 5); % P original
    barras_resultado(indexPQ, 6) = barras(indexPQ, 6); % Q original
    
    % Converte ângulo de radianos para graus e as potencias de PU pra MW e MVAr
    barras_resultado(:, 4) = rad2deg(barras_resultado(:, 4));
    barras_resultado(:, 5:9) = barras_resultado(:, 5:9) * 100;
end
