<#
=====================================================================
 MANUTENCAO TI - Painel de manutencao e diagnostico do Windows
 Versao 1.0
=====================================================================
 O QUE E:
   Menu com 27 ferramentas de manutencao e diagnostico para o dia a dia
   do suporte. Roda em qualquer Windows 10/11 (e na maioria das opcoes em
   Windows Server 2016+), SEM depender do Milvus ou de outro RMM.
   Tambem roda sem menu (modo automatico) para RMM, GPO, tarefa agendada,
   PsExec ou Invoke-Command.

 REQUISITOS:
   - Windows 10 ou 11 (Windows Server: quase todas as opcoes)
   - Windows PowerShell 5.1 (ja vem no Windows)
   - Executar como Administrador (o script verifica e pede elevacao;
     sem privilegio elevado ele NAO roda)
   - Internet para: Windows Update/DISM, winget, teste de velocidade,
     conectividade e download de arquivos

 ARQUIVOS:
   Manutencao-TI.ps1  -> o script (este arquivo)
   Manutencao-TI.bat  -> atalho de dois cliques (pede admin e abre o menu)
   Os dois precisam ficar NA MESMA PASTA.

 ---------------------------------------------------------------------
 COMO USAR - escolha a forma que preferir
 ---------------------------------------------------------------------
   1) DOIS CLIQUES (tecnico na frente da maquina)
      Copie os dois arquivos para a maquina, um pendrive ou uma pasta de
      rede (ex.: \\servidor\TI$\Scripts). De dois cliques em
      Manutencao-TI.bat, aceite o aviso do Windows (UAC) e escolha a opcao
      no menu numerico.

   2) POWERSHELL COMO ADMINISTRADOR
      powershell -NoProfile -ExecutionPolicy Bypass -File .\Manutencao-TI.ps1

   3) SEM MENU - AUTOMACAO (qualquer RMM, GPO de inicializacao, PsExec...)
      Informe a opcao com -Opcao. Nao faz perguntas: ja executa.
      Exemplos:
        powershell -NoProfile -ExecutionPolicy Bypass -File .\Manutencao-TI.ps1 -Opcao 19
        powershell -NoProfile -ExecutionPolicy Bypass -File .\Manutencao-TI.ps1 -Opcao 1 -Simulacao
        powershell -NoProfile -ExecutionPolicy Bypass -File .\Manutencao-TI.ps1 -Opcao 12 -Aplicar
        powershell -NoProfile -ExecutionPolicy Bypass -File .\Manutencao-TI.ps1 -Opcao 25 -Url https://site/arq.zip -Sha256 ABC123...
        powershell -NoProfile -ExecutionPolicy Bypass -File .\Manutencao-TI.ps1 -Opcao M6 -TodosUsuarios

   4) REMOTO, DE OUTRA MAQUINA (WinRM ativo + conta admin do dominio)
      Sempre informe a opcao (o menu nao funciona remotamente):
        Invoke-Command -ComputerName PC01, PC02 -FilePath .\Manutencao-TI.ps1 -ArgumentList '19'
      Com PsExec (roda como SYSTEM):
        psexec \\PC01 -s powershell -NoProfile -ExecutionPolicy Bypass -File \\servidor\TI$\Scripts\Manutencao-TI.ps1 -Opcao 14

   5) TAREFA AGENDADA (ex.: relatorio de disco toda segunda as 8h)
      Copie o .ps1 para C:\ProgramData\ManutencaoTI\ e rode como admin:
        schtasks /Create /TN "\Manutencao\Verificar Disco" /SC WEEKLY /D MON /ST 08:00 /RU SYSTEM /RL HIGHEST /TR "powershell -NoProfile -ExecutionPolicy Bypass -File C:\ProgramData\ManutencaoTI\Manutencao-TI.ps1 -Opcao 19"
      Para remover:  schtasks /Delete /TN "\Manutencao\Verificar Disco" /F

 ---------------------------------------------------------------------
 PARAMETROS (todos opcionais; sem -Opcao abre o menu)
 ---------------------------------------------------------------------
   -Opcao <n>       1 a 27, M1 a M6 (submenu de memoria) ou U
   -Simulacao       opcoes que apagam/alteram apenas mostram o que fariam
   -Aplicar         6: reinicia a maquina ao final
                    12: atualiza todos os programas via winget
                    15: agenda CHKDSK completo no proximo boot
   -TodosUsuarios   M2/M5: age em TODAS as sessoes (cuidado em TS/RDS)
                    M4: esvazia a Lixeira de todos os usuarios
   -Alvo <nome>     opcoes 10 (DNS) e 21 (conectividade). Padrao: google.com
   -Url, -Destino, -Sha256   opcao 25 (download)

 ---------------------------------------------------------------------
 OPCOES
 ---------------------------------------------------------------------
    1 Limpeza de arquivos temporarios        15 Executar CHKDSK no disco C:
    2 Limpeza de disco (cleanmgr)            16 Abrir PowerShell (admin)
    3 Verificar arquivos do sistema (SFC)    17 Ver configuracao IP (ipconfig)
    4 Reparar imagem do Windows (DISM)       18 Testar velocidade da internet
    5 Redefinir o Windows Update             19 Verificar espaco em disco
    6 Redefinir configuracoes de rede        20 Status do antivirus
    7 Atualizar politicas de grupo (GPO)     21 Testar conectividade com o Google
    8 Limpar logs de eventos                 22 Backup dos logs de eventos
    9 Informacoes do sistema (msinfo32)      23 Dispositivos USB conectados
   10 Consulta de DNS                        24 Uso de memoria e CPU
   11 Ver adaptadores de rede                25 Baixar arquivo via HTTPS
   12 Ver/atualizar programas (winget)       26 Relatorio de politicas (gpresult)
   13 Ver processos em execucao              27 Otimizador de Memoria (submenu)
   14 Status dos principais servicos          U Abrir repositorio (GitHub)

   Submenu 27 (Otimizador de Memoria) - no modo automatico use M1..M6:
    M1 Exibir uso de memoria (total / livre / usado)
    M2 Fechar processos pesados (Chrome, Edge, Firefox, Opera, Discord,
       Spotify, Teams, Steam, OneDrive)
    M3 Limpar arquivos temporarios
    M4 Esvaziar Lixeira
    M5 Reiniciar o Windows Explorer
    M6 Otimizacao completa (M2 a M5 em sequencia)

 ---------------------------------------------------------------------
 SEGURANCA
 ---------------------------------------------------------------------
   No menu, toda opcao que apaga ou altera algo mostra o que vai fazer e
   pede confirmacao S/N: 1, 2, 5, 6, 8, 12 (atualizar), 15 (agendar), M2-M6.
   NUNCA toca: Documentos, Downloads, Area de Trabalho, pastas de clientes,
   historico/senhas/cookies dos navegadores, bancos de sistemas contabeis.
   A Lixeira so e esvaziada nas opcoes M4/M6, com confirmacao.
   Opcao 5 renomeia (nao apaga) as pastas do Windows Update.
   Opcao 6 faz backup da configuracao de rede e NAO reseta o TCP/IP se
   houver IP fixo (servidores, impressoras, maquinas com IP manual).
   Opcao 8 so limpa os logs depois de fazer backup deles.

 LOG E RELATORIOS:  C:\ProgramData\ManutencaoTI\
   logs\        um log por execucao (mantem 30 dias)
   EventLogs\   backups dos logs de eventos (opcoes 8 e 22)
   Relatorios\  gpresult e msinfo32
   Backup\      backup da configuracao de rede (opcao 6)
   Downloads\   downloads quando rodando como SYSTEM (opcao 25)

 RODANDO COMO SYSTEM (RMM / tarefa agendada / psexec -s):
   - winget pode nao estar disponivel para a conta SYSTEM
   - Opcoes que abrem janela (16, U) nao abrem nada
   - M2 e M5 exigem -TodosUsuarios (SYSTEM nao tem sessao de usuario)
   - Codigo de saida: 0 = OK, 1 = houve erro (o RMM pode alertar)
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Opcao = '',
    [switch]$Simulacao,
    [switch]$Aplicar,
    [switch]$TodosUsuarios,
    [string]$Alvo = '',
    [string]$Url = '',
    [string]$Destino = '',
    [string]$Sha256 = ''
)

