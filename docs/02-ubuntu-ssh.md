# Etapa 2 — Ubuntu Server e SSH

Estado: instalado e acesso SSH confirmado pelo autor em 25/09/2026.

## Ambiente observado

| Item | Valor |
|---|---|
| Convidado | Ubuntu Server instalado a partir de 24.04.3 LTS; após atualização mostra 24.04.5 LTS |
| Hostname / usuário | `teste` / `gui` |
| Recursos | 2 vCPUs planejadas, 2 GiB de RAM observados, disco VirtIO de 25 GiB |
| Volume `/` | LVM ext4, aproximadamente 12 GiB; 4,7 GiB usados e 6,1 GiB disponíveis na verificação |
| Interface | `enp1s0`, IP `192.168.122.223/24` na rede NAT `default` |
| Acesso | SSH do CachyOS para `gui@192.168.122.223` com senha e depois com chave Ed25519 funcionou |
| Inicialização SSH | `ssh.socket`: `active` e `enabled`; `ssh.service`: `active` e `disabled` |

O endereço veio por DHCP e pode mudar após reiniciar. O IP visto no terminal do host (`192.168.100.55/24`) pertence à rede física e tem outro papel. A linha `Virtualization: kvm` de `hostnamectl` confirma o convidado executado sobre KVM.

## Como repetir o teste

Deixar a VM ligada; no host CachyOS, verificar o endereço atual na VM com `ip -br a` e executar:

```bash
ssh gui@192.168.122.223
```

Na primeira conexão, comparar a impressão digital do host SSH com a chave apresentada pelo servidor antes de confiar nela; após a validação, a chave é registrada em `known_hosts`. O teste desta sessão confirmou login remoto, mas a comparação independente da impressão digital não foi documentada. A senha é digitada sem eco. `exit` encerra a sessão SSH.

Dentro da sessão, usar comandos separados:

```bash
hostnamectl
ip -br a
df -h /
free -h
```

Esses comandos responderam, respectivamente, qual sistema está em uso, qual IP pertence à VM, quanto espaço há na raiz e quanto de RAM/swap foi atribuído. Foi observada memória total de 1,9 GiB, 329 MiB em uso e 2 GiB de swap. O servidor avisou que há atualizações disponíveis; aplicação e reteste ainda pendentes.

O Ubuntu 24.04 usa ativação por `ssh.socket` por padrão. O socket habilitado recebe novas conexões e inicia o serviço quando necessário. Por isso `systemctl is-enabled ssh` responder `disabled` não significa falha neste ambiente: o par `ssh.socket` ativo/habilitado e o acesso remoto bem-sucedido confirmam a configuração. Fonte: [notas de lançamento do Ubuntu 24.04](https://documentation.ubuntu.com/release-notes/24.04/).

## Ocorrências e aprendizados

- A ISO ficou conectada ao CD-ROM virtual ao reiniciar; a tela solicitou remover a mídia. Ela foi desconectada do CD-ROM SATA, preservando o disco VirtIO.
- Houve dúvida com usuário/senha e disposição do teclado. O menu de recuperação foi acessado, mas a senha foi lembrada e o login normal funcionou. Não há evidência de troca de senha.
- O layout de teclado americano no console da VM ainda deve ser verificado/corrigido. A sessão SSH facilita copiar e colar no terminal do host.
- Os erros `fhostnamectl` e `hostnamectlip` vieram da digitação/colagem; `hostnamectl` e os demais comandos funcionaram quando executados separadamente.

## Atualização e teste de reinício

`sudo apt update` encontrou 66 atualizações. `sudo apt upgrade` atualizou esses 66 pacotes e instalou dois novos. O pacote `keyboard-configuration` pediu o layout; o arquivo `/etc/default/keyboard` mostrou `XKBMODEL="pc105"` e `XKBLAYOUT="us"`. Um aviso do script de instalação do AppArmor apareceu, porém `sudo dpkg --audit` não retornou pendências e `systemctl is-active apparmor` respondeu `active`.

Após `sudo reboot`, a VM voltou com `192.168.122.223/24`. O autor saiu de sessões SSH aninhadas com `exit` duas vezes e reconectou a partir do CachyOS com sucesso. A mensagem de login passou a indicar Ubuntu 24.04.5 LTS e zero atualizações imediatamente disponíveis. O teste direto do host após reinício concluiu a etapa de acesso remoto.

## Chave SSH

No CachyOS foi criado um par de chaves Ed25519 dedicado ao laboratório: privada em `~/.ssh/homelab_ubuntu`, pública em `~/.ssh/homelab_ubuntu.pub`. A pública foi adicionada à conta `gui` por `ssh-copy-id`. O teste `ssh -i ~/.ssh/homelab_ubuntu gui@192.168.122.223` pediu a passphrase local da chave e abriu sessão no Ubuntu. A chave privada e sua passphrase não devem entrar no GitHub.

O servidor guarda a chave pública para verificar a prova apresentada pelo cliente que detém a privada. A passphrase protege a cópia privada no host; ela não é a senha do usuário Ubuntu. A autenticação por senha ainda está disponível e não foi desativada.

## Próximo exercício

Registrar uma captura sanitizada e praticar um serviço Linux com diagnóstico; depois criar a VM Windows para testar a comunicação entre convidados.
