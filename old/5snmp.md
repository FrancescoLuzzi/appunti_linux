SNMP (Debian-snmp ALL=NOPASSWD:/usr/bin/program) {se non sai il path del programma ~which program}
Standardizza il modello dei dati e di interazione (UDP, utilizzabile eterogeneamente)

Si identifica qualsiasi oggetto concreto, proprietà di un oggetto, o concetto astratto tramite un Object IDentifier (OID).
In una gerarchia globale che nasce da una radice anonima ".", i nodi hanno un identificativo numerico e uno simbolico (es. 1.3.6.1 == iso.identified-organization.dod.internet)
Se in /etc/snmp/snmp.conf non ci caricano i mib (mib:) l'output è puramente numerico(-On)

Managed Information Base(MIB) è la collezione degli oggetti gestiti 
    – da un apparato
    – da un sistema di monitoraggio

MIB è una collezione gerarchica di OID riguardante qualsiasi tipo di informazione

È in sostanza un catalogo che associa ad ogni oggetto
    – un OID
    – una sintassi (tipo di dato)(SMI)
    – una codifica (descrizione della rappresentazione materiale per rendere possibile la comunicazione tra architetture diverse)

Ogni entità interessata a descrivere le proprietà rilevanti in un certo contesto può definire un MIB,
attraverso una struttura gerarchica di dati (struttura tassonomica).

Il modello dei dati: SINTASSI (SMI) {hanno una complessità predefinita non è arbitraria}

Le sintassi supportate (SMIv1, SMIv2) sono:
– simple data types
    • interi a 32 bit con segno
    • stringhe di byte (lunghezza massima 65.535)
    • OID
– application-wide data types
    • network addresses: come IPv4, come generiche stringhe di byte
    • counters: interi a 32/64 bit positivi e crescenti, con rollover a zero
    • gauges: interi non negativi con limiti minimo e massimo
    • time ticks: centesimi di secondo trascorsi da un dato evento
    • opaques: stringhe arbitrarie senza controllo di sintassi
    • integers: ridefiniscono gli interi per avere precisione arbitraria
    • unsigned integers: come sopra ma senza segno
    • bit strings: stringhe di bit singolarmente identificati

Scalari e tabelle (array bidimensionali) sono le uniche strutture dati supportate in SMI

Tre varianti sintattiche dell'OID
– Un OID rappresenta in astratto il nodo dell'albero (posizione dello scalare o della tabella)
– Se una proprietà è scalare, es. il nome di un host (1.3.6.1.2.1.1.5)si aggiunge uno zero (1.3.6.1.2.1.1.5.0) 
per rappresentare l'istanza (a cui è associato il valore) -> .0 è questo l'OID su cui materialmente operare letture e scritture
– Se una proprietà è una tabella, es. le interfacce di rete (1.3.6.1.2.1.2.2.1) si aggiunge <.colonna.riga>
(es. .1.3.6.1.2.1.2.2.1.3.2) per individuare la cella -> è questo l'OID su cui materialmente operare letture e scritture

MIB notevoli
MIB-2, il modulo collocato sotto 1.3.6.1.2.1:
    -Gruppo system (1.3.6.1.2.1.1)
        ° sysDescr(1)
        ° sysContact(4)
        ° sysName(5)
        ° sysLocation(6)
    -Gruppo IP (1.3.6.1.2.1.4) {Risponde prima tutte le righe di una colonna poi cambia colonna e cosi via}
        ° 19 scalari
        ° 4 tabelle
        ° parametri generali del protocollo e tabelle con parametri specifici di ogni interfaccia, regola di routing, mappatura MAC
        ° es. tabella ifEntry (1.3.6.1.2.1.2.2.1)
        
Private Enterprise Numbers (PEN) sotto 1.3.6.1.4.1 è dedicato a moduli specifici
richiesti da enti privati (nel senso di non-ISO)
    -UCD-SNMP (1.3.6.1.4.1.2021)
        ° accesso ai parametri base di un S.O. (stato dischi, memoria, processi, carico, log…)
    –NET-SNMP-EXTEND-MIB (1.3.6.1.4.1.8072)
        ° output della direttiva extend
        ° permette di trasformare l'output di qualsiasi script in un managed object