# ===================== CONFIGURACOES =====================
$UrlRepositorio     = 'PREENCHER'   # link do GitHub/repositorio dos scripts (opcao U)
$DiasMinimosTemp    = 1             # Temp: so apaga arquivos com mais de N dias
$DiasManterLogs     = 30            # rotacao dos logs deste script
$AlvoPadrao         = 'google.com'
$UrlTesteVelocidade = 'https://speed.cloudflare.com/__down?bytes=25000000'   # 25 MB
$SegundosMaxTeste   = 20
$ProcessosPesados   = @('chrome','msedge','firefox','opera','Discord','Spotify','Teams','ms-teams','steam','OneDrive')
$ServicosPrincipais = @('wuauserv','bits','CryptSvc','Spooler','Dnscache','Dhcp','LanmanWorkstation','LanmanServer',
                        'W32Time','WinDefend','mpssvc','BFE','EventLog','Schedule','Winmgmt','TermService','AudioSrv')
$LogsBackup         = @('Application','System','Security','Setup')
# =========================================================

$ErrorActionPreference = 'Continue'
$ProgressPreference    = 'SilentlyContinue'
$VersaoScript          = '1.0'
$script:Interativo     = [string]::IsNullOrWhiteSpace($Opcao)
$script:Avisos         = New-Object System.Collections.Generic.List[string]
$script:Erros          = New-Object System.Collections.Generic.List[string]
$script:JaConfirmado   = $false
$script:TotalBytes     = [long]0
$script:CodigoNativo   = 0
$script:ArquivoLog     = $null
$Pasta     = Join-Path $env:ProgramData 'ManutencaoTI'
$PastaLogs = Join-Path $Pasta 'logs'

try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }

# =====================================================================
#  FUNCOES DE APOIO
#  (nenhuma funcao que chama Log devolve valor: resultados ficam em $script:)
# =====================================================================
function Log([string]$msg, [string]$Cor = 'Gray') {
    if ($script:Interativo) { Write-Host $msg -ForegroundColor $Cor } else { Write-Output $msg }
    if ($script:ArquivoLog) {
        $linha = "[{0}] {1}" -f (Get-Date -Format 'HH:mm:ss'), $msg
        try { Add-Content -Path $script:ArquivoLog -Value $linha -Encoding UTF8 -ErrorAction Stop } catch { }
    }
}
function Ok([string]$m)    { Log "  [OK] $m" 'Green' }
function Info([string]$m)  { Log "  $m" 'Gray' }
function Aviso([string]$m) { $script:Avisos.Add($m); Log "  [AVISO] $m" 'Yellow' }
function Erro([string]$m)  { $script:Erros.Add($m);  Log "  [ERRO] $m" 'Red' }
function Titulo([string]$t) {
    Log ''
    Log ('=' * 70) 'Cyan'
    Log " $t" 'Cyan'
    Log ('=' * 70) 'Cyan'
    if ($Simulacao) { Log '  *** MODO SIMULACAO - nada sera alterado ***' 'DarkYellow' }
}
function Tabela($Dados) {
    if (-not $Dados) { Log '  (nada encontrado)' 'DarkGray'; return }
    Log (($Dados | Format-Table -AutoSize | Out-String -Width 250).TrimEnd()) 'White'
}
function Lista($Dados) {
    if (-not $Dados) { Log '  (nada encontrado)' 'DarkGray'; return }
    Log (($Dados | Format-List | Out-String -Width 250).Trim()) 'White'
}
function Confirmar([string]$Pergunta) {
    if (-not $script:Interativo -or $script:JaConfirmado) { return $true }
    $r = Read-Host "  $Pergunta (S/N)"
    return ($r -match '^[sSyY]')
}
function Perguntar([string]$Texto, [string]$Padrao = '') {
    if (-not $script:Interativo) { return $Padrao }
    $rotulo = if ($Padrao) { "  $Texto [$Padrao]" } else { "  $Texto" }
    $r = Read-Host $rotulo
    if ([string]::IsNullOrWhiteSpace($r)) { return $Padrao }
    return $r.Trim()
}
function Pausa {
    if ($script:Interativo) { Write-Host ''; [void](Read-Host '  Pressione Enter para voltar ao menu') }
}
function Formatar([double]$bytes) {
    if ($bytes -ge 1GB) { return "{0:N2} GB" -f ($bytes / 1GB) }
    if ($bytes -ge 1MB) { return "{0:N1} MB" -f ($bytes / 1MB) }
    return "{0:N0} KB" -f ($bytes / 1KB)
}
function Eh-Admin {
    $p = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $p.IsInRole([Security.Principal.SecurityIdentifier]'S-1-5-32-544')
}
function Eh-System { return ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value -eq 'S-1-5-18') }
function Espaco-Livre {
    $d = Get-CimInstance Win32_LogicalDisk -Filter ("DeviceID='{0}'" -f $env:SystemDrive) -ErrorAction SilentlyContinue
    if ($d) { return [double]$d.FreeSpace } else { return [double]0 }
}
function Perfis-Usuario {
    Get-CimInstance Win32_UserProfile -ErrorAction SilentlyContinue |
        Where-Object { -not $_.Special -and $_.LocalPath -and (Test-Path -LiteralPath $_.LocalPath) }
}
function Novo-Arquivo([string]$Subpasta, [string]$Prefixo, [string]$Extensao) {
    $dir = Join-Path $Pasta $Subpasta
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $script:NovoArquivo = Join-Path $dir ("{0}_{1}_{2}.{3}" -f $Prefixo, $env:COMPUTERNAME, (Get-Date -Format 'yyyyMMdd_HHmmss'), $Extensao)
}

# Executa um programa externo mostrando a saida na tela. Codigo em $script:CodigoNativo
function Executar-Nativo([string]$Arquivo, [string]$Argumentos, [switch]$SomenteLeitura) {
    Log "  > $Arquivo $Argumentos" 'DarkGray'
    if ($Simulacao -and -not $SomenteLeitura) {
        Log '  [SIMULACAO] comando nao executado' 'DarkYellow'
        $script:CodigoNativo = 0
        return
    }
    try {
        $p = Start-Process -FilePath $Arquivo -ArgumentList $Argumentos -NoNewWindow -Wait -PassThru -ErrorAction Stop
        $script:CodigoNativo = $p.ExitCode
        Log "  Codigo de saida: $($p.ExitCode)" 'DarkGray'
    } catch {
        $script:CodigoNativo = -1
        Erro "Falha ao executar $Arquivo : $($_.Exception.Message)"
    }
}

# Apaga o CONTEUDO de uma pasta (nunca a pasta em si). Arquivo em uso e ignorado.
function Limpar-Pasta([string]$Caminho, [int]$DiasMinimos = 0, [string]$Descricao = '') {
    if (-not (Test-Path -LiteralPath $Caminho)) { return }
    $limite = (Get-Date).AddDays(-$DiasMinimos)
    $bytes = [long]0; $qtd = 0

    Get-ChildItem -LiteralPath $Caminho -Recurse -Force -File -ErrorAction SilentlyContinue |
        Where-Object { $DiasMinimos -eq 0 -or $_.LastWriteTime -lt $limite } |
        ForEach-Object {
            $tam = $_.Length
            if ($Simulacao) { $bytes += $tam; $qtd++ }
            else {
                try { Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop; $bytes += $tam; $qtd++ } catch { }
            }
        }

    if (-not $Simulacao) {
        Get-ChildItem -LiteralPath $Caminho -Recurse -Force -Directory -ErrorAction SilentlyContinue |
            Sort-Object { $_.FullName.Length } -Descending |
            ForEach-Object {
                if (-not (Get-ChildItem -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue)) {
                    Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
                }
            }
    }

    $script:TotalBytes += $bytes
    if ($qtd -gt 0) {
        $rotulo = if ($Descricao) { $Descricao } else { $Caminho }
        Info ("{0}: {1} arquivos, {2}" -f $rotulo, $qtd, (Formatar $bytes))
    }
}

# =====================================================================
#  OPCOES 1 a 26
# =====================================================================

# ---------- 1 ----------
function Op-LimparTemporarios {
    Titulo '1 - Limpeza de arquivos temporarios'
    Info "Limpa: Temp de TODOS os usuarios e C:\Windows\Temp (arquivos com mais de $DiasMinimosTemp dia(s))."
    Info 'Nao toca: Documentos, Downloads, Area de Trabalho, Lixeira. Arquivos em uso sao ignorados.'
    if (-not (Confirmar 'Continuar?')) { Info 'Cancelado.'; return }

    $script:TotalBytes = 0
    $antes = Espaco-Livre
    foreach ($p in Perfis-Usuario) {
        Limpar-Pasta (Join-Path $p.LocalPath 'AppData\Local\Temp') $DiasMinimosTemp ("Temp ({0})" -f (Split-Path $p.LocalPath -Leaf))
    }
    Limpar-Pasta (Join-Path $env:SystemRoot 'Temp') $DiasMinimosTemp 'Windows\Temp'

    $rot = if ($Simulacao) { 'Seria liberado' } else { 'Liberado' }
    Ok ("{0}: {1}" -f $rot, (Formatar $script:TotalBytes))
    if (-not $Simulacao) { Info ("Espaco livre em {0}: {1} -> {2}" -f $env:SystemDrive, (Formatar $antes), (Formatar (Espaco-Livre))) }
}

