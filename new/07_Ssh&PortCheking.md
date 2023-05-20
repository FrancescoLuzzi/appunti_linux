# 7.0 Ssh&PortCheking

## 7.1 Controllo porte utilizzate da servizi

### Netstat

`apt install net-tools`\
`netstat -tapun` comando per controllare porte in utilizzo con formattazione

### SS

`ss`

- `-t` TCP only
- `-u` UDP only
- `-l` stato LISTEN (il default è ESTABLISHED) / ALL
- `-a` stato ALL
- `-n` non risolvere gli indirizzi/porte in nomi simbolici
- `-p` mostra processi che usano la socket
- `-s` summary statistics

## 7.2 SSH

- porta default 22
- di default impossibile loggarsi come `root`
- consigliato l'utilizzo di chiavi asincrone rsa 2048 bit (generabili con il comando `ssh-keygen`)
- client `ssh` è sempre disponibile
- server si può:
  - installare con `apt install openssh-server`
  - abilitare con `systemctl enable sshd && systemctl restart sshd`

Formato comando ssh `ssh user@[ip|hostname] -p port -i /path/to/key`

Quando mi collego ad un serve salvo la sua fingerprint dentro `$HOME/.ssh/known_hosts`, per ogni riga un figerprint.\
Se la macchina a cui mi connetto cambia fingerprint, `ssh` bloccherà la connessione con un messaggio di errore; cancellare la fingerprint risolve l'errore.

Per connettersi usando la chiave ssh:

- crea la coppia chiave privata e pubblica, usando `ssh-keygen`
  - `$filename.pub` chiave pubblica da copiare sui server
  - `$filename` chiave privata da tenere sul proprio host (da difendere con la vita!)
- copia il contenuto della chiave pubbica dentro il server a cui voglio connettermi:
  - copiando in append il contenuto del file dentro `$HOME/.ssh/authorized_keys`
    - `scp ~/.ssh/id_rsa.pub user@ip:/home/user/` su client
    - `cat id_rsa.pub >>~/.ssh/authorized_keys` su server
  - usando il comando `ssh-copy-id user@ip`
- fai reload del deamon ssh sul server `systemctl restart sshd`

Il file di configurazione del **client ssh** è `/etc/ssh/ssh.config`, il cui formato è:\
_per maggiori info `man ssh_config`_

```bash
Host <name1> <name2>
HostName ip
Port port
User username
IdentityFile /path/to/private_key
Compression yes
ForwardAgent yes
ProxyJump user@<jumpserver>

Host name3
...
```

Il file di configurazione del **server ssh** è `/etc/ssh/sshd.config`, il cui formato è:\
_per maggiori info `man sshd_config`_

```bash
Port 2222
...
```

## 7.3 /etc/hosts

File che funge da "DNS locale", questo ha la precedenza rispetto al DNS vero e proprio

```bash
$ sudo cat /etc/hosts
127.0.0.1 localhost
127.0.0.1 machine_name
ip_addr hostname
```
