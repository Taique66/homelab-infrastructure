# Backup, restauração e monitoramento

## Backup da página — 26/09/2026

No Ubuntu, foi copiado `/var/www/html/index.html` para `/home/gui/backups/index.html.bak`. O comando `sha256sum` retornou o mesmo hash nos dois arquivos:

```text
b8a1ca8e28a6c5499bca770aeed92bfeff1786cdaa98e041fbfe91a806e01315
```

No CachyOS, o autor executou:

```bash
mkdir -p ~/homelab-backups
scp -i ~/.ssh/homelab_ubuntu gui@192.168.122.223:/home/gui/backups/index.html.bak ~/homelab-backups/
sha256sum ~/homelab-backups/index.html.bak
```

O arquivo transferido tinha 96 bytes e o mesmo hash. A página foi alterada para “Teste de recuperacao” e restaurada com:

```bash
sudo cp ~/backups/index.html.bak /var/www/html/index.html
```

O autor confirmou a recuperação e enviou uma captura mostrando “Homelab do Guilherme” novamente. A restauração usou a cópia interna do Ubuntu; a cópia no CachyOS foi transferida e validada por hash, mas não foi usada na restauração. Esse backup cobre apenas a página HTML, não a VM nem a configuração completa do Nginx. As duas cópias permanecem no mesmo computador físico.

## Monitor HTTP

O Windows alcançou a porta 80 do Ubuntu com `TcpTestSucceeded : True`. No CachyOS, um laço Bash consultou HTTP com curl e aguardou cinco segundos entre verificações. O autor parou e iniciou o Nginx no Ubuntu, observando:

| Horários no terminal do host | Resultado |
|---|---|
| 13:35:00, 13:35:05, 13:35:10 | OK |
| 13:35:15, 13:35:20, 13:35:25, 13:35:30, 13:35:35 | ALERTA |
| 13:35:40, 13:35:45 | OK |

Para executar a versão salva do monitor no host:

```bash
bash scripts/monitor-http.sh
```

O script preserva o laço testado e acrescenta verificação de curl e URL opcional. O alerta é uma mensagem no terminal; não há notificação externa, persistência após fechamento ou inicialização automática. Uma falha indica problema no acesso HTTP, sem determinar sozinha se a causa é rede, VM ou Nginx. O monitor não compara o conteúdo da página.