# ---------- 2 ----------
function Op-Cleanmgr {
    Titulo '2 - Limpeza de disco (cleanmgr)'
    $cm = Join-Path $env:SystemRoot 'System32\cleanmgr.exe'
    if (-not (Test-Path -LiteralPath $cm)) { Aviso 'cleanmgr nao existe nesta maquina (Windows Server sem Experiencia Desktop). Use a opcao 1.'; return }

    $base    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
    $flag    = 'StateFlags0777'
    $excluir = @('DownloadsFolder', 'Recycle Bin')   # NUNCA limpa Downloads nem Lixeira
    $cats    = @(Get-ChildItem -Path $base -ErrorAction SilentlyContinue)
    $usadas  = @($cats | Where-Object { $excluir -notcontains $_.PSChildName } | ForEach-Object { $_.PSChildName })

    Info ("Categorias que serao limpas ({0}): {1}" -f $usadas.Count, ($usadas -join ', '))
    Info 'Fora da limpeza: pasta Downloads e Lixeira.'
    Info 'Pode levar de alguns minutos a mais de meia hora (limpeza do Windows Update).'
    if (-not (Confirmar 'Continuar?')) { Info 'Cancelado.'; return }
    if ($Simulacao) { Log '  [SIMULACAO] cleanmgr nao executado' 'DarkYellow'; return }

    foreach ($c in $cats) {
        if ($excluir -contains $c.PSChildName) { Remove-ItemProperty -Path $c.PSPath -Name $flag -ErrorAction SilentlyContinue }
        else { New-ItemProperty -Path $c.PSPath -Name $flag -PropertyType DWord -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null }
    }
    $antes = Espaco-Livre
    Executar-Nativo $cm '/sagerun:777'
    Ok ("Espaco livre em {0}: {1} -> {2}" -f $env:SystemDrive, (Formatar $antes), (Formatar (Espaco-Livre)))
}

# ---------- 3 ----------
function Op-SFC {
    Titulo '3 - Verificacao de arquivos do sistema (SFC)'
    Info 'Verifica e repara arquivos protegidos do Windows. Leva de 10 a 30 minutos. Nao feche a janela.'
    Info 'Dica: se o SFC nao conseguir reparar, rode a opcao 4 (DISM) e depois o SFC de novo.'
    Executar-Nativo (Join-Path $env:SystemRoot 'System32\sfc.exe') '/scannow'
    if ($script:CodigoNativo -eq 0) { Ok 'SFC concluido.' } elseif ($script:CodigoNativo -gt 0) { Aviso "SFC terminou com codigo $($script:CodigoNativo)." }
    Info "Detalhes: $env:SystemRoot\Logs\CBS\CBS.log"
}

# ---------- 4 ----------
function Op-DISM {
    Titulo '4 - Reparo de imagem do Windows (DISM)'
    Info 'Repara a imagem do Windows usando o Windows Update (precisa de internet). Leva de 10 a 40 minutos.'
    Executar-Nativo (Join-Path $env:SystemRoot 'System32\Dism.exe') '/Online /Cleanup-Image /RestoreHealth'
    if ($script:CodigoNativo -eq 0) { Ok 'DISM concluido. Recomendado rodar a opcao 3 (SFC) agora.' }
    elseif ($script:CodigoNativo -gt 0) { Aviso "DISM terminou com codigo $($script:CodigoNativo). Log: $env:SystemRoot\Logs\DISM\dism.log" }
}

# ---------- 5 ----------
function Renomear-ParaBackup([string]$Caminho, [string]$Sufixo) {
    if (-not (Test-Path -LiteralPath $Caminho)) { return }
    $novo = (Split-Path $Caminho -Leaf) + $Sufixo
    try { Rename-Item -LiteralPath $Caminho -NewName $novo -ErrorAction Stop; Ok "$Caminho -> $novo" }
    catch { Erro "Nao foi possivel renomear $Caminho : $($_.Exception.Message)" }
}
function Op-ResetWindowsUpdate {
    Titulo '5 - Redefinir o Windows Update'
    $svcs   = @('wuauserv', 'bits', 'cryptsvc', 'msiserver')
    $sufixo = '.bak_' + (Get-Date -Format 'yyyyMMdd_HHmmss')
    Info 'Faz: para os servicos do Windows Update, RENOMEIA SoftwareDistribution e catroot2 (nao apaga) e religa os servicos.'
    Info 'Efeito: o historico de atualizacoes na tela de configuracoes fica vazio. Atualizacoes ja instaladas continuam instaladas.'
    if (-not (Confirmar 'Continuar?')) { Info 'Cancelado.'; return }
    if ($Simulacao) { Log "  [SIMULACAO] pararia $($svcs -join ', ') e renomearia as pastas com sufixo $sufixo" 'DarkYellow'; return }

    Stop-Service -Name $svcs -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    foreach ($s in $svcs) {
        $st = (Get-Service -Name $s -ErrorAction SilentlyContinue).Status
        if ($st -and $st -ne 'Stopped') { Aviso "Servico $s nao parou (status: $st)" }
    }
    Renomear-ParaBackup (Join-Path $env:SystemRoot 'SoftwareDistribution') $sufixo
    Renomear-ParaBackup (Join-Path $env:SystemRoot 'System32\catroot2') $sufixo

    Start-Service -Name 'cryptsvc', 'bits', 'wuauserv' -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    foreach ($s in 'cryptsvc', 'bits', 'wuauserv') {
        $st = (Get-Service -Name $s -ErrorAction SilentlyContinue).Status
        if ($st -eq 'Running') { Ok "Servico $s em execucao" } else { Aviso "Servico $s nao voltou (status: $st). Reinicie a maquina." }
    }
    Info "As pastas antigas (*$sufixo) podem ser apagadas depois de alguns dias, se o Update estiver funcionando."
    Info 'Para desfazer: pare os servicos, apague as pastas novas e renomeie as .bak de volta.'
}

