# Etapa 3 — Windows 11 e rede

Estado: sistema instalado, acesso ao gateway e comunicação TCP com o Ubuntu validados em 26/09/2026.

## Configuração observada

- VM nomeada `win11` no virt-manager; chipset Q35 e firmware UEFI.
- TPM emulado, modelo CRB, versão 2.0.
- Disco virtual SATA de 80 GiB; ISO de instalação `Win11_25H2_Portuguese_x64_v2.iso`.
- Área de trabalho do Windows iniciou. Versão exata no convidado ainda pendente de `winver`.
- Em `ipconfig`, interface Ethernet recebeu `192.168.122.235`, máscara `255.255.255.0` e gateway `192.168.122.1`.
- `ping 192.168.122.1` enviou 4 pacotes, recebeu 4, com 0% de perda.
- No PowerShell do Windows, `tnc 192.168.122.223 -p 22` retornou `SourceAddress : 192.168.122.235` e `TcpTestSucceeded : True`.

O gateway é o endereço do host na rede NAT do libvirt. Ambos os endereços podem mudar por DHCP. O teste TCP confirma que o Windows alcança a porta 22 do Ubuntu; não testa login SSH do Windows nem acesso à internet.

## Próximos testes

1. Com as duas VMs ligadas, verificar a memória disponível no host.
2. Verificar acesso externo e resolução DNS dentro de cada VM.
3. Registrar uma captura do teste TCP com dados pessoais ocultados, se necessário.

## Explicação para entrevista

"Criei duas VMs em KVM/libvirt na mesma rede NAT. Conferi endereço, máscara e gateway no Windows, testei o gateway com ping e usei `Test-NetConnection` para confirmar que o Windows alcança a porta SSH do Ubuntu."
