~scp file_su_host las@192.168.56.201:/path_su_guest/ -> Copio su VM
~scp las@192.168.56.201:/path/file_su_guest file_su_host -> Copio da VM
~ssh-keygen -t rsa -b 2048
~ssh-copy-id user@ip
~ssh user@ip "comandi sulla macchina ospitante"
(es. shh user@ip "cat file" | grep ... >file
cat /tmp/file | ssh user@ip "cat > /tmp/file"
tar -cf - filenames| ssh ip_addr 'mkdir dati_client; cd dati_client; tar xf -')
~ssh -J ip_to_jump ip_final
~ssh -n ip @prende in stdin /dev/null

/etc/hostname è dove è presente in nome dell'host (client|server|router)
/etc/hosts è dove si trovano le corrispondenze {ip nomelogico}

NETWORKING

Comando ~ip [a|r] (NON persistenti)
~sottocomando address (a) (questi comandi modificano la tabella di instradamento del sistema)
– visualizzazione ~ip a
– assegnamento indirizzo ip all'interfaccia ~ip a add <address>/<mask> dev <interface>
– rimozione indirizzo ip per l'interfaccia ~ip a del <address>/<mask> dev <interface>
~ sottocomando route (r) (serve a cambiare la tabella di instradamento del sistema)
– visualizzazione ~ip r
– routing via gateway ~ip r add <dst_net>/<mask> via <gw_addr> ->{ES ip r add 10.2.2.0/24 via 10.1.1.254}
– routing via device interface ~ip r add <dst_net>/<mask> dev <interface>
– rimozione instradamento/routing ~ip r del <address>/<mask>

Configurazione "classica" Debian
File /etc/network/interfaces

## esempio tipico

auto eth0 # attiva con ifup -a
iface eth0 inet static # con dhcp al posto di static, non serve altro. Con ipv4ll setup automatico mDNS/DNS-SD (169.254._._)
address 10.1.1.1
netmask 255.255.255.0 # se omesso, class-based
– opzionalmente
gateway 192.168.56.1 # uno solo, non per interfaccia

#chiamato dopo ifup
up /path/to/command arguments #eseguito dopo configurazione {ES up /sbin/ip r add 10.2.2.0/24 via 10.1.1.254}

#chiamato dopo ifdown
down /path/to/command arguments #eseguito dopo configurazione {ES down /sbin/ip r del 10.2.2.0/24 via 10.1.1.254}

---

Per applicare le modifiche:
systemctl restart networking

Tool di monitoraggio

- Verifica di base della connettività
  ~ping <IP>

- Verifica del percorso dei pacchetti
  ~traceroute <IP>

Verifica dello stato delle connessioni (Da informazioni anche sulla connessione State/Recv-Q/Send-Q)
~ss
• -t / -u TCP/UDP only
• -l / -a stato LISTEN (il default è ESTABLISHED) / ALL
• -n non risolvere gli indirizzi/porte in nomi simbolici
• -p mostra processi che usano la socket
• -s summary statistics

~ss -npt
State Recv-Q Send-Q Local Address:Port Peer Address:Port Processes
ESTAB 0 0 192.168.56.201:22 192.168.56.1:49450 users:((\"sshd\",pid=745,fd=3),(\"sshd\",pid=720,fd=3))

{solitamente l'output ha una prima colonna che da il tipo di socket (tcp,udp,...)}

Intercettazione del contenuto dei pacchetti
~tcpdump <filtro>
-i INTERFACE, interfaccia su cui ascoltare
-v, verbose
-n, non conversione da ip a nome logico
-l, unbuffered
-p non promiscuous mode, solo interfaccia interessata
-(filtro)=~ tcp|udp and ((src (host|[net]) IP_SRC[/mask] and dst host IP_DST) or (src host IP_DST and dst host IP_SRC)) and '(tcp[tcpflags] & (tcp-syn | tcp-fin)) != 0' and (dst|src) port PORT_NUMBER

tcpdump -nl ->
#14:03:40.045962 IP 10.1.1.11.34774 > 10.2.2.2.ssh: Flags [F.], seq 1817785992, ack 3078262696, win 1115, options [nop,nop,TS val 1666738059 ecr 2920541746], length 0

RISOLUZIONE NOMI

La mappatura da nomi di host a indirizzi IP e viceversa è uno dei tanti casi in cui il
sistema ha bisogno di un dizionario di nomi.(NON FA LA CONVERSIONE, E' SOLO UN DATABASE LA CUI SORGENTE PUO' ESSERE UN DNS)
Questo dizionario di nomi è NSS, esso può avere un dns come sorgente dei dati oltre ai file può usere un DNS (caso di hosts)
Soluzione: NSS {Name Service Switch}
Svolta dalla libreria c di sistema e supporta un set fisso di possibili DB

configurata tramite /etc/nsswitch.conf
Sintassi di nsswitch.conf
– <entry> ::= <database> ":" [<source> [<criteria> ]]\*
– <criteria> ::= "[" <criterion> + "]"
– <criterion> ::= <status> "= " <action>
– <status> ::= "success" | "notfound " | "unavail" | "tryagain" {"risposta ricevuta"| "sorgente non sa rispondere"|"sorente non raggiungibile"|"sorgente occupata"|} | di default sono <status>::="success"
– <action> ::= "return" | "continue" | <action>::="return"

ES (NB, utile per il setup di utenti con ldap) /etc/nsswitch.conf
passwd: files nis ldap
group: files ldap
hosts: ldap [NOTFOUND=return] dns files ->{files, la sorgente di informazioni è il file /etc/hosts
dns, la sorgente di informazioni è il sistema DNS,
si configura attraverso /etc/resolv.conf lato Router}

Il comando getent permette di interrogare i database del NSS (getent passwd las)

DNS (dnsmasq)

Spesso si trova un server DNS locale (0.0.0.0:53) spesso UDP

Per interrogare direttamente il DNS e avere più controllo sulle query si usano tipicamente:
~host (tipicamente per conversioni IP <--> nome) e ~dig(tipicamente per ottenere informazioni legate a un
dominio diverse da nomi host):
– query di un nome: ~host www.unibo.it -> riponde con il suo ip
– query a un server specifico: ~host www.unibo.it 8.8.8.8 -> riponde con il suo ip richiedendo al dns 8.8.8.8
– conoscere i Mail eXchanger: ~dig mx www.unibo.it
– conoscere i Name Server: ~dig ns www.unibo.it

ZEROCONF ~DHCP
Standardizzare varie soluzioni presenti sul mercato per completare il quadro della configurazione automatica network.

Non si interessa del livello applicativo ma del livello 3 Rete(Routing):
-link-local addressing (ip)IPV4/6
-RFC 3927 Dynamic Configuration of IPv4 Link-Local Addresses, si riserva a questo scopo la classe 169.254/16 e
propone una serie di best practice per delimitare l’uso degli indirizzi link local
• non devono essere assegnati a interfacce che hanno indirizzi instradabili
• non devono essere distribuiti via DHCP
• non devono essere stabilmente associati a nomi DNS
-Meccanismo di assegnazione
entra in gioco solo se l’interfaccia non ha già un indirizzo assegnato staticamente o via DHCP, si
sceglie IP random nel range 169.254.1.0 – 169.254.254.255
con seme legato a caratteristica univoca (es. MAC address)
– riduce probabilità di conflitto
– tendenzialmente risulta in ri-assegnamenti stabili
– verifica che l’IP sia disponibile via ARP probe
– annuncio di acquisizione via gratuitous ARP

-multicast DNS, per la traduzione di nomi in indirizzi in reti locali senza avere una macchina dedicata (mDNS) porta 5353 [ha una gerarchia piatta, tutti partecipano allo stesso modo, diversamente da un DNS tradizionale]

-service discovery, basato su server DNS aggiornabile dinamicamente per registrare servizi(DNS-SD)

Server side, per configurazione ZEROCONF:
~dnsmasq {Su reti di piccole dimensioni dnsmasq è una scelta pratica per dhcp e dns}

~Configurazione generale DHCP con dnsmasq (nel file /etc/dnsmasq.conf)
– bind-interfaces
• evita conflitti in caso si vogliano usare più istanze di dnsmasq per diverse reti connesse al server
– interface=<interface name> {interface=eth1/2}
– listen-address=<ipaddr>
• mettono dnsmasq in ascolto solo sull’interfaccia o l’indirizzo specificati (anche più di una/uno)
– user / group / pid
• utente e gruppo UNIX del processo, file in cui salvare il PID
-dhcp-range=<start-addr>[,<end-addr>|<mode>],<netmask>[,<broadcast>]][,<lease time>] {DHCP è disabilitato di default se npn sono specificate opzioni}
{dhcp-range=10.1.1.10,10.1.1.20,12h}

-dhcp-host=[<hwaddr>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore {ignora l'host specificato non offrendo mai un lease}]
{dhcp-host=MAC,router,10.1.1.254,10.2.2.254,12h}

-dhcp-option=[<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
{
dhcp-option=121,(ROTTA PER CLIENT)10.2.2.0/24,10.1.1.254, (ROTTA PER SERVER)10.1.1.0/24,10.2.2.254
dhcp-option=3 #default gateaway
dhcp-option=option:dns-server,ip,ip2
}

~Risoluzione indirizzi, DNS con dnsmasq:(nel file /etc/dnsmasq.conf) {/etc/resolv.conf}
Non è un resolver ricorsivo, deve appoggiarsi a uno esterno, di default prende gli indirizzi dei nameserver upstream da /etc/resolv.conf.
Plug-in su sistemi che sono già configurati, il file è aggiornato da dhcp, ppp, ecc., dnsmasq si accorge automaticamente delle modifiche.
Lo si può usare anche localmente con il vattaggio del caching {/etc/resolv.conf -> nameserver 127.0.0.1}
I server upstream possono (devono per uso locale) essere specificati:
-con resolv-file=<file>
• sopprime l’uso di /etc/resolv.conf
– con server=[/<domain>/]<ipaddr>
• per evitare l’uso di /etc/resolv.conf si deve aggiungere no-resolv

-Lato client – DHCP

Il pacchetto isc-dhcp-client fornisce il comando dhclient

## Tipicamente avviato da /etc/network/interfaces con

auto <ifname>
iface <ifname> inet dhcp

---

Parametri impostabili in /etc/dhcp/dhclient.conf

Il pacchetto ~sudo apt install avahi-autoipd fornisce il comando omonimo
– implementa IPv4 Link Local
/etc/network/interfaces

---

auto <ifname>
iface <ifname> inet ipv4ll

---

- /etc/avahi/avahi-autoipd.action
  Può essere usato come fallback se DHCP fallisce (plugin per dhclient)

~AVAHI
Il framework avahi può fornire
– uno stack completo mDNS/DNS-SD con API per l’integrazione delle funzionalità in qualsiasi programma C
– un demone per gestire le registrazioni di nuovi servizi in modo orchestrato da qualsiasi programma non scritto in C, via D-Bus
– un client/wrapper C che semplifica l’utilizzo di D-Bus
– adattatori per integrare le API di avahi negli event loop dei sistemi grafici come GNOME e KDE
Il demone è responsabile ad esempio della scoperta automatica di stampanti in una rete locale
Sono disponibili pacchetti con strumenti per svolgere funzioni singole specifiche

~NTP (UTILIZZATO PER LA SINCRONIZZAZIONE)
L'allineamento dell'ora di un sistema ad un orologio di riferimento è cruciale
– per la diagnostica dei problemi (timestamp su log)
– per i protocolli di autenticazione e autorizzazione (i messaggi hanno una vita limitata)
– per la sincronizzazione di azioni distribuite
– per il valore legale di azioni compiute attraverso i computer

NTP è un protocollo che compensa i ritardi di rete con informazioni precisissime.

Su linux ci sono diverse possibilità:
Client side:
– Avahi (link-local, mDNS, DNS-SD)
– ISC dhcp
– systemd.network (ogni possibile modo di configurare la rete, incluso linklocal)
– systemd-resolved (DNS/mDNS resolver, sostituisce resolvconf)
– ntpd / ntpdate
Server side
– dnsmasq (DHCP, DNS) e inoltre:
• PXE: erogazione di Pre-boot eXecution Environment per l’avvio di sistemi diskless
• TFTP: Trivial FTP, utilizzato dall’ambiente PXE per il caricamento da remoto di immagini di sistema
– systemd.dnssd (DNS-SD)
– ntpd

Il demone ntpd è client e/o server in funzione della configurazione /etc/ntp.conf

Parallelamente il comando ~ntpdate ip_server permette di sincronizzare l'orologio locale sporadicamente quando:(QUESTO COMANDO NON RIMPIAZZA NTPD)
-ntpd non è in esecuzione
-senza parametri si appoggia su /etc/ntp.conf
L'ora viene modificata in due modi
– se la differenza è più di 0.5 secondi: step
– se la differenza è meno di 0.5 secondi: slew con adjtime()

mDNS
L’associazione nomi-indirizzi viene gestita secondo la RFC 6762 Multicast DNS
-.local. sia riservato a host appartenenti a una rete link-local, tali richieste devono essere mandate in multicast 224.0.0.251:5353
-prevede la possibilità di mantenere aperte le connessioni per aggiornamenti su tutte le nuove risorse

DNS-SD
La rilevazione automatica di servizi disponibili in rete segue la RFC 6763 DNS-Based Service Discovery.
Stabilisce un formato di entry DNS per descrivere la collocazione in rete, i protocolli applicativi ed eventuali
parametri da utilizzare.

SLAAC
-IPv6 non utilizza ARP ma ha sistemi più complessi e flessibili per individuare
indirizzi liberi o utilizzati e determinare se la rete locale è anche raggiungibile dall’esterno
-StateLess Address AutoConfiguration (RFC 4862 e aggiornamenti) è un
algoritmo per costruire indirizzi link-local se possibile validi globalmente prima di richiedere al DHCPv6