# ---------- 6 ----------
function Op-ResetRede {
    Titulo '6 - Redefinir configuracoes de rede'
    Info 'Faz: limpa o cache DNS, reseta o Winsock e a pilha TCP/IP. Precisa REINICIAR para valer.'
    Log  '  ATENCAO: se voce estiver conectado REMOTAMENTE, a conexao pode cair.' 'Yellow'
    $estaticos = @(Get-NetIPInterface -AddressFamily IPv4 -Dhcp Disabled -ConnectionState Connected -ErrorAction SilentlyContinue |
        Where-Object { $_.InterfaceAlias -notlike 'Loopback*' -and $_.InterfaceAlias -notlike 'vEthernet*' })
    if ($estaticos.Count -gt 0) {
        Aviso ("IP fixo detectado em: {0}. O reset do TCP/IP sera PULADO para nao apagar o IP fixo." -f (($estaticos | ForEach-Object { $_.InterfaceAlias }) -join ', '))
    }
    if (-not (Confirmar 'Continuar?')) { Info 'Cancelado.'; return }

    if (-not $Simulacao) {
        Novo-Arquivo 'Backup' 'rede' 'txt'
        & netsh.exe interface dump 2>$null | Out-File -FilePath $script:NovoArquivo -Encoding ASCII
        Ok "Backup da configuracao de rede: $($script:NovoArquivo)"
        Info "Para restaurar: netsh -f `"$($script:NovoArquivo)`""
    }
    Executar-Nativo 'ipconfig.exe' '/flushdns'
    Executar-Nativo 'netsh.exe' 'winsock reset'
    if ($estaticos.Count -eq 0) { Executar-Nativo 'netsh.exe' ("int ip reset `"{0}`"" -f (Join-Path $PastaLogs 'netsh_ip_reset.log')) }
    Ok 'Concluido. REINICIE a maquina para aplicar.'

    if ($Simulacao) { return }
    $reiniciar = $false
    if ($script:Interativo) { $reiniciar = Confirmar 'Reiniciar agora (aviso de 60 segundos)?' } else { $reiniciar = [bool]$Aplicar }
    if ($reiniciar) {
        & shutdown.exe /r /t 60 /d p:0:0 /c "Reinicio para aplicar a redefinicao de rede. Cancelar: Win+R -> shutdown /a"
        Ok 'Reinicio agendado em 60 segundos (cancelar: shutdown /a).'
    }
}

# ---------- 7 ----------
function Op-GPUpdate {
    Titulo '7 - Atualizacao das politicas de grupo (GPO)'
    $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
    if ($cs -and -not $cs.PartOfDomain) { Aviso 'Maquina fora do dominio: so as politicas locais serao reaplicadas.' }
    else { Info "Dominio: $($cs.Domain)" }
    # Responde "N" se o gpupdate perguntar sobre logoff/reinicio (funciona em portugues e ingles)
    Executar-Nativo 'cmd.exe' '/c echo N| gpupdate /force' -SomenteLeitura
    if ($script:CodigoNativo -eq 0) { Ok 'Politicas atualizadas.' } else { Aviso "gpupdate terminou com codigo $($script:CodigoNativo). Verifique a conexao com o controlador de dominio." }
}

# ---------- 8 e 22 ----------
function Backup-LogsEventos {
    $script:FalhasBackup = 0
    $dir = Join-Path $Pasta ("EventLogs\{0}" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))
    if ($Simulacao) { Log "  [SIMULACAO] o backup seria salvo em $dir" 'DarkYellow'; return }
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    foreach ($l in $LogsBackup) {
        $arq = Join-Path $dir (($l -replace '[\\/:]', '_') + '.evtx')
        & wevtutil.exe epl $l $arq 2>$null
        if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $arq)) { Ok ("{0} -> {1}" -f $l, (Formatar (Get-Item -LiteralPath $arq).Length)) }
        else { $script:FalhasBackup++; Aviso "Nao foi possivel exportar o log $l (codigo $LASTEXITCODE)" }
    }
    Info "Backup salvo em: $dir"
    Info 'Para abrir: Visualizador de Eventos > Acao > Abrir Log Salvo.'
}
function Op-BackupLogs {
    Titulo '22 - Backup dos logs de eventos'
    Backup-LogsEventos
}
function Op-LimparLogs {
    Titulo '8 - Limpeza de logs de eventos'
    Info "Faz: BACKUP de $($LogsBackup -join ', ') e depois limpa TODOS os logs de eventos."
    Log  '  ATENCAO: apaga o historico de auditoria e diagnostico da maquina. Use so se houver motivo.' 'Yellow'
    if (-not (Confirmar 'Continuar?')) { Info 'Cancelado.'; return }

    Backup-LogsEventos
    if ($script:FalhasBackup -gt 0) { Erro 'Backup incompleto - limpeza CANCELADA para nao perder dados.'; return }

    $logs = @(& wevtutil.exe el)
    if ($Simulacao) { Log "  [SIMULACAO] $($logs.Count) logs seriam limpos" 'DarkYellow'; return }
    $ok = 0; $falha = 0
    foreach ($l in $logs) {
        & wevtutil.exe cl "$l" 2>$null
        if ($LASTEXITCODE -eq 0) { $ok++ } else { $falha++ }
    }
    Ok "$ok logs limpos."
    if ($falha -gt 0) { Info "$falha logs nao puderam ser limpos (normal para logs protegidos/desativados)." }
}

