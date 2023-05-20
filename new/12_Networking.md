# 12.0 Networking

## 12.1 Informazioni sulle interfaccie

- `ip link show`, lista le interfacce collegate ed il loro MAC address
- `ip a`, lista le interfacce collegate, il loro MAC address e gli IP (v4 e v6) settati
- `nmcli device` (non sempre disponibile ⚠), lista le interfacce collegate
- `lspci`, si possono controllare le interfacce pci collegate (e quindi i nic)

## 12.2 Gestione IP e routing

Comando ~ip [a|r] (NON persistenti)

- sottocomando address (a) (questi comandi modificano la tabella di instradamento del sistema)
  - `ip a` visualizzazione
  - `ip a add <address>/<mask> dev <interface>` assegnamento indirizzo ip all'interfaccia
  - `ip a del <address>/<mask> dev <interface>` rimozione indirizzo ip per l'interfaccia
- sottocomando route (r) (serve a cambiare la tabella di instradamento del sistema)

  - `ip r` visualizzazione
  - `ip r add <dst_net>/<mask> via <gw_addr>` routing via gateway ->{ES `ip r add 10.2.2.0/24 via 10.1.1.254`}
  - `ip r add <dst_net>/<mask> dev <interface>` routing via device interface
  - `ip r del <address>/<mask>` rimozione instradamento/routing

- `nmcli` i comandi saranno persistenti in `/etc/NetworkManager/system-connections/<connection_name>.nmconnection`
  - `nmcli con add type ethernet con-name <name> ifname <device>`, dhcp by default\
  - `nmcli con add type ethernet ip4 <ip> gw4 <ip_gw> con-name <name> ifname <device>`, with static ip\
  - `nmcli con delete <name>`

Nel mondo Debian il file per configurare in modo statico IP address e regole di routing è `/etc/network/interfaces`

```conf
auto lo
iface lo inet loopback

auto eth0 # attiva con ifup -a o ifup eth0
iface eth0 inet static # con dhcp al posto di static, non serve altro. Con ipv4ll setup automatico mDNS/DNS-SD (169.254._._)
  address 10.1.1.1
  netmask 255.255.255.0 # se omesso, class-based
  # opzionalmente
  gateway 192.168.56.1 # uno solo, non per interfaccia

  #chiamato dopo ifup
  up /path/to/command arguments #eseguito dopo configurazione {ES up /sbin/ip r add 10.2.2.0/24 via 10.1.1.254}

  #chiamato dopo ifdown
  down /path/to/command arguments #eseguito dopo configurazione {ES down /sbin/ip r del 10.2.2.0/24 via 10.1.1.254}

```

Per applicare le modifiche `systemctl restart netorking.service`

I comandi `ifup <interface>` e `ifdown <interface>` servono ad attivare/disattivare l'interfaccia (in entrambi i comandi l'opzione `-a` attiva/disattiva tutte le interfaccie)
