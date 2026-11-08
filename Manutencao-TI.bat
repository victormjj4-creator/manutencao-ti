@echo off
setlocal
:: =====================================================================
::  MANUTENCAO TI - Inicializador (dois cliques)
::  - Pede permissao de Administrador (UAC) se precisar
::  - Abre o menu do Manutencao-TI.ps1, que deve estar NA MESMA PASTA
::  - Funciona a partir do disco local, pendrive ou pasta de rede
::
::  Para usar sem menu (automacao), chame o .ps1 direto:
::    powershell -NoProfile -ExecutionPolicy Bypass -File Manutencao-TI.ps1 -Opcao 19
:: =====================================================================
title Manutencao TI

set "PS1=%~dp0Manutencao-TI.ps1"
if not exist "%PS1%" (
    echo.
    echo  ERRO: o arquivo Manutencao-TI.ps1 nao foi encontrado em:
    echo        %~dp0
    echo  Coloque o .bat e o .ps1 na mesma pasta.
    echo.
    pause
    exit /b 1
)

:: Verifica se ja esta como Administrador
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permissao de administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs" >nul 2>&1
    if errorlevel 1 (
        echo.
        echo  Permissao negada. Clique com o botao direito no arquivo e escolha
        echo  "Executar como administrador".
        echo.
        pause
    )
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" %*
exit /b %errorlevel%