# ---------- 9 ----------
function Op-InfoSistema {
    Titulo '9 - Informacoes do sistema'
    $os   = Get-CimInstance Win32_OperatingSystem
    $cs   = Get-CimInstance Win32_ComputerSystem
    $bios = Get-CimInstance Win32_BIOS
    $cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
    $reg  = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction SilentlyContinue
    $up   = (Get-Date) - $os.LastBootUpTime

    Lista ([pscustomobject]@{
        'Computador'       = $env:COMPUTERNAME
        'Dominio/Grupo'    = $cs.Domain
        'Sistema'          = $os.Caption
        'Versao'           = ("{0} (build {1}.{2})" -f $reg.DisplayVersion, $os.BuildNumber, $reg.UBR)
        'Fabricante'       = $cs.Manufacturer
        'Modelo'           = $cs.Model
        'Numero de serie'  = $bios.SerialNumber
        'Processador'      = $cpu.Name.Trim()
        'Nucleos/Threads'  = ("{0} / {1}" -f $cpu.NumberOfCores, $cpu.NumberOfLogicalProcessors)
        'Memoria RAM'      = (Formatar $cs.TotalPhysicalMemory)
        'Ultimo boot'      = $os.LastBootUpTime
        'Ligado ha'        = ("{0} dia(s) {1}h{2:00}" -f $up.Days, $up.Hours, $up.Minutes)
        'Instalado em'     = $os.InstallDate
    })
    if ($up.TotalDays -gt 14) { Aviso ("Maquina ligada ha {0} dias sem reiniciar." -f [int]$up.TotalDays) }

    if ($script:Interativo -and -not (Eh-System)) {
        Start-Process msinfo32.exe
        Ok 'msinfo32 aberto em outra janela.'
    } else {
        Novo-Arquivo 'Relatorios' 'msinfo32' 'txt'
        Info 'Gerando relatorio completo do msinfo32 (pode levar alguns minutos)...'
        Executar-Nativo 'msinfo32.exe' ("/report `"{0}`"" -f $script:NovoArquivo) -SomenteLeitura
        if (Test-Path -LiteralPath $script:NovoArquivo) { Ok "Relatorio: $($script:NovoArquivo)" }
    }
}

# ---------- 10 ----------
function Op-DNS {
    Titulo '10 - Consulta de DNS'
    $a = if ($Alvo) { $Alvo } else { Perguntar 'Nome a consultar' $AlvoPadrao }
    Info 'Servidores DNS configurados:'
    Tabela (Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object { $_.ServerAddresses } |
        Select-Object @{n='Adaptador';e={$_.InterfaceAlias}}, @{n='Servidores DNS';e={$_.ServerAddresses -join ', '}})
    try {
        $t = Measure-Command { $script:Resp = Resolve-DnsName -Name $a -ErrorAction Stop }
        Tabela ($script:Resp | Where-Object { $_.Type -in 'A', 'AAAA', 'CNAME' } |
            Select-Object Name, Type, TTL, IPAddress, NameHost)
        Ok ("{0} resolvido em {1} ms" -f $a, [int]$t.TotalMilliseconds)
    } catch {
        Erro "Nao foi possivel resolver $a : $($_.Exception.Message)"
    }
}

# ---------- 11 ----------
function Op-Adaptadores {
    Titulo '11 - Adaptadores de rede'
    Tabela (Get-NetAdapter -ErrorAction SilentlyContinue | Sort-Object Status, Name |
        Select-Object Name, InterfaceDescription, Status, LinkSpeed, MacAddress,
            @{n='Driver';e={$_.DriverVersionString}}, @{n='Data driver';e={$_.DriverDate}})
    Info 'Enderecos IPv4:'
    Tabela (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object { $_.InterfaceAlias -notlike 'Loopback*' } |
        Select-Object @{n='Adaptador';e={$_.InterfaceAlias}}, IPAddress, PrefixLength, @{n='Origem';e={$_.PrefixOrigin}})
}

# ---------- 12 ----------
function Achar-Winget {
    $script:Winget = $null
    $c = Get-Command winget.exe -ErrorAction SilentlyContinue
    if ($c) { $script:Winget = $c.Source; return }
    $cand = Get-ChildItem "$env:ProgramFiles\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -ErrorAction SilentlyContinue |
            Sort-Object { $_.Directory.Name } -Descending | Select-Object -First 1
    if ($cand) { $script:Winget = $cand.FullName }
}
function Op-Winget {
    Titulo '12 - Programas instalados via winget'
    Achar-Winget
    if (-not $script:Winget) {
        Aviso 'winget nao encontrado. Instale/atualize o "Instalador de Aplicativo" pela Microsoft Store. Como SYSTEM ele pode nao estar disponivel.'
        return
    }
    Info 'Programas com atualizacao disponivel:'
    $saida = & $script:Winget upgrade --accept-source-agreements 2>&1 | Out-String
    $linhas = ($saida -split "[`r`n]+") | Where-Object { $_.Trim() -and $_ -notmatch '^\s*[-\\|/]\s*$' -and $_ -notmatch '[\u2580-\u259F]' }
    Log ($linhas -join [Environment]::NewLine) 'White'

    $atualizar = $false
    if ($script:Interativo) {
        Log '  Atualizar TODOS fecha os programas que estiverem sendo atualizados. Evite no horario de expediente.' 'Yellow'
        $atualizar = Confirmar 'Atualizar todos agora?'
    } else { $atualizar = [bool]$Aplicar }
    if (-not $atualizar) { Info 'Nenhuma atualizacao aplicada (use -Aplicar no modo automatico).'; return }
    if ($Simulacao) { Log '  [SIMULACAO] winget upgrade --all nao executado' 'DarkYellow'; return }

    & $script:Winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -eq 0) { Ok 'Atualizacoes concluidas.' } else { Aviso "winget terminou com codigo $LASTEXITCODE (algum programa pode nao ter atualizado)." }
}

# ---------- 13 ----------
function Op-Processos {
    Titulo '13 - Processos em execucao (30 que mais usam memoria)'
    $procs = @(Get-Process -IncludeUserName -ErrorAction SilentlyContinue)
    Tabela ($procs | Sort-Object WorkingSet64 -Descending | Select-Object -First 30 `
        @{n='Processo';e={$_.ProcessName}}, Id, @{n='Sessao';e={$_.SessionId}},
        @{n='Usuario';e={$_.UserName}},
        @{n='Memoria (MB)';e={[math]::Round($_.WorkingSet64 / 1MB, 1)}},
        @{n='CPU (s)';e={[math]::Round($_.CPU, 1)}})
    Info ("Total de processos: {0}" -f $procs.Count)
}

# ---------- 14 ----------
function Op-Servicos {
    Titulo '14 - Status dos principais servicos'
    $lista = foreach ($n in $ServicosPrincipais) {
        $s = Get-Service -Name $n -ErrorAction SilentlyContinue
        if ($s) {
            [pscustomobject]@{ Servico = $s.Name; Descricao = $s.DisplayName; Status = [string]$s.Status; Inicializacao = [string]$s.StartType }
        }
    }
    Tabela $lista
    $parados = @($lista | Where-Object { $_.Inicializacao -eq 'Automatic' -and $_.Status -ne 'Running' })
    foreach ($p in $parados) { Aviso "$($p.Servico) ($($p.Descricao)) esta configurado como Automatico mas esta $($p.Status)" }
    if ($parados.Count -eq 0) { Ok 'Todos os servicos automaticos da lista estao em execucao.' }
}

# ---------- 15 ----------
function Op-Chkdsk {
    Titulo "15 - CHKDSK no disco $env:SystemDrive"
    Info 'Faz uma verificacao ONLINE (chkdsk /scan): nao trava o uso da maquina e nao precisa reiniciar.'
    Executar-Nativo 'chkdsk.exe' "$env:SystemDrive /scan" -SomenteLeitura
    $agendar = $false
    if ($script:CodigoNativo -eq 0) { Ok 'Nenhum problema encontrado.' }
    else {
        Aviso "CHKDSK retornou codigo $($script:CodigoNativo): podem existir erros no sistema de arquivos."
        if ($script:Interativo) { $agendar = Confirmar 'Agendar verificacao COMPLETA no proximo boot (pode demorar)?' }
    }
    if ($Aplicar) { $agendar = $true }
    if ($agendar) {
        Executar-Nativo 'fsutil.exe' "dirty set $env:SystemDrive"
        Ok 'Verificacao completa agendada para o proximo boot. NAO desligue a maquina durante a verificacao.'
    }
}

# ---------- 16 ----------
function Op-AbrirPowerShell {
    Titulo '16 - Abrir PowerShell'
    if (-not $script:Interativo -or (Eh-System)) { Aviso 'Disponivel apenas no menu interativo.'; return }
    Start-Process powershell.exe -ArgumentList '-NoExit', '-NoProfile' -WorkingDirectory ($env:SystemDrive + '\')
    Ok 'PowerShell (administrador) aberto em outra janela.'
}

# ---------- 17 ----------
function Op-Ipconfig {
    Titulo '17 - Configuracao IP (ipconfig /all)'
    Log ((& ipconfig.exe /all | Out-String).Trim()) 'White'
    try {
        $ip = Invoke-RestMethod -Uri 'https://api.ipify.org' -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        Ok "IP publico (saida para internet): $ip"
    } catch { Info 'IP publico: nao foi possivel consultar.' }
}

# ---------- 18 ----------
function Op-Velocidade {
    Titulo '18 - Teste de velocidade da internet (aproximado)'
    foreach ($h in '1.1.1.1', '8.8.8.8') {
        try {
            $pings = @(Test-Connection -ComputerName $h -Count 4 -ErrorAction Stop)
            Info ("Latencia ate {0}: {1} ms (media de 4)" -f $h, [int](($pings | Measure-Object ResponseTime -Average).Average))
        } catch { Aviso "Sem resposta de ping de $h (pode ser firewall)." }
    }
    Info "Download de teste (ate $SegundosMaxTeste s)..."
    try {
        $req = [Net.HttpWebRequest]::Create($UrlTesteVelocidade)
        $req.Timeout = 15000; $req.ReadWriteTimeout = 15000; $req.UserAgent = 'ManutencaoTI'
        $sw = [Diagnostics.Stopwatch]::StartNew()
        $resp = $req.GetResponse()
        $st = $resp.GetResponseStream()
        $buf = New-Object byte[] 65536
        $total = [long]0
        while (($n = $st.Read($buf, 0, $buf.Length)) -gt 0) {
            $total += $n
            if ($sw.Elapsed.TotalSeconds -ge $SegundosMaxTeste) { break }
        }
        $sw.Stop(); $st.Close(); $resp.Close()
        $mbps = ($total * 8 / 1e6) / [math]::Max($sw.Elapsed.TotalSeconds, 0.001)
        Ok ("Download: {0:N1} Mbps ({1} em {2:N1} s)" -f $mbps, (Formatar $total), $sw.Elapsed.TotalSeconds)
        Info 'Resultado aproximado (um unico fluxo). Para teste oficial use speedtest.net.'
    } catch {
        Erro "Falha no teste de download: $($_.Exception.Message) (firewall/proxy bloqueando $UrlTesteVelocidade?)"
    }
}

# ---------- 19 ----------
function Op-Disco {
    Titulo '19 - Espaco e saude dos discos'
    $discos = @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
        $pct = if ($_.Size) { [math]::Round($_.FreeSpace / $_.Size * 100, 1) } else { 0 }
        [pscustomobject]@{
            Unidade      = $_.DeviceID
            Rotulo       = $_.VolumeName
            Sistema      = $_.FileSystem
            'Total (GB)' = [math]::Round($_.Size / 1GB, 1)
            'Livre (GB)' = [math]::Round($_.FreeSpace / 1GB, 1)
            'Livre %'    = $pct
        }
    })
    Tabela $discos
    foreach ($d in $discos) {
        if ($d.'Livre %' -lt 10) { Aviso "Unidade $($d.Unidade) com apenas $($d.'Livre %')% livre. Rode as opcoes 1 e 2." }
    }
    try {
        $fis = @(Get-PhysicalDisk -ErrorAction Stop | Select-Object FriendlyName, MediaType, BusType,
            @{n='Tamanho (GB)';e={[math]::Round($_.Size / 1GB, 0)}}, HealthStatus, OperationalStatus)
        Info 'Discos fisicos:'
        Tabela $fis
        foreach ($f in $fis) { if ([string]$f.HealthStatus -ne 'Healthy') { Aviso "Disco '$($f.FriendlyName)' com saude: $($f.HealthStatus). Faca backup e avalie a troca." } }
    } catch { Info 'Saude dos discos fisicos: indisponivel neste sistema.' }
}

# ---------- 20 ----------
function Op-Antivirus {
    Titulo '20 - Status do antivirus'
    $ativoTerceiro = $false
    try {
        $prods = @(Get-CimInstance -Namespace 'root/SecurityCenter2' -ClassName AntiVirusProduct -ErrorAction Stop)
        $t = foreach ($p in $prods) {
            $hex = '{0:X6}' -f [int]$p.productState
            $ativo = $hex.Substring(2, 2) -in '10', '11'
            $atual = $hex.Substring(4, 2) -eq '00'
            if ($ativo -and $p.displayName -notmatch 'Defender') { $ativoTerceiro = $true }
            [pscustomobject]@{
                Antivirus   = $p.displayName
                Ativo       = $(if ($ativo) { 'Sim' } else { 'NAO' })
                Atualizado  = $(if ($atual) { 'Sim' } else { 'NAO' })
            }
        }
        Tabela $t
        if (-not ($t | Where-Object { $_.Ativo -eq 'Sim' })) { Erro 'Nenhum antivirus ATIVO encontrado!' }
        foreach ($x in $t) { if ($x.Ativo -eq 'Sim' -and $x.Atualizado -eq 'NAO') { Aviso "$($x.Antivirus) esta DESATUALIZADO." } }
    } catch {
        Info 'Central de Seguranca indisponivel (normal em Windows Server). Verificando o Defender...'
    }

    if (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue) {
        try {
            $m = Get-MpComputerStatus -ErrorAction Stop
            Info 'Microsoft Defender:'
            Lista ($m | Select-Object AMRunningMode, AntivirusEnabled, RealTimeProtectionEnabled,
                AntivirusSignatureVersion, AntivirusSignatureLastUpdated, AntivirusSignatureAge, QuickScanAge)
            if (-not $ativoTerceiro) {
                if (-not $m.RealTimeProtectionEnabled) { Erro 'Protecao em tempo real do Defender DESLIGADA.' }
                if ($m.AntivirusSignatureAge -gt 3) { Aviso "Assinaturas do Defender com $($m.AntivirusSignatureAge) dias. Rode: Update-MpSignature" }
            } else { Info 'Ha antivirus de terceiros ativo: o Defender fica em modo passivo (normal).' }
        } catch { Info 'Defender indisponivel ou desativado por outro antivirus.' }
    }
}

