%Jo�o Pedro Mendes Leroy
%Lucas Allex Carvalho de Oliveira
clc
clear
tic;  % Inicia a contagem de tempo
%% Toler�ncia e N�mero de intera��es
   tol = 1e-5;
   maxIter = 20;

%% Leitura dos Dados
[matriz_barras, matriz_linhas] = LerDadosPWF('DadosAnarede.pwf');

%% Montar Ybus e criar Matriz de Barra
[Ybus, matriz_barra_PU, barras] = MontarYbus(matriz_linhas, matriz_barras);% Monta a matriz Ybus

%% Subsistema 1
barras_convergido = fluxo_potencia_NR(barras, Ybus, tol, maxIter);

%% Subsistema 2
barras_resultado = subsistema_2(barras_convergido, barras, Ybus);

%% Contagem de tempo
tempo_total = toc;  % Finaliza a contagem e retorna o tempo em segundos
fprintf('Tempo de execu��o: %.4f segundos\n', tempo_total);
