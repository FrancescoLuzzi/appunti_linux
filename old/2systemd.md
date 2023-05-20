SYSTEMD TERMINI

In prospettiva integrato in systemd è Journal.
Attivo dal boot, non dipende dall’avvio di altri servizi (è il primo e si apre prima di syslog). Formato binario, visualizzabile con journalctl

~systemctl {start|stop|status|restart|reload} servicename
Le operazioni sono volatili ed immediate, si può vedere il service up senza nessun processo che gira.

Per automatizzare avvio al boot e arresto allo shutdown si utilizzano invece
~systemctl {enable|disable|mask|unmask} servicename
• disable lascia disponibile la possibilità di usare manualmente start
• mask "neutralizza" l'intera definizione della unit, impedendo anche il controllo manuale
-questi comandi non hanno alcun effetto immediato e l’effetto sulla configurazione del sistema è persistente

Diversi tipi di [control unit] i cui nomi seguono la convenzione
name.type che può essere:
– Service: controllo e monitoraggio dei demoni
– Socket: attivazione di canali IPC di ogni tipo (file, net socket, Unix socket)
– Target: gruppo di unit che rimpiazza il concetto di runlevel
– Device: punti di accesso ai dispositivi, creati dal kernel in seguito ainterazioni con l'hardware
• filesystem-related: Mounts, Automounts, Swap
– Snapshots: stato salvato del sistema
– Timers: attività legate al tempo (cron, at)
– Paths: monitoraggio del contenuto di una directory via inotify
– Slices: gestione delle risorse via cgroup
– Scopes: raggruppamento di processi per miglior organizzazione

NELLA DIR /lib/systemd/system/ si possono mettere nuovi file di configurazione:
ES
/lib/systemd/system/prova.service

---

[Unit]
Description= Descrizione
Requires= da chi dipende questa unit (nome.service|rsyslog.service)
Documentation= es. man:rsyslogd(8) o URL o altro
Conflicts= vincolo negativo per rendere unit mutuamente esclusive
OnFailure= unit da avviare quando questa fallisce
DefaultDependencies=no

    [Service]
    Type= tipo di avvio {simple}
    ExecStart= comando da lanciare all’avvio di setup
    ExecStop= comandi (opzionali) per stop di cleanup
    Restart= reazione (opzionale) {always}
    ExecReload=kill -HUP $MAINPID (opzionale)
    PIDFile= path/to/file (opzionale per FORKING type)
    TimeoutStartSec=5min {startup service dopo 5 minuti avvio sys}
    RemainAfterExit=yes {consideriamo il service attivo all'uscita positiva di ExecStart per ONESHOT, SIMPLE E IDLE}

    [Install]
    RequiredBy= chi dipende da questa unit
    WantedBy= multi-user.target
    --------------------------

AGGIORNARE UNA CONTROL UNIT IN SYSTEMD

~systemctl daemon-reload
~systemctl enable file.service
~systemctl start file.service

TYPE:
~Type=simple (default) - systemd considera il servizio avviato con successo non appena ha forkato un
processo figlio per eseguire il comando ExecStart (anche se poi tale comando
dovesse fallire!). Il processo non deve forkare. Non usare questo tipo se altri
servizi devono essere ordinati da questo servizio, a meno che siano attivati
tramite socket.(RemainAfterExit=yes)
~ Type=forking
– systemd considera il servizio partito una volta che il processo avviato con
ExecStart esegue una propria fork e il genitore esce. È tipicamente usato per
riutilizzare un “classico” demone Unix. È raccomandabile usare l’opzione
PIDFile= path/to/file affinchè systemd possa tracciare il processo principale.
~ Type=oneshot
– utile quando abbiamo uno script/job da lanciare una volta sola e poi uscire. Si
può settare (RemainAfterExit=yes) così che systemd possa considerare il
servizio come attivo dopo la sua uscita.
~ Type=notify
– Identico a Type=simple, ma systemd si aspetta che quando il servizio è
effettivamente pronto gli mandi un segnale via sd_notify(3) o simile
~ Type=dbus
– il servizio è considerato ready quando uno specifico BusName compare nel Dbus.
~ Type=idle
– systemd rimanderà l’avvio di servizi di questo tipo (per max. 5 secondi) fino a
che tutti gli altri jobs saranno smistati. Oltre a questo non cambia molto con
Type=Simple ed è unicamente utile per “tenere in ordine” i messaggi su console

SERVICE RESTART

| \\ Exit causes</br>&nbsp; \\--------------\\</br>Restart settings \\ | Clean exit code or signal | Unclean exit code | Unclean signal | Timeout | Watchdog |
| -------------------------------------------------------------------- | ------------------------- | ----------------- | -------------- | ------- | -------- |
| no                                                                   |                           |                   |                |         |          |
| always                                                               | x                         | x                 | x              | x       | x        |
| onsuccess                                                            | x                         |                   |                |         |          |
| onfailure                                                            |                           | x                 | x              | x       | x        |
| onabnormal                                                           |                           |                   | x              | x       | x        |
| onabort                                                              |                           |                   | x              |         |          |
| onwatchdog                                                           |                           |                   |                |         | x        |