# ---------- 21 ----------
function Op-Conectividade {
    Titulo '21 - Teste de conectividade'
    $a = if ($Alvo) { $Alvo } else { $AlvoPadrao }
    $gw = (Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Sort-Object RouteMetric | Select-Object -First 1).NextHop

    $r = [ordered]@{}
    $r['Gateway']  = if ($gw) { Test-Connection -ComputerName $gw -Count 2 -Quiet -ErrorAction SilentlyContinue } else { $false }
    $r['Internet'] = Test-Connection -ComputerName '8.8.8.8' -Count 2 -Quiet -ErrorAction SilentlyContinue
    try { [void](Resolve-DnsName -Name $a -ErrorAction Stop); $r['DNS'] = $true } catch { $r['DNS'] = $false }
    $r['Porta443'] = [bool](Test-NetConnection -ComputerName $a -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue)
    try { $w = Invoke-WebRequest -Uri "https://$a" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop; $r['HTTPS'] = ($w.StatusCode -lt 400) } catch { $r['HTTPS'] = $false }

    $desc = @{
        Gateway  = "Ping no gateway/roteador ($gw)"
        Internet = 'Ping na internet (8.8.8.8)'
        DNS      = "Resolucao de nome ($a)"
        Porta443 = "Conexao TCP 443 ($a)"
        HTTPS    = "Acesso HTTPS (https://$a)"
    }
    foreach ($k in $r.Keys) { if ($r[$k]) { Ok $desc[$k] } else { Aviso ("FALHA - " + $desc[$k]) } }

    if (-not $r['Gateway'] -and -not $r['Internet']) { Info 'Diagnostico: sem acesso a rede local. Verifique cabo/Wi-Fi, IP (opcao 17) e o roteador.' }
    elseif ($r['Internet'] -and -not $r['DNS'])     { Info 'Diagnostico: internet OK, mas DNS falhou. Verifique os servidores DNS (opcao 10).' }
    elseif ($r['DNS'] -and -not $r['HTTPS'])        { Info 'Diagnostico: DNS OK, mas HTTPS falhou. Possivel firewall, proxy ou data/hora errada.' }
    elseif ($r['HTTPS'])                            { Ok 'Conectividade com a internet funcionando.' }
}

# ---------- 23 ----------
function Op-USB {
    Titulo '23 - Dispositivos USB conectados'
    $dev = @(Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue |
        Where-Object { $_.InstanceId -like 'USB\*' -or $_.InstanceId -like 'USBSTOR\*' })
    Tabela ($dev | Where-Object { $_.Class -ne 'USB' } | Sort-Object Class, FriendlyName |
        Select-Object @{n='Classe';e={$_.Class}}, @{n='Dispositivo';e={$_.FriendlyName}}, Status)
    Info ("Controladores/hubs USB: {0} (omitidos da lista)" -f @($dev | Where-Object { $_.Class -eq 'USB' }).Count)
    $disc = @(Get-Disk -ErrorAction SilentlyContinue | Where-Object { $_.BusType -eq 'USB' })
    if ($disc.Count) {
        Info 'Armazenamento USB (pendrive/HD externo):'
        Tabela ($disc | Select-Object Number, FriendlyName, @{n='Tamanho (GB)';e={[math]::Round($_.Size / 1GB, 1)}}, HealthStatus)
    }
}

# ---------- 24 e M1 ----------
function Mostrar-Memoria {
    $os = Get-CimInstance Win32_OperatingSystem
    $total = [double]$os.TotalVisibleMemorySize * 1KB
    $livre = [double]$os.FreePhysicalMemory * 1KB
    $usado = $total - $livre
    $pct   = [math]::Round($usado / $total * 100, 1)
    Lista ([pscustomobject]@{ 'Memoria total' = (Formatar $total); 'Em uso' = ("{0} ({1}%)" -f (Formatar $usado), $pct); 'Livre' = (Formatar $livre) })
    $pf = @(Get-CimInstance Win32_PageFileUsage -ErrorAction SilentlyContinue)
    if ($pf.Count) {
        Info 'Arquivo de paginacao (swap):'
        Tabela ($pf | Select-Object Name, @{n='Tamanho (MB)';e={$_.AllocatedBaseSize}}, @{n='Em uso (MB)';e={$_.CurrentUsage}}, @{n='Pico (MB)';e={$_.PeakUsage}})
    }
    if ($pct -ge 90) { Aviso "Memoria em $pct% de uso." }
}
function Op-MemoriaCPU {
    Titulo '24 - Uso de memoria e CPU'
    Mostrar-Memoria
    $cpu = @(Get-CimInstance Win32_Processor)
    $amostras = foreach ($i in 1..3) { (Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average; Start-Sleep -Milliseconds 700 }
    $carga = [int](($amostras | Measure-Object -Average).Average)
    Info ("CPU: {0} | carga media agora: {1}%" -f $cpu[0].Name.Trim(), $carga)
    if ($carga -ge 90) { Aviso "CPU em $carga% de uso." }
    $procs = Get-Process -ErrorAction SilentlyContinue
    Info 'Top 10 por memoria:'
    Tabela ($procs | Sort-Object WorkingSet64 -Descending | Select-Object -First 10 @{n='Processo';e={$_.ProcessName}}, Id, @{n='Memoria (MB)';e={[math]::Round($_.WorkingSet64 / 1MB, 1)}})
    Info 'Top 10 por tempo de CPU acumulado:'
    Tabela ($procs | Sort-Object CPU -Descending | Select-Object -First 10 @{n='Processo';e={$_.ProcessName}}, Id, @{n='CPU (s)';e={[math]::Round($_.CPU, 1)}})
}

# ---------- 25 ----------
function Op-Download {
    Titulo '25 - Baixar arquivo via HTTPS'
    $u = if ($Url) { $Url } else { Perguntar 'URL do arquivo (https://...)' }
    if ($u -notmatch '^https://') { Erro 'Informe uma URL que comece com https://'; return }

    $nome = ''
    try { $nome = [Uri]::UnescapeDataString([IO.Path]::GetFileName(([Uri]$u).AbsolutePath)) } catch { }
    foreach ($c in [IO.Path]::GetInvalidFileNameChars()) { $nome = $nome.Replace([string]$c, '_') }
    if (-not $nome) { $nome = 'download.bin' }

    $dirPadrao = Join-Path $Pasta 'Downloads'
    if (-not (Eh-System) -and (Test-Path -LiteralPath (Join-Path $env:USERPROFILE 'Downloads'))) { $dirPadrao = Join-Path $env:USERPROFILE 'Downloads' }
    $dir = if ($Destino) { $Destino } else { Perguntar 'Pasta de destino' $dirPadrao }
    $arq = Join-Path $dir $nome
    if (Test-Path -LiteralPath $arq) {
        $arq = Join-Path $dir ("{0}_{1}{2}" -f [IO.Path]::GetFileNameWithoutExtension($nome), (Get-Date -Format 'yyyyMMdd_HHmmss'), [IO.Path]::GetExtension($nome))
    }
    if ($Simulacao) { Log "  [SIMULACAO] baixaria $u para $arq" 'DarkYellow'; return }

    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Info "Baixando para $arq ..."
    $sw = [Diagnostics.Stopwatch]::StartNew()
    try { Invoke-WebRequest -Uri $u -OutFile $arq -UseBasicParsing -ErrorAction Stop }
    catch { Erro "Falha no download: $($_.Exception.Message)"; return }
    $sw.Stop()

    $hash = (Get-FileHash -LiteralPath $arq -Algorithm SHA256).Hash
    Ok ("Baixado: {0} ({1} em {2:N1} s)" -f $arq, (Formatar (Get-Item -LiteralPath $arq).Length), $sw.Elapsed.TotalSeconds)
    Info "SHA256: $hash"
    $esperado = if ($Sha256) { $Sha256 } else { Perguntar 'SHA256 esperado para conferir (Enter para pular)' '' }
    if ($esperado) {
        if ($hash -eq $esperado.Trim()) { Ok 'Hash confere com o informado.' }
        else { Erro 'HASH NAO CONFERE - o arquivo pode estar corrompido ou adulterado. NAO execute.' }
    }
    Info 'Execute somente arquivos de fontes confiaveis.'
}

# ---------- 26 ----------
function Op-Gpresult {
    Titulo '26 - Relatorio de politicas de grupo (gpresult)'
    Novo-Arquivo 'Relatorios' 'gpresult' 'html'
    $arq = $script:NovoArquivo
    $argumentos = "/h `"$arq`" /f"
    if (Eh-System) { $argumentos += ' /scope computer' }
    Executar-Nativo 'gpresult.exe' $argumentos -SomenteLeitura
    if (-not (Test-Path -LiteralPath $arq) -and -not (Eh-System)) {
        Info 'Sem dados de usuario para esta conta. Gerando somente a parte do computador...'
        Executar-Nativo 'gpresult.exe' "/h `"$arq`" /f /scope computer" -SomenteLeitura
    }
    if (Test-Path -LiteralPath $arq) {
        Ok "Relatorio: $arq"
        if ($script:Interativo -and -not (Eh-System)) { Start-Process $arq }
    } else { Aviso 'Relatorio nao gerado. Em maquina fora do dominio o gpresult pode nao ter dados (normal).' }
}

