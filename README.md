# 🚀 Manutenção TI – Automação de rotinas com PowerShell

> Projeto pessoal

O **Manutenção TI** é uma ferramenta desenvolvida em PowerShell que reúne diferentes funcionalidades de diagnóstico, manutenção, monitoramento e otimização do ambiente Windows em uma única interface. Foi criada para otimizar e centralizar tarefas recorrentes de suporte técnico e administração de infraestrutura Windows.

**Principais recursos**

- 🔹 Limpeza de arquivos temporários e manutenção do sistema
- 🔹 Diagnóstico e reparação do Windows com SFC e DISM
- 🔹 Verificação de conectividade, DNS e adaptadores de rede
- 🔹 Monitoramento de CPU, memória RAM e armazenamento
- 🔹 Gerenciamento de processos e serviços
- 🔹 Backup e gerenciamento de logs de eventos
- 🔹 Atualização de softwares utilizando Winget
- 🔹 Execução automatizada por parâmetros, permitindo integração com ferramentas de gerenciamento remoto

A segurança operacional foi prioridade: modo de simulação, confirmação de operações críticas, backup de configurações e geração de logs. A ferramenta pode ser usada pela interface interativa, por execução remota ou em automações por tarefas agendadas.

💡 **Objetivo:** reduzir tarefas manuais, padronizar procedimentos e tornar as rotinas de suporte e manutenção mais eficientes.

**Tecnologias:** PowerShell · Windows · Winget · Administração de Sistemas · Automação de TI · Infraestrutura de Redes

## O menu

São **27 ferramentas** num menu numérico. Roda em qualquer Windows 10/11 (e na maioria das opções em Windows Server 2016+), sem depender de RMM.

```
  MANUTENCAO TI v1.0   |   PC01   |   Microsoft Windows 11 Pro
  ======================================================================================
    1. Limpeza de arquivos temporarios          15. Executar CHKDSK no disco C:
    2. Limpeza de disco (cleanmgr)              16. Abrir PowerShell (admin)
    3. Verificar arquivos do sistema (SFC)      17. Ver configuracao IP (ipconfig)
    4. Reparar imagem do Windows (DISM)         18. Testar velocidade da internet
    5. Redefinir o Windows Update               19. Verificar espaco em disco
    6. Redefinir configuracoes de rede          20. Status do antivirus
    7. Atualizar politicas de grupo (GPO)       21. Testar conectividade com o Google
    8. Limpar logs de eventos                   22. Backup dos logs de eventos
    9. Informacoes do sistema (msinfo32)        23. Dispositivos USB conectados
   10. Consulta de DNS                          24. Uso de memoria e CPU
   11. Ver adaptadores de rede                  25. Baixar arquivo via HTTPS
   12. Ver/atualizar programas (winget)         26. Relatorio de politicas (gpresult)
   13. Ver processos em execucao                27. Otimizador de Memoria  >>
   14. Status dos principais servicos            U. Abrir repositorio (GitHub)
  ======================================================================================
```

## Como usar

**1. Dois cliques** — baixe `Manutencao-TI.bat` e `Manutencao-TI.ps1`, coloque os dois **na mesma pasta** (disco local, pendrive ou pasta de rede) e dê dois cliques no `.bat`. Ele pede permissão de administrador e abre o menu.

**2. PowerShell como administrador**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Manutencao-TI.ps1
```

**3. Modo automático (sem menu)** — informe a opção com `-Opcao`:

```powershell
# Relatório de disco
.\Manutencao-TI.ps1 -Opcao 19
# Simula a limpeza de temporários, sem apagar nada
.\Manutencao-TI.ps1 -Opcao 1 -Simulacao
# Atualiza todos os programas via winget
.\Manutencao-TI.ps1 -Opcao 12 -Aplicar
```

**4. Remoto**

```powershell
Invoke-Command -ComputerName PC01, PC02 -FilePath .\Manutencao-TI.ps1 -ArgumentList '19'
```

Código de saída: `0` = OK, `1` = houve erro (útil para alertas no RMM).

## Parâmetros

| Parâmetro | Uso |
|---|---|
| `-Opcao <n>` | 1 a 27, M1 a M6 (otimizador de memória) ou U |
| `-Simulacao` | mostra o que seria feito, sem alterar nada |
| `-Aplicar` | 6: reinicia ao final · 12: atualiza via winget · 15: agenda CHKDSK completo |
| `-TodosUsuarios` | M2/M5: age em todas as sessões · M4: Lixeira de todos os usuários |
| `-Alvo <nome>` | opções 10 e 21 (padrão: google.com) |
| `-Url`, `-Destino`, `-Sha256` | opção 25 (download com conferência de hash) |

## Segurança

- Toda opção que apaga ou altera algo mostra o que vai fazer e pede confirmação **S/N**.
- **Nunca toca** em Documentos, Downloads, Área de Trabalho, dados de navegadores ou bancos de sistemas.
- Redefinir o Windows Update **renomeia** (não apaga) as pastas.
- Redefinir a rede faz backup da configuração e **não reseta o TCP/IP se houver IP fixo**.
- Limpar logs de eventos só acontece **depois do backup** deles.
- Modo `-Simulacao` para testar qualquer opção sem risco.

Logs e relatórios ficam em `C:\ProgramData\ManutencaoTI\` (logs mantidos por 30 dias).

## Requisitos

- Windows 10/11 ou Windows Server 2016+
- Windows PowerShell 5.1 (já vem no Windows)
- Executar como Administrador

## Aviso

Use por sua conta e risco. Teste em uma máquina antes de rodar em massa e prefira o modo `-Simulacao` na primeira vez.

## Licença

[MIT](LICENSE)
