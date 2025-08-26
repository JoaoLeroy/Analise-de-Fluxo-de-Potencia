function [Ybus, matriz_barra_PU, barras] = MontarYbus(matriz_linhas, matriz_barras)
    % Converte R e X de % para PU (base de 100 MVA assumida)
    linhas = matriz_linhas;
    linhas(:,3:4) = linhas(:,3:4) / 100;  % Converte de porcentagem para PU direto

    % Determina o número total de barras
    barras_de_linhas = unique([linhas(:,1); linhas(:,2)]);
    barras_de_barras = unique(matriz_barras(:,1));
    todas_barras = unique([barras_de_linhas; barras_de_barras]);
    n_barras = max(todas_barras);

    % Inicializa Ybus
    Ybus = zeros(n_barras, n_barras);

    % Montagem da Ybus
    for k = 1:size(linhas, 1)
        de = linhas(k,1);
        para = linhas(k,2);
        R = linhas(k,3);
        X = linhas(k,4);

        if R == 0 && X == 0
            continue;
        end

        Z = R + 1i * X;
        Y = 1 / Z;

        Ybus(de, de) = Ybus(de, de) + Y;
        Ybus(para, para) = Ybus(para, para) + Y;
        Ybus(de, para) = Ybus(de, para) - Y;
        Ybus(para, de) = Ybus(para, de) - Y;
    end

    % Converte potências da matriz de barras para PU (base 100 MVA)
    matriz_barra_PU = matriz_barras;
    matriz_barra_PU(:, 5:9) = matriz_barra_PU(:, 5:9) / 100;
    barras = matriz_barra_PU;
end