# =====================================================================
#  OPCAO 27 - OTIMIZADOR DE MEMORIA (M1 a M6)
# =====================================================================
function Mem-Exibir {
    Titulo 'M1 - Uso de memoria'
    Mostrar-Memoria
}

function Mem-FecharPesados {
    Titulo 'M2 - Fechar processos pesados'
    $sessao = (Get-Process -Id $PID).SessionId
    if ($sessao -eq 0 -and -not $TodosUsuarios) { Aviso 'Rodando sem sessao de usuario (SYSTEM). Use -TodosUsuarios para agir em todas as sessoes.'; return }
    $procs = @(Get-Process -Name $ProcessosPesados -ErrorAction SilentlyContinue | Where-Object { $TodosUsuarios -or $_.SessionId -eq $sessao })
    if ($procs.Count -eq 0) { Ok 'Nenhum dos programas da lista esta aberto.'; return }

    Tabela ($procs | Group-Object ProcessName | ForEach-Object {
        [pscustomobject]@{ Programa = $_.Name; Instancias = $_.Count; 'Memoria (MB)' = [math]::Round((($_.Group | Measure-Object WorkingSet64 -Sum).Sum) / 1MB, 0) }
    } | Sort-Object 'Memoria (MB)' -Descending)
    if ($TodosUsuarios) { Log '  ATENCAO: vai fechar em TODAS as sessoes (todos os usuarios desta maquina/TS).' 'Yellow' }
    Log '  Trabalho nao salvo nesses programas sera perdido. Abas do Chrome/Edge sao restauradas ao reabrir.' 'Yellow'
    if (-not (Confirmar 'Fechar esses programas?')) { Info 'Cancelado.'; return }
    if ($Simulacao) { Log '  [SIMULACAO] nada foi fechado' 'DarkYellow'; return }

    $mem = ($procs | Measure-Object WorkingSet64 -Sum).Sum
    foreach ($p in $procs) { try { [void]$p.CloseMainWindow() } catch { } }   # tenta fechar educadamente
    Start-Sleep -Seconds 5
    foreach ($p in $procs) {
        try { $p.Refresh(); if (-not $p.HasExited) { Stop-Process -Id $p.Id -Force -ErrorAction Stop } } catch { }
    }
    Ok ("Programas fechados. Memoria aproximada liberada: {0}" -f (Formatar $mem))
    if ($procs | Where-Object { $_.ProcessName -eq 'OneDrive' }) { Info 'OneDrive volta a sincronizar no proximo logon (ou abra-o pelo menu Iniciar).' }
}

function Mem-LimparTemp {
    Op-LimparTemporarios
}

function Mem-Lixeira {
    Titulo 'M4 - Esvaziar Lixeira'
    $sidAtual = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $todos = [bool]$TodosUsuarios
    if ($script:Interativo -and -not $script:JaConfirmado -and -not $todos) {
        $todos = Confirmar "Esvaziar a Lixeira de TODOS os usuarios desta maquina? (N = so do usuario $env:USERNAME)"
    }
    if (-not $todos -and (Eh-System)) { Aviso 'Rodando como SYSTEM: use -TodosUsuarios para esvaziar a Lixeira dos usuarios.'; return }

    $unidades = @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object { $_.DeviceID })
    $itens = @(foreach ($u in $unidades) {
        $rb = Join-Path ($u + '\') '$Recycle.Bin'
        if (-not (Test-Path -LiteralPath $rb)) { continue }
        Get-ChildItem -LiteralPath $rb -Force -Directory -ErrorAction SilentlyContinue |
            Where-Object { $todos -or $_.Name -eq $sidAtual } |
            ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'desktop.ini' } }
    })
    if ($itens.Count -eq 0) { Ok 'Lixeira ja esta vazia.'; return }
    $bytes = [double](($itens | ForEach-Object {
        if ($_.PSIsContainer) { (Get-ChildItem -LiteralPath $_.FullName -Recurse -Force -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum } else { $_.Length }
    } | Measure-Object -Sum).Sum)

    $quem = if ($todos) { 'TODOS os usuarios' } else { "usuario $env:USERNAME" }
    Log ("  Lixeira de {0}: {1} itens, {2}. Serao apagados DEFINITIVAMENTE." -f $quem, $itens.Count, (Formatar $bytes)) 'Yellow'
    if (-not (Confirmar 'Esvaziar agora?')) { Info 'Cancelado.'; return }
    if ($Simulacao) { Log '  [SIMULACAO] nada foi apagado' 'DarkYellow'; return }

    $falhas = 0
    foreach ($i in $itens) { try { Remove-Item -LiteralPath $i.FullName -Recurse -Force -ErrorAction Stop } catch { $falhas++ } }
    Ok ("Lixeira esvaziada: {0} liberados." -f (Formatar $bytes))
    if ($falhas) { Info "$falhas item(ns) em uso nao puderam ser apagados." }
}

function Mem-ReiniciarExplorer {
    Titulo 'M5 - Reiniciar o Windows Explorer'
    $sessao = (Get-Process -Id $PID).SessionId
    if ($sessao -eq 0 -and -not $TodosUsuarios) { Aviso 'Rodando sem sessao de usuario (SYSTEM). Use -TodosUsuarios para reiniciar o Explorer de todas as sessoes.'; return }
    $exps = @(Get-Process -Name explorer -ErrorAction SilentlyContinue | Where-Object { $TodosUsuarios -or $_.SessionId -eq $sessao })
    if ($exps.Count -eq 0) {
        Aviso 'Explorer nao esta em execucao nesta sessao.'
        if ($script:Interativo -and -not $Simulacao) { Start-Process explorer.exe; Ok 'Explorer iniciado.' }
        return
    }
    Info 'A barra de tarefas e as janelas de pasta fecham e voltam em alguns segundos.'
    if ($TodosUsuarios) { Log '  ATENCAO: vai reiniciar o Explorer de TODAS as sessoes.' 'Yellow' }
    if (-not (Confirmar 'Reiniciar o Explorer?')) { Info 'Cancelado.'; return }
    if ($Simulacao) { Log '  [SIMULACAO] Explorer nao reiniciado' 'DarkYellow'; return }

    $sessoes = @($exps | ForEach-Object { $_.SessionId } | Sort-Object -Unique)
    $exps | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 8   # o Windows reabre o Explorer sozinho
    foreach ($s in $sessoes) {
        if (Get-Process -Name explorer -ErrorAction SilentlyContinue | Where-Object { $_.SessionId -eq $s }) { Ok "Explorer reiniciado na sessao $s" }
        elseif ($s -eq $sessao) { Start-Process explorer.exe; Ok "Explorer iniciado manualmente na sessao $s" }
        else { Aviso "Explorer nao voltou na sessao $s. O usuario pode usar Ctrl+Shift+Esc > Executar nova tarefa > explorer" }
    }
}

function Mem-Completa {
    Titulo 'M6 - Otimizacao completa'
    Info 'Executa em sequencia: M2 fechar programas pesados, M3 limpar temporarios, M4 esvaziar Lixeira, M5 reiniciar Explorer.'
    if (-not (Confirmar 'Executar tudo (uma unica confirmacao)?')) { Info 'Cancelado.'; return }
    $script:JaConfirmado = $true
    try {
        Mem-FecharPesados
        Mem-LimparTemp
        Mem-Lixeira
        Mem-ReiniciarExplorer
        Mem-Exibir
    } finally { $script:JaConfirmado = $false }
}

function Menu-Memoria {
    while ($true) {
        Clear-Host
        Write-Host ''
        Write-Host '  ================ OTIMIZADOR DE MEMORIA ================' -ForegroundColor Cyan
        Write-Host '   1. Exibir uso de memoria (total / livre / usado)'
        Write-Host '   2. Fechar processos pesados'
        Write-Host '      (Chrome, Edge, Firefox, Opera, Discord, Spotify, Teams, Steam, OneDrive)'
        Write-Host '   3. Limpar arquivos temporarios'
        Write-Host '   4. Esvaziar Lixeira'
        Write-Host '   5. Reiniciar o Windows Explorer'
        Write-Host '   6. Otimizacao completa (2 a 5 em sequencia)'
        Write-Host '   0. Voltar ao menu principal'
        Write-Host '  =======================================================' -ForegroundColor Cyan
        $e = (Read-Host '  Escolha').Trim()
        if ($e -eq '0') { return }
        if ($e -match '^[1-6]$') { Executar-Opcao ("M$e"); Pausa }
    }
}

# ---------- U ----------
function Op-Repositorio {
    Titulo 'U - Repositorio (GitHub)'
    if (-not $UrlRepositorio -or $UrlRepositorio -eq 'PREENCHER') {
        Aviso 'Repositorio nao configurado. Edite $UrlRepositorio na secao CONFIGURACOES do script.'
        return
    }
    Info "Repositorio: $UrlRepositorio"
    if ($script:Interativo -and -not (Eh-System)) { Start-Process $UrlRepositorio; Ok 'Aberto no navegador.' }
}

# =====================================================================
#  MENU E EXECUCAO
# =====================================================================
function Executar-Opcao([string]$Op) {
    $Op = $Op.Trim().ToUpper()
    if ($script:ArquivoLog) {
        Add-Content -Path $script:ArquivoLog -Encoding UTF8 -Value ("[{0}] --- Opcao {1} | usuario {2} ---" -f (Get-Date -Format 'HH:mm:ss'), $Op, $env:USERNAME)
    }
    try {
        switch ($Op) {
            '1'  { Op-LimparTemporarios }
            '2'  { Op-Cleanmgr }
            '3'  { Op-SFC }
            '4'  { Op-DISM }
            '5'  { Op-ResetWindowsUpdate }
            '6'  { Op-ResetRede }
            '7'  { Op-GPUpdate }
            '8'  { Op-LimparLogs }
            '9'  { Op-InfoSistema }
            '10' { Op-DNS }
            '11' { Op-Adaptadores }
            '12' { Op-Winget }
            '13' { Op-Processos }
            '14' { Op-Servicos }
            '15' { Op-Chkdsk }
            '16' { Op-AbrirPowerShell }
            '17' { Op-Ipconfig }
            '18' { Op-Velocidade }
            '19' { Op-Disco }
            '20' { Op-Antivirus }
            '21' { Op-Conectividade }
            '22' { Op-BackupLogs }
            '23' { Op-USB }
            '24' { Op-MemoriaCPU }
            '25' { Op-Download }
            '26' { Op-Gpresult }
            '27' { if ($script:Interativo) { Menu-Memoria } else { Erro 'No modo automatico use -Opcao M1 a M6.' } }
            'M1' { Mem-Exibir }
            'M2' { Mem-FecharPesados }
            'M3' { Mem-LimparTemp }
            'M4' { Mem-Lixeira }
            'M5' { Mem-ReiniciarExplorer }
            'M6' { Mem-Completa }
            'U'  { Op-Repositorio }
            default { Erro "Opcao invalida: $Op" }
        }
    } catch {
        Erro ("Erro inesperado: {0} (linha {1})" -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
    }
}

function Mostrar-Menu {
    Clear-Host
    $itens = @(
        '1|Limpeza de arquivos temporarios',      '15|Executar CHKDSK no disco C:',
        '2|Limpeza de disco (cleanmgr)',          '16|Abrir PowerShell (admin)',
        '3|Verificar arquivos do sistema (SFC)',  '17|Ver configuracao IP (ipconfig)',
        '4|Reparar imagem do Windows (DISM)',     '18|Testar velocidade da internet',
        '5|Redefinir o Windows Update',           '19|Verificar espaco em disco',
        '6|Redefinir configuracoes de rede',      '20|Status do antivirus',
        '7|Atualizar politicas de grupo (GPO)',   '21|Testar conectividade com o Google',
        '8|Limpar logs de eventos',               '22|Backup dos logs de eventos',
        '9|Informacoes do sistema (msinfo32)',    '23|Dispositivos USB conectados',
        '10|Consulta de DNS',                     '24|Uso de memoria e CPU',
        '11|Ver adaptadores de rede',             '25|Baixar arquivo via HTTPS',
        '12|Ver/atualizar programas (winget)',    '26|Relatorio de politicas (gpresult)',
        '13|Ver processos em execucao',           '27|Otimizador de Memoria  >>',
        '14|Status dos principais servicos',      'U|Abrir repositorio (GitHub)'
    )
    Write-Host ''
    Write-Host ("  MANUTENCAO TI v{0}   |   {1}   |   {2}" -f $VersaoScript, $env:COMPUTERNAME, $script:NomeSO) -ForegroundColor Cyan
    Write-Host ("  Usuario: {0}   |   Log: {1}" -f $env:USERNAME, $script:ArquivoLog) -ForegroundColor DarkGray
    if ($Simulacao) { Write-Host '  *** MODO SIMULACAO ATIVO - nada sera alterado ***' -ForegroundColor DarkYellow }
    Write-Host ('  ' + ('=' * 86)) -ForegroundColor Cyan
    for ($i = 0; $i -lt $itens.Count; $i += 2) {
        $e = $itens[$i].Split('|'); $d = $itens[$i + 1].Split('|')
        Write-Host ("  {0,3}. {1,-40}   {2,3}. {3}" -f $e[0], $e[1], $d[0], $d[1])
    }
    Write-Host ('  ' + ('=' * 86)) -ForegroundColor Cyan
    Write-Host '    0. Sair'
    Write-Host ''
}

# ---------- Pre-requisito: administrador ----------
if (-not (Eh-Admin)) {
    if ($script:Interativo -and $PSCommandPath) {
        Write-Host 'Este script precisa de Administrador. Solicitando elevacao...' -ForegroundColor Yellow
        $extra = if ($Simulacao) { ' -Simulacao' } else { '' }
        try { Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"{1}" -f $PSCommandPath, $extra) -ErrorAction Stop }
        catch { Write-Host 'Elevacao cancelada. Clique com o botao direito > Executar como administrador.' -ForegroundColor Red; Start-Sleep -Seconds 5 }
        exit 1
    }
    Write-Output 'ERRO: execute como Administrador (botao direito > Executar como administrador, ou pelo RMM como SYSTEM).'
    exit 1
}

# ---------- Log ----------
try {
    New-Item -ItemType Directory -Path $PastaLogs -Force | Out-Null
    $script:ArquivoLog = Join-Path $PastaLogs ("manutencao_{0}.log" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))
    Get-ChildItem -LiteralPath $PastaLogs -Filter '*.log' -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$DiasManterLogs) } |
        Remove-Item -Force -ErrorAction SilentlyContinue
} catch { $script:ArquivoLog = $null }

$script:NomeSO = (Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue).Caption
if ($script:ArquivoLog) {
    Add-Content -Path $script:ArquivoLog -Encoding UTF8 -Value ("[{0}] ===== Manutencao TI v{1} em {2} ({3}) por {4} =====" -f (Get-Date -Format 'HH:mm:ss'), $VersaoScript, $env:COMPUTERNAME, $script:NomeSO, $env:USERNAME)
}

# ---------- Modo automatico ----------
if (-not $script:Interativo) {
    Log ("===== Manutencao TI v{0} | {1} | opcao {2} =====" -f $VersaoScript, $env:COMPUTERNAME, $Opcao)
    Executar-Opcao $Opcao
    $status = if ($script:Erros.Count) { '[ERRO]' } elseif ($script:Avisos.Count) { '[AVISO]' } else { '[OK]' }
    Log ("===== {0} Concluido: {1} erro(s), {2} aviso(s). Log: {3} =====" -f $status, $script:Erros.Count, $script:Avisos.Count, $script:ArquivoLog)
    if ($script:Erros.Count) { exit 1 } else { exit 0 }
}

# ---------- Modo menu ----------
try { $Host.UI.RawUI.WindowTitle = "Manutencao TI - $env:COMPUTERNAME" } catch { }
while ($true) {
    Mostrar-Menu
    $escolha = (Read-Host '  Escolha uma opcao').Trim()
    if ($escolha -eq '0') { break }
    if (-not $escolha) { continue }
    Executar-Opcao $escolha
    if ($escolha -ne '27') { Pausa }
}
Write-Host ''
Write-Host "  Log desta sessao: $($script:ArquivoLog)" -ForegroundColor DarkGray
exit 0
