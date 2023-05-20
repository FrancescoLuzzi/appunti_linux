UTENTI E FILES (BISOGNA ESSERE AMMINISTRATORE O ROOT per cui o usi sudo o ti logghi come root)
Ogni utente deve appartenere a un gruppo e può appartenere a un numero arbitrario di
gruppi supplementari. Durante una sessione di lavoro può assumere l'identità di un solo gruppo.

Le credenziali locali sono in
– /etc/passwd, world-readable, una riga per utente:
    prandini:x:500:500:Marco Prandini:/fat/home:/bin/bash {il segnaposto 'x' serve ad indicare di andare a vedere la password in shadow}
– /etc/shadow, accessibile solo a root, linee corrispondenti a passwd ~getent passwd
    prandini:$1$/PBy29Md$kjC1F8dvHxKhnvMTWelnX/:12156:0:99999:7:::

~useradd NOME
    – m crea la home del utente, usa come template i files dentro /etc/skel
    – s assegna la shell all’utente, le possibili shell sono indicate dentro il file /etc/shells, altrimenti prende il default{/bin/bash}
    – U crea un gruppo con lo stesso nome dell’utente
    – K con questo parametro è possibile specificare la UMASK=0077 {toglie privilegi a G ed O}
    – p dopo questo parametro è possibile inserire la password utente MA è sconsigliato, molto meglio usare ~passwd NOME separatamente
    – G posso assegnare l’utente all’atto della creazione ad un gruppo supplementare {esempio sudo}

ESISTE LO SCRIPT ANALOGO IN PERL ~adduser, non standard in tutte le distro

~userdel NOME
    -r delete also home dir

Cambiare password Utente:
~ passwd USERNAME

Aggiungere un gruppo
~groupadd NOME

ESISTE LO SCRIPT ANALOGO IN PERL ~addgroup, non standard in tutte le distro

Modificare info dei un'accunt
~usermod USERNAME
    -aG append al gruppo l'user {-aG GROUP USER}
    -g group
    -md sposta il contenuto della home in una dir e la rende predefinita
    -s cambia la shell dell'utente

~chsh USERNAME modifica della shell di login

~chfn USERNAME modifica del nome reale

Il file shadow contiene dati sulla validità temporale della password, esaminabili e modificabili con chage.
Si possono consultare con:
~chage -l USERNAME

Altri comandi utili:
    ~gpasswd [-a USERNAME, -d USERNAME, -r] GROUPNAME{-a aggiungi user al gruppo, -d elimina user dal gruppo, -r rimuovi password}, modifica password e lista utenti di un gruppo
    ~getent <db name> <keyword>, interroga il db utenti o gruppi (ES getent passwd las, getent hosts las)
    ~last, elenca i login effettuati sul sistema {last -p -Nmin  stampa utenti presenti Nminuti fa}
    ~lastlog, mostra la data di ultimo login di ogni utente {lastlog -S DAYS}
    ~faillog, mostra i login falliti sul sistema

Per cambiare identità di gruppo si usa:
~newgrp GROUPNAME

Far partire un comando con identità di un'altro:
~su -c /path/comando USERNAME
loggarsi come un'altro account {caricando il suo file ~/.bashrc}
~su -l USERNAME

OWNERSHIP
- Comando ~chown [new_owner:new_group|new_owner] <file> modifica owner e/o group owner del file
– Comando ~chgrp [new_group] <file> modifica group owner del file
Per entrambi l’opzione -R attiva la ricorsione su sotto-cartelle

{SUID SGID STICKY U{rwx} G{rwx} O{rwx}}
chmod è usato per modificare i permessi
– Modo simbolico: ~chmod 'a=r,g-rx,u+rw,o-x' file
~chmod +x file == chmod 'a+x' file
– Modo numerico (base ottale): 
~chmod 2770 miadirectory
    • 2770 octal = 010 111 111 000 binary = !SUID SGID !STICKY rwx rwx ---
~chmod 4555 miocomando
    • 4555 octal = 100 101 101 101 binary = SUID !SGID !STICKY r-x r-x r-x

~umask nnn {nnn sono i permessi UGO da togliere!!!} si può interrogare e settare interattivamente nella sessione
corrente, per rendere persistente la scelta si usano i ~/.bashrc.

In Linux, le estensioni dei nomi hanno come unico utilizzo quello di renderli più leggibili all’utente.
Si può ottenere manualmente l’identificazione con 
~file [-b output solo tipo] /path/to/file 


~dd if=NAME of=NAME bs=SIZE{4k} count=COUNT{16k}
dd permette di leggere byte da qualsiasi file (if=<NOME>) e scrivere su qualsiasi file (of=<NOME>)
    {se NOME == - si intende STDIN (per if) o STDOUT (per of)}
Può eseguire trasformazioni di formato e tracciare il progresso del trasferimento

~find ricerca in tempo reale di file
~find START_DIR 
    -name NAME 
    -type TYPE {d dir, f regular file}
    -size SIZE {100k,12B,...}{+n maggiore n,-n minore n, n per dim ==n }
    -user OWNER 
    -print(print a STDOUT) 
    -atime GG_DA_ULTIMO_ACCESSO (int) {+n maggiore n,-n minore n, n per dim ==n }
    -mtime GG_DA_ULTIMA_MODIFICA (int) {+n maggiore n,-n minore n, n per dim ==n }
    -o (OR)
    -a (AND)
    -not o \!
    -exec comando {} \; {} è il placeholder per il valore del path di ogni file
    -perm -nnn{permessi nnn o più} oppure u+rwx,g+rwx,a+rwx,o+rwx

Archiviazione di file
{approfondimento, in origine tar serviva a creare gli archivi da salvare sui dischi a nastro -Tape ARchive-
unico modo per caricare dati sui suddetti dischi}

~tar  filenames(es /home/*)
    -c crea un nuovo archivio
    -x estrae file da un archivio
    --delete cancella file da un archivio
    -f <FILENAME> viene quindi sempre usata per specificare un file di archiviazione
        !!!{FILENAME può essere "-" in per indicare
                • lo standard input da cui leggere un archivio con -d, -t, -x
                • lo standard output su cui scrivere l’archivio con -c}
    -T <ELENCO> prende i nomi dei file da archiviare da FILE invece che come parametri sulla riga di comando
    -v stampa i dettagli durante l’esecuzione

    -z usa gzip per comprimere (estensione .tar.gz o .tgz)
    -j usa bzip2 per comprimere (estensione .tar.bz2 o .tbz2)
    -J usa xz per comprimere (estensione .tar.xz o .txz)

    -t elenca il contenuto di un archivio

    -A concatena più archivi
    -d trova le differenze tra archivio e filesystem
    -r aggiunge file ad un archivio
    -u aggiorna file in un archivio
    -p (preserve) conserva tutte le informazioni di protezione
    -C <DIR> svolge tutte le operazioni come dopo cd DIR per decidere dove voglio scompattare un archivio

ES:
    tar -cf - filenames| ssh ip_addr 'mkdir dati_client; cd dati_client; tar xf -'
    tar -f file -c{z|j|J} filenames
Compressione File

~gzip comprime in .gz
~bzip2 comprime in .bz2
~xz comprime in .xz
    -d decomprime ricreando il file e rimuovendo l’estensione
    -c riversa il risultato su STDOUT invece che su file

~gunzip decoprime .gz
~bunzip2 decomprime .bz2
~unxz decomprime .xz