I managed object sono le varie proprietà di un dispositivo, come finora descritte
- Il dispositivo prende il nome di network element
- Sul network element è in esecuzione un agent
    ° software/firmware che accede a memoria e registri dei dispositivi
    fisici per rendere visibili i loro contenuti sotto forma di managed object
    ° attraverso un protocollo di rete standard
- Il componente che accede agli agent è chiamato manager, tipicamente fa parte di un Network Management System(NMS)
- Il modello di interazione manager-agent è quindi simile ma non identico al modello client-server
    ° manager~client, agent~server, ma con numerosità e risorse hardware invertiti
    ° a volte l'agent prende l'iniziativa di contattare il manager

SNMP è un protocollo a livello applicativo
– trasportato su UDP
– agent~server in ascolto su porta 161 (10161 variante su TLS/DTLS)
– manager~client in ascolto su porta 162 (10162 variante su TLS/DTLS)

~NMS (Network Management System)
Si basa sulle informazioni date da SNMP (o simili) e rende disponibile
all'amministratore una piattaforma per:
    -organizzare l'inventario dei network element (gestione credenziali, ragruppamento per tipi...)
    -raccogliere i dati (polling vs pub-sub, archiviazione)
    -visualizzare i dati (es. reazioni a situazioni che necessitano attenzione, tipo guasto di un nodo)
Concetti base:
    -item (singolo dato da raccogliere) {può essere un OID preso da SNMP}
    -trigger(condizione valutata sull'item per far partire una action)
    -action (azione scatenata da trigger)
    -template (sono librerie di item,trigger e action predefinite) molto portabile
Sono comuni negli NMS:
    -interfacce grafiche
    -capacità di autoconfigurazione
    -Estendibilità per funzionalità aggiuntive

~snmpget -v 1 -c community{public|supercom} ip OID -> OID TYPE: value
~snmpwalk [-On] -v 1 -c community{public|supercom} ip OID
    -On output formatter: numerico {1.2.3.2...}
~snmpset -v 1 -c supercom ip OID s "valore"
~SETUP-SNMP: file SNMP-example

#funzioni per SNMP

#process_UCD_SNMP ip processo
#min, max, curr
function process_UCD_SNMP(){
    local INDICE=`snmpwalk -On -v 1 -c public $1 .1.3.6.1.4.1.2021.2 | egrep ".+2\.1\.2\..+$2" | cut -f1 -d " " | rev | cut -f1 -d . | rev` 
    snmpget -On -v 1 -c public $1 .1.3.6.1.4.1.2021.2.1.3.$INDICE
    snmpget -On -v 1 -c public $1 .1.3.6.1.4.1.2021.2.1.4.$INDICE
    snmpget -On -v 1 -c public $1 .1.3.6.1.4.1.2021.2.1.5.$INDICE
    }

#disk_UCD_SNMP ip path/disk
#dskUsed
function disk_UCD_SNMP(){
    local INDICE=`snmpwalk -v 1 -On -c public $1 .1.3.6.1.4.1.2021.9 | egrep ".+9\.1\.2\..+$2" | cut -f1 -d " " | rev | cut -f1 -d . | rev`
    snmpget -On -v 1 -c public $1 .1.3.6.1.4.1.2021.9.1.9.$INDICE
}

#load_UCD_SNMP ip min{1,5,15}
#laLoad, default 1
function load_UCD_SNMP(){
    local INDICE=1
    case "$2" in
    5) INDICE=2;;
    15)INDICE=3;;
    esac    
    snmpget -On -v 1 -c public $1 .1.3.6.1.4.1.2021.10.1.3.$INDICE
}


#get_EXTEND_MIB ip extend_fun
function get_EXTEND_MIB(){
    snmpget -On -v 1 -c public $1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"$2\" | cut -d= -f2 | sed 's/.*: //1'
}
ritorna VALUE
{possono essere usati con $() ritorna una stringa, o in pipeline}