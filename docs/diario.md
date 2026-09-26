# Diário de execução

## 2026-09-25 — Preparação

**Informado pelo autor:** CachyOS, 16 GB de RAM, contagem vmx/svm igual a 12; dnsmasq instalado; demais componentes principais pendentes.

**Produzido:** estrutura inicial da documentação e planejamento.

**Ainda não validado:** acesso ao KVM, espaço em disco, instalação e funcionamento do libvirt, redes e VMs.

## 2026-09-25 — Host e Ubuntu validados

**Host:** Ryzen 5 5500 (6 núcleos, 12 threads), AMD-V; 15 GiB de RAM utilizáveis; 536 GB livres na partição do host. `virt-host-validate qemu` aprovou virtualização, `/dev/kvm`, rede e cgroups; apenas convidado seguro (SEV/TDX) recebeu aviso, fora do escopo inicial.

**Libvirt:** `virsh -c qemu:///system list --all` funcionou sem sudo. A rede `default` passou de inativa a ativa e foi marcada para iniciar automaticamente.

**Ubuntu:** VM instalada a partir de Ubuntu Server 24.04.3 LTS. Disco virtual de 25 GiB, LVM com raiz ~12 GiB e ~11,5 GiB livres no grupo. Hostname real `teste` e usuário `gui`. A interface `enp1s0` recebeu `192.168.122.223/24` por DHCP. `hostnamectl` mostrou `Virtualization: kvm`. Acesso SSH a partir do CachyOS foi confirmado pelo prompt `gui@teste:~$`.

**Incidente curto:** ISO não desmontou durante reinício; foi necessário retirar a mídia do CD-ROM virtual. A conta foi acessada após lembrar a senha. Houve dúvida de layout de teclado; correção permanente ainda não confirmada.

**Próximo passo:** verificar layout e serviço SSH, atualizar pacotes, reiniciar e reconectar; registrar evidências e prosseguir para autenticação por chave.

**Validação SSH complementar:** `ssh.service` ativo, porém desabilitado; `ssh.socket` ativo e habilitado. Este é o mecanismo de ativação por socket usado pelo Ubuntu 24.04; não foi necessário alterar as unidades. Reinício e reconexão ainda pendentes.

## 2026-09-25 — Atualização e reconexão

`apt update` encontrou 66 atualizações; `apt upgrade` aplicou 66 e instalou dois novos pacotes. A configuração de teclado ficou US (`XKBLAYOUT=us`). Um aviso do AppArmor apareceu, mas `dpkg --audit` não indicou pacotes pendentes e o serviço AppArmor continuou ativo. O servidor reiniciou, manteve o IP `192.168.122.223` e a conexão SSH do CachyOS foi refeita com sucesso. Na entrada, mostrou Ubuntu 24.04.5 LTS e zero atualizações imediatamente disponíveis.

**Aprendizado:** cada sessão SSH aberta dentro de outra exige um `exit` próprio; o prompt `gui@teste` isolado não distingue conexão vinda do host de sessão local na VM. Confirmamos a reconexão começando no terminal do CachyOS.

## 2026-09-25 — Chave SSH

O autor gerou um par Ed25519 dedicado no CachyOS (`~/.ssh/homelab_ubuntu` e arquivo `.pub`), instalou a chave pública para `gui` com `ssh-copy-id` e acessou `gui@192.168.122.223` com `ssh -i`. A sessão pediu a passphrase da chave e terminou no prompt `gui@teste:~$`. Teste de autenticação por chave concluído. A chave privada não foi compartilhada e não faz parte do repositório.

## 2026-09-26 — Windows 11 instalado

O autor iniciou o instalador pela ISO `Win11_25H2_Portuguese_x64_v2.iso`. Na configuração da VM `win11`, observou-se Q35, UEFI, disco SATA de 80 GiB e TPM emulado 2.0 (CRB). O Windows chegou à área de trabalho. `ipconfig` mostrou `192.168.122.235/24` com gateway `192.168.122.1`. Quatro respostas em quatro tentativas ao ping do gateway, sem perdas. Versão exata e RAM/CPU ainda pendentes de verificação.

## 2026-09-26 — Diagnóstico e comunicação entre VMs

Ao tentar conectar por SSH, o host recebeu `No route to host` e o ping informou destino inalcançável. `virsh -c qemu:///system list --all` mostrou `ubuntu24.04` desligada e `win11` executando. Após iniciar o Ubuntu, a concessão DHCP indicou `192.168.122.223/24` para `teste`; a conexão SSH do host voltou a funcionar.

Com ambas ligadas, o PowerShell do Windows executou `tnc 192.168.122.223 -p 22`: `SourceAddress : 192.168.122.235` e `TcpTestSucceeded : True`. Isso verifica o caminho TCP do Windows até o SSH do Ubuntu. Ping entre convidados, autenticação SSH originada do Windows, DNS, internet e memória com ambas em execução ainda não foram medidos.

## 2026-09-26 — DNS, memória e servidor web

Com as duas VMs ligadas, o host mostrou 15 GiB de RAM total, 10 GiB usados e 4,7 GiB disponíveis; swap usada de 820 MiB. No Windows, `nslookup ubuntu.com` retornou endereços via `192.168.122.1`, e o autor confirmou que o site abriu por HTTPS.

Nginx instalado no Ubuntu e confirmado ativo. O Windows abriu a página padrão por HTTP, com registro `GET /` de `192.168.122.235` e status 200. O autor confirmou parada, recuperação e retorno automático após reiniciar o Ubuntu. A página foi personalizada e a captura adicionada às [anotações do Nginx](04-nginx.md).

## 2026-09-26 — Backup e monitoramento concluídos

Backup HTML criado no Ubuntu e transferido ao CachyOS com hashes iguais. Restauração local confirmada visualmente. Monitor HTTP executado no host detectou queda às 13:35:15 e recuperação às 13:35:40. Procedimentos e limites registrados em [backup e monitoramento](05-backup-monitoramento.md).

## Modelo para as próximas sessões

- Data:
- Objetivo:
- Ambiente e versões:
- Comando executado e motivo:
- Resultado esperado:
- Resultado observado:
- Evidência (caminho relativo):
- Decisão e justificativa:
- Aprendizado nas minhas palavras:
- Próximo passo:
