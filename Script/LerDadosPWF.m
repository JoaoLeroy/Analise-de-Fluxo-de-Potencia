function [matriz_barras, matriz_linhas] = LerDadosPWF(nome_arquivo)

fid = fopen(nome_arquivo, 'r');
if fid == -1
    error('Arquivo não encontrado!');
end

matriz_barras = [];
matriz_linhas = [];
secao_atual = '';

getCampoSeguro = @(linha, i, j) ...
    str2double(strtrim(extractBetween(pad(linha, j), i, j)));

while ~feof(fid)
    linha = fgetl(fid);
    if isempty(linha), continue; end

    if contains(linha, 'DBAR')
        secao_atual = 'BARRAS';
        continue;
    elseif contains(linha, 'Dlin')
        secao_atual = 'LINHAS';
        continue;
            elseif contains(linha, 'DLIN')
        secao_atual = 'LINHAS';
        continue;
    elseif contains(linha, 'FIM') || strcmp(strtrim(linha), '99999')
        secao_atual = '';
        continue;
    end

    if contains(linha, 'titu') || contains(linha, 'exlf') || contains(linha, 'rela')
        continue;
    end

    switch secao_atual
        case 'BARRAS'
            num_barra   = getCampoSeguro(linha, 1, 6);
            tipo_barra  = getCampoSeguro(linha, 8, 9);
            tensao      = getCampoSeguro(linha, 25, 29);
            angulo      = getCampoSeguro(linha, 30, 32);
            Pg          = getCampoSeguro(linha, 33, 37);
            Qg          = getCampoSeguro(linha, 38, 42);
            Pl          = getCampoSeguro(linha, 59, 63);
            Ql          = getCampoSeguro(linha, 64, 68);
            Qsh         = getCampoSeguro(linha, 69, 73);
            
            angulo = deg2rad(angulo);
            dados_barra = [num_barra, tipo_barra, tensao, angulo, Pg, Qg, Pl, Ql, Qsh];
            dados_barra(isnan(dados_barra) | dados_barra == -999999999) = 0;

            if any(dados_barra ~= 0)
                matriz_barras = [matriz_barras; dados_barra];
            end

        case 'LINHAS'
            de   = getCampoSeguro(linha, 1, 5);
            para = getCampoSeguro(linha, 11, 15);
            R    = getCampoSeguro(linha, 21, 26);
            X    = getCampoSeguro(linha, 27, 33);

            dados_linha = [de, para, R, X];
            dados_linha(isnan(dados_linha) | dados_linha == -999999999) = 0;

            if any(dados_linha ~= 0)
                matriz_linhas = [matriz_linhas; dados_linha];
            end
    end
end

fclose(fid);
end
