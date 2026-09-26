# Etapa 1 — Preparação do host

Estado: validado no CachyOS pelo autor em 25/09/2026.

## O papel de cada componente

- KVM: recurso do kernel Linux que usa a virtualização da CPU.
- QEMU: fornece a máquina virtual e seus dispositivos; pode usar KVM para acelerar a execução.
- libvirt: gerencia VMs, redes e armazenamento por uma interface comum.
- virt-manager: interface gráfica para operar o libvirt.
- virsh: interface de terminal para o libvirt.
- dnsmasq: pode fornecer DHCP e DNS para as redes virtuais gerenciadas pelo libvirt.

## 1. Conferir recursos e KVM

Executar no terminal do CachyOS, um comando por vez:

```bash
lscpu
free -h
df -h / /home /var/lib
ls -l /dev/kvm
```

Registrar modelo da CPU, memória disponível e espaço livre nos locais candidatos aos discos virtuais. Se os caminhos estiverem na mesma partição, não somar o espaço livre. A existência de /dev/kvm é um primeiro sinal; a validação funcional vem depois da instalação.

Se /dev/kvm não existir, enviar a mensagem antes de avançar. Investigar firmware e módulos com base na CPU identificada.

## 2. Instalar a base

Após revisar os recursos:

```bash
sudo pacman -Syu --needed qemu-full libvirt virt-manager dnsmasq edk2-ovmf swtpm
```

`-Syu` atualiza o sistema e instala os pacotes; `--needed` evita reinstalar pacotes já atualizados. A atualização pode ser maior que apenas os componentes do laboratório. Revisar a transação antes de confirmar. Se houver conflito ou erro, guardar a saída e resolver antes de continuar. Não usar atualização parcial com `pacman -Sy`.

EDK II/OVMF fornece firmware UEFI; swtpm fornece TPM emulado para a configuração futura do Windows. Não habilitar um serviço dnsmasq global apenas por causa do laboratório: o libvirt gerencia sua instância de rede.

Se o kernel for atualizado, reiniciar antes da validação seguinte.

## 3. Ativar e validar o libvirt

Executar somente após a instalação bem-sucedida:

```bash
sudo systemctl enable --now libvirtd.socket
sudo virt-host-validate qemu
sudo virsh -c qemu:///system list --all
```

O socket permite iniciar o daemon quando um cliente solicita conexão. A conexão `qemu:///system` seleciona as VMs gerenciadas no sistema. Uma lista vazia, sem erro de conexão, é esperada antes de criar as VMs.

Analisar os avisos individualmente: IOMMU para passthrough e recursos de computação confidencial não são requisitos do escopo inicial. Falhas de KVM precisam ser resolvidas. Se a unidade não existir, coletar o erro e verificar as unidades instaladas; não misturar configurações de daemons sem diagnóstico.

## 4. Próxima sessão

Confirmar autenticação do virt-manager, inspecionar a rede com `sudo virsh -c qemu:///system net-list --all` e configurar NAT com base no estado real. Grupos, firewall e rede serão ajustados quando houver evidências de necessidade. O guia do CachyOS sugere ajustes de firewall; não aplicá-los indiscriminadamente a um host cujo firewall ainda não foi inspecionado.

## Critério de conclusão

- [x] Recursos registrados: Ryzen 5 5500, 15 GiB utilizáveis, 536 GB livres.
- [x] Ferramentas instaladas e operacionais; versões exatas pendentes de inventário.
- [x] Verificações essenciais de KVM aprovadas (`virt-host-validate qemu`).
- [x] Conexão `qemu:///system` funcional sem sudo.
- [x] Rede `default` ativa, persistente e com início automático.
- [x] Resultados registrados no diário.
