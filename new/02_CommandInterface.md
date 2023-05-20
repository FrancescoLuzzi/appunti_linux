# 2.0 CommandInterface

Premendo Ctrl+Alt+F[2-7] si apre una shell senza Desktop enviroment.
Premendo Ctrl+Alt+F1 si apre il Desktop enviroment.

## 2.1 Shell

Ci sono diverse programmi di interazione da linea di comando:

- sh
- bash
- rbash
- dash
- zsh

Per consultare la lista completa di shell installate nel sistema consultare il file `/etc/shells`

## 2.2 Comandi

Tipologie di comandi:

- interni (builtin) fanno parte della shell stessa e sono programmi separati
- esterni, risiedono in singoli file, sono file o script binari, questi file vengono ricercati nelle cartelle specificate nella variabile di ambiente **$PATH**

Struttura di un comando: `cmd -<short_option> --<long_option> parameter`

Spesso i comportamenti di default possono essere modificati andando a cambiare il file corrispondente in `/etc/default`

Comandi utili:

- `apt`, package manager per installare/modificare/eliminare pacchetti precompilati
- `touch`, apre e chiude un file, utile per cambiare ultima data di accesso/modifica, se il file non esiste lo crea
- `cp`, copia uno o più file
  - `a`, cerca di mantenere permessi ed ownership instatti
- `watch` ripete il comando passato come parametro ogni 2 secondi
  - `-n` specidica intervallo in secondi (`.` e `,` supportati)
  - `-d` mette in risalto le diferenze tra le diverse esecuzioni
- `chmod`, cambia i permessi del file\
  Due modalità di utilizzo:

  - **UGO char mode**
    - `u|g|o`, cambio i permessi a user|group|other
    - `+`, aggiungi permessi
    - `-`, rimuovi permessi
    - `r|w|x`, permessi da aggiungere
    - esempio:
      - `ugo-x`
      - `o+r`
  - **octal mode**

    - `UGO`, per ogni lettera di UGO ci sarà un numero da 0 a 7, si segue la logica di OneHotEncoding di rwx
      - `0777 = rwxrwxrwx`
      - `0755 = rwxr-xr-x`

    In **octal mode** si possono settare i bit di protezione speciali:

- `chown`, cambia owner del file.\
  Un utente non può passare il file ad un altro utente, solo root può
  - `user[:group]`, nome del user ed opzionalmente del group a cui passare il file
- `chgrp`, cambia l'owner group del file\
  - `group`, nome del gruppo a cui passare il file
- `groups`, legge informazioni riguardo i gruppi
  - `username`, controlla i gruppi a cui è aggiunto i gruppo (se non si passa il parametro si controllano i propri gruppi)
- `mv`, sposta/rinomina uno o più file
- `rm`, eliminazione di uno o più file
  - `-r`, cancella in modo ricorsivo tutti i file (utile per cancellare completamente delle directory)
- `rmdir`, eliminazione di una o più directory (solo nel caso in cui la directory sia vuota)
- `mkdir`, creazione di una cartella in uno specifico path
  - `-p` vengono generati anche le directory parents nel caso non esistano
  - _path_, directory da creare
- `cd`, mi sposto in una cartella (default $HOME)
- `echo`, scrive in stdout il parametro passato
- `whoami`, scrive in stdout il nome del user in utilizzo
  - `-e`, gestisce correttamente le escape sequence (\n, \t, \r)
- `who`, scrive tutte le sessioni attive degli utenti collegati alla macchina
- `cat`, scrive su stdout il contenuto del file (default stdin)
  - `-n`, aggiunge il numero di ogni riga
- `ls`, lista tutti i file presenti all'interno di una directory (default in `pwd`)
- `env`, scrive variabili di ambiente del processo
- `pwd`, scrive il path della cartella di lavoro corrente (cwd)
- `type`, usato per capire che tipologia di comando stiamo parlando, questo ti farà capire la tipologia del file specificato, del tipo:
  - builtin
  - non builtin, scrivendo il path su stdout
  - alias
- `alias`, si possono chiamare degli alias che eseguono e/o sovrascrivono il comportamento di uno o più programmi
  - `alias ciao="echo Hello World!"`, questo renderà disponibile il comando/alias `ciao`
- `file <file_path>`, descrive il formato ed il contenuto del file specificato (esempio ASCII text, ELF, ecc...)
- `which <cmd>`, localizza, se esistente, la posizione del comando passato come parametro
- `whereis <cmd>`, localizza il comando e tutte le sue dipendenze
- `wc`, scrive il numero di caratteri, di parole e di righe:
  - `-c`, scrive numero di caratteri
  - `-w`, scrive numero di parole
  - `-l`, scrive numero di righe
  - _path_
- `su`, crea una nuova shell cambiando l'utente chiedendone le credenziali (default root):
  - _`username`_, nome dell'utente in cui loggarsi
  - aggiungendo `-` viene caricata la configurazione dell'utente (~/.bashrc, ~/.profile) in cui ci si logga
- `sudo` scritto prima di un comando ti da la possibilità di eseguire quel comando con le autorizzazioni di root:
  - `-i`, ti loggi come root (alternativa a `su -`)
  - `-s`, ti loggi come root (alternativa a `su`)
- `date`, data odierna del sistema, possibili diverse formattazioni
- `grep`, ricerca una stringa dentro un file o lo stdin
  - `-E` usa le extended RE (come `egrep` senza parametri)
  - `-F` disattiva le RE e usa il parametro come stringa letterale
  - `-w` fa match solo con RE “whole word”
  - `-x` fa match solo con RE “whole line”
  - `-i` rende l’espressione insensibile a maiuscole e minuscole
  - `-r` cerca ricorsivamente in tutti i file di una cartella
  - `-f` FILE prende le RE da un FILE invece che come parametro
  - `-o` restituisce solo le sottostringhe che corrispondono alla RE invece della riga che le contiene, separatamente una per riga di output.
  - `-v` restituisce le linee che NON contengono l’espressione
  - `-l` utile passando a grep più file su cui cercare: restituisce solo i nomi dei file in cui l’espressione è stata trovata
  - `-n` restituisce anche il numero della riga contenente l’espressione
  - `-c` restituisce solo il conteggio delle righe che contengono la RE
  - `--line-buffered` (disattiva il buffering)
  - `-q` quiet, nessun output, serve come condizione ritorna 0 o 1 if [ grep -q "c*" <<< "ciao"];then TRUE
  - `<RE>` espressione/testo da cercare
  - `<file/directory>` opzionale (default `stdin`)
- `export`, rendere globale una variabile di ambiente
- `unset`, reset/deallocazione di una variabile
- `less`, leggere e gestire output di file/processi molto lunghi\
  Logiche di interazione:

  - `/string_to_search` ricerca la stringa nel'output
    - `n` prossima occorrenza
    - `N` occorrenza precedente
    - `p` torna alla prima occorrenza
  - `v` apre il contenuto di less dentro l'editor di testo
  - `q` esci dal less

- `find`, programma per la ricerca di file direttamente sul **FS**
  - `-name` NAME
  - `-type` TYPE {d dir, f regular file}
  - `-size` SIZE {100k,12B,...}{+n maggiore n,-n minore n, n per dim ==n }
  - `-user` OWNER
  - `-print`(print a STDOUT)
  - `-atime` GG_DA_ULTIMO_ACCESSO (int) {+n maggiore n,-n minore n, n per dim ==n }
  - `-mtime` GG_DA_ULTIMA_MODIFICA (int) {+n maggiore n,-n minore n, n per dim ==n }
  - `-o` (OR)
  - `-a` (AND)
  - `-not` o `\!`
  - `-exec cmd {} \;` {} è il placeholder per il valore del path di ogni file
  - `-perm` -nnn{permessi nnn o più} oppure u+rwx,g+rwx,a+rwx,o+rwx
- `locate`, utilizza `find` per generare un database usato per velocizzare la ricerca di file nel **FS**
- `info`, informazioni relative al comando passato come variabile (non installato, si opta per `man` o `cmd --help`)
- `man`, manuale di documentazione di un programma/comando

  - `<man_page_number>` le pagine più interessanti sono:
    - **1** Comandi utente
    - **5** Config File
    - **8** comandi SysAdmin
  - `<program_name>`

  Il visualizzare usato è `less`

- `tree`, formattazione grafica di `ls -r`
- `passwd`, cambio password di un utente (default utente corrente)
  - `<username>`, questo argomento si può passare solo con i privilegi di root
- `ln` comando per creare link a file
  - `<path-from>`
  - `<path-to>`
  - se lanciato senza opzioni aggiunge un nuovo hard link all'inode,\
    se elimini `<path_from>`, `<path_to>` rimane utilizzabile senza problemi (confonde)
  - `-s`, symlink al file, non aggiunge riferimenti all'inode, punta semplicemente al file `<path_from`,\
    se elimini `<path_from>`, `<path_to>` diventa inutilizzabile (preferito)
- `mount <blk-device> <mount-point>`, comando per avere informazioni sui block device montati o per montarli
  - senza parametri ritorna informazioni sui block device montati
  - `<blk-device>`, block device che si vuole montare
  - `<mount-point>`, dove si vuole montare il block device nel FS
- `umount`, serve per smontare un filesystem montato
  - `<path-to-unmount>`
- `tail` leggere le ultime righe di un file (o stdin)
  - `-n` numero di righe da stampare (default 10)
- `head` leggere le prime righe di un file (o stdin)
  - `-n` numero di righe da stampare (default 10)
- `sort` serve ad ordinare le righe
  - `u` elimina le line/entry multiple
  - `r` reverse ordinamento decrescente
  - `R` random permutazione casuale delle righe
  - `m` merge di file già ordinato
  - `c` controlla se il file è già ordinato
  - `b` ignora gli spazi a inizio riga
  - `d` considera solo i caratteri alfanumerici e gli spazi
  - `f` ignora la differenza minuscole / maiuscole
  - `n` interpreta le stringhe di numeri per il valore numerico
  - `h` interpreta i numeri “leggibili” come 2K, 1G, ecc.
  - `t <sep>` imposta `<sep>` come separatore tra campi
  - `k <key>` chiave di ordinamento, un esempio:\
    `sort -t. -k2 -nr` per ordinare numericamente stringhe in modo decrescente del tipo `file.NUM.ext`
- `cut` tagliare l'output e stamparne solo una parte
  - `-d <char>`, usa `<char>` per fare lo split della stringa
  - `-f <num>`, stampa l'indice `<num>` dello split (parte da 1)
- `awk` comando molto potente di scripting per la gestione dell'output\
  Esempi:
  - `awk -F":" '{print $6}'` == `cut -d : -f 6`
- `uniq`, toglie le righe ripetute
  - `-c` prepend della stringa ripetuta con il numero di ripetizioni
- `tr` comando per sostituire o cancellare testo:

  - `-c` usa il complemento di `<to_substitute>`
  - `-d` cancella i caratteri `<to_substitute>`
  - `<to_substitute>` stringa da sostituire/cancellare\
    **N.B.** i set di caratteri si possono definire come in insieme di caratteri 'abc','a-z','a\*'
    o come classi [:alnum:](tutti numeri e lettere),[:alpha:](tutte lettere),[:digit:]
  - `<substitution>` stringa di sostituzione

- `sed` comando per modificare un file:

  - **Substitution**: `<subtitution_rule>` la cui formattazione è `s/<string_from>/<string_to>/<num_replacement>`:
    - `s` substitute
    - `<string_from>`, stringa da sostituire, si può usare **regexp**
    - `<string_to>`, stringa di sostituzione a `<string_from>`
    - `<num_replacement>`, numero di replacement per ogni riga (`g` per tutte)
  - **Deletion**: `<deletion_rule>` la cui formattazione `<single_rule>[;<single_rule>]`, il formato di `<single_rule` è `<num>[,<num>]d`, per negare la `<single_rule>` basta "negare" la regola: `<num>[,<num>]!d`\
    Esempi:

    - `sed '5d'` cancello linea 5
    - `sed '5,7d'` cancello da linea 5 a linea 7
    - `sed '5!d'` scrive solo linea 5
    - `sed '5,7!d'` scrive solo da linea 5 a linea 7
    - `sed '5d;9d'` cancello linea 5 e linea 9
    - `sed '5!d;9!d'` non scrive nulla, le regole sono in conflitto ⚠

- `xargs` forwarding dell'output di un programma come parametro di un altro programma:

  - `-t`, scrive i comandi che esegue
  - `-p` chiede interattivamente conferma di lancio (`y` per eseguire i comandi)
  - `-n <num>` numero massimo di argomenti passabili al programma successivo
  - `-d <delimiter>` separa l'output usando `<delimiter>` (default `" "`)
  - `-I` stringa che verrà sostituita dai valori passati da xargs al comando
  - `cmd` comando da eseguire (può contenere anche opzioni)

- `tar` serve per archiviare i file mantenendo la struttura delle directory

  - `-c` crea un nuovo archivio
  - `-x` estrae file da un archivio (mantenendo la struttura delle directory)
  - `--delete` cancella file da un archivio
  - `--force-local` forza la creazione dell'archivio in locale
  - `-f <filename>` viene quindi sempre usata per specificare un file di archiviazione\
    se `<filename>` contiene `:` questo verrà interpretato come un file in una macchina remota, per esempio _$hostname:/path/to/tar_ (aggiungi opzione `--force-local` per evitarlo)\
    `<filename>` può essere `-` per indicare:
    - `stdin` da cui leggere un archivio con `-d`, `-t`, `-x`
    - `stdout` su cui scrivere l’archivio con `-c`
  - `-T <elenco>` prende i nomi dei file da archiviare da FILE invece che come parametri sulla riga di comando
  - `-v` stampa i dettagli durante l’esecuzione
  - `-z` usa gzip per comprimere (estensione .tar.gz o .tgz)
  - `-j` usa bzip2 per comprimere (estensione .tar.bz2 o .tbz2)
  - `-J` usa xz per comprimere (estensione .tar.xz o .txz)
  - `-t` elenca il contenuto di un archivio
  - `-A` concatena più archivi
  - `-d` trova le differenze tra archivio e filesystem
  - `-r` aggiunge file ad un archivio
  - `-u` aggiorna file in un archivio
  - `-p` (preserve) conserva tutte le informazioni di protezione
  - `-C <dir>` svolge tutte le operazioni come dopo aver eseguito `cd <dir>` per decidere dove voglio scompattare un archivio

- `gzip` comprime in .gz

  - `-d` decomprime ricreando il file e rimuovendo l’estensione
  - `-c` riversa il risultato su `stdout`

- `bzip2` comprime in .bz2

  - `-d` decomprime ricreando il file e rimuovendo l’estensione
  - `-c` riversa il risultato su `stdout`

- `xz` comprime in .xz

  - `-d` decomprime ricreando il file e rimuovendo l’estensione
  - `-c` riversa il risultato su `stdout`

- `gunzip` decoprime .gz
- `bunzip2` decomprime .bz2
- `unxz` decomprime .xz
- `rsync` comando per fare il backup di una grande mole di dati
  - `-v` verbose
  - `-q` quiet
  - `-a` archive mode
- `ss` programma di controllo e supervisione delle porte
  - `-t` UDP only
  - `-u` TCP only
  - `-l` stato LISTEN (il default è ESTABLISHED)
  - `-a` stato ALL
  - `-n` non risolvere gli indirizzi/porte in nomi simbolici
  - `-p` mostra processi che usano la socket
  - `-s` summary statistics
- `visudo` editor per modificare il file `/etc/sudoers`
- `ssh` client per connettersi ad un serve con protocollo ssh
  - `<user>@<ip_or_hostname>`
  - `-p <port>`
- `scp` copia di un file da/in un host remoto usando `ssh`
  - `scp <file_to_copy> <file_destination>`\
    `<file_to_copy>` e `<file_destination>` possono essre nel formato
    - `user@ip:/abs/path` per un file su una macchina remota
    - `/path/to/file` per un file in locale
- `ssh-keygen` creazione/modifica chiavi asincrone per la connessione ssh:
  - `-t [rsa|dsa]` tipologia chiave
  - `-b <num>` lunghezza chiave `[1024,2048,4096]`
- `curl` e `wget` sono programmi per fare chiamate Http/Https e/o scaricare file da internet
- `ps`, comando per controllare lo stato dei processi del sistema
  - `-a` vedo tutti i processi di sistema, tranne i session leader e quelli non associati ad un terminale
  - `-A` o `-e` vedi tutti i processi del sistema
  - `-f` full string listing
  - `-x` elenca anche i processi avviati all’avvio come daemon
  - `-u` vedo l'user di ogni processo
  - `-h` (no headers)
  - `-o` pid,uname,cmd,cputimes[seconds], {formatting output}
  - `--sort{+[crescente]-[decrescente] FLAGS}`, la lista di `FLAGS` è:
    - `c`|`cmd` simple name of executable
    - `C`|`pcpu` cpu utilization
    - `f`|`flags` flags as in long format F field
    - `g`|`pgrp` process group ID
    - `G`|`tpgid` controlling tty process group ID
    - `j`|`cutime` cumulative user time
    - `J`|`cstime` cumulative system time
    - `k`|`utime` user time
    - `m`|`min_flt` number of minor page faults
    - `M`|`maj_flt` number of major page faults
    - `n`|`cmin_flt` cumulative minor page faults
    - `N`|`cmaj_flt` cumulative major page faults
    - `o`|`session` session ID
    - `p`|`pid` process ID
    - `P`|`ppid` parent process ID
    - `r`|`rss` resident set size
    - `R`|`resident` resident pages
    - `s`|`size` memory size in kilobytes
    - `S`|`share` amount of shared pages
    - `t`|`tty` the device number of the controlling tty
    - `T`|`start_time` time process was started
    - `U`|`uid` user ID number
    - `u`|`user` user name
    - `v`|`vsize` total VM size in KiB
    - `y`|`priority` kernel scheduling priority
  - `--forest` disegna le dipendenze tra processi
  - `<pid>` opzionale, mostra informazioni legate a quel processo

## 2.3 Variabili

### Variabili di ambiente

Generalmente scritte in maiuscolo.\
Alcune variabili di ambiente importanti:

- **\$PATH**, lista di cartelle in cui si possono ricercare eseguibili (formato `PATH=$PATH:/path/to/binary`)
- **$HOME** equivalente di **~**
- **$USER**, nome del user in utilizzo
- **$PWD**, path della cartella di lavoro corrente (cwd), si può usare i comando `pwd`

Queste sono condivise da tutti i processi.

### Variabili locali

Queste variabili sono legate/relegate ad un processo shell, queste variabili non vengono ereditate dai sottoprocessi generati dalla shell padre.

Una variabile si può resettare, inizializzare ed utilizzare:

- **Resettare**

  ```bash
    unset pippo
  ```

- **Inizializzare**

  ```bash
    pippo="stringa"
  ```

- **utilizzare**

  ```bash
    $ echo $pippo
    stringa
  ```

Si possono settare variabili locali solo per un processo/eseguibile:

```bash
  $ TZ="GMT" date
  Tue 02 May 2023 01:25:11 PM GMT
```

Le variabili locali possono avere diversi scope, di default le variabili locali non sono condivisibili con processi figli.\
Per rendere le variabili locali "globali" nello scope del processo lanciato e dei suoi sottoprocessi (enviroment variables) si può usare:

```bash
  pippo="stringa"
  export pippo
  export pluto="stringa"
```

## 2.4 Quoting

La logica del quoting viene usata per gestire gli spazi all'interno del nome di file e/o directory.

Le quotes utilizzabili sono:

- "" gestisce gli spazi e consente il parameter expansion
- '' gestisce gli spazi ma non consente il parameter expansion

## 2.5 Escaping

Il carattere di escaping rimuove/cambia il valore del carattere successivo.\
Il carattere in questione è `\`.

Possibili utilizzi:

- escaping di caratteri speciali:

  ```bash
    $ echo \$PATH
    $PATH
  ```

  ```bash
    $ touch "new file"
    $ ls
    'new file'
  ```

## 2.6 Command Substitution

Per catturare l'output di di processo per riutilizzarlo o metterlo in una variabile si possono usare:

- `$(command)`
- `` `command` ``

## 2.7 Command Help

Tutti i comandi o quasi hanno l'opzione `--help` che scrive un aiuto per l'utilizzo del programma/comando

Un'altro strumento per leggere la documentazioni di programmi/comandi e `man`

## 2.8 Installazione pacchetti

Acquisire i poteri di root (`su -`, `sudo -i`, `sudo cmd`) e per installare un pacchetto:

```bash
  apt install program
```

## 2.9 Ricerca File

Si può usare `locate`, prima di tutto bisogna generare il DB usato per le lookup con `locate updatedb`

`locate filename`, se presente, ritornerà il path per quel filename

`locate` si basa su `find` e ne astrae la complessità.

`locate` ricerca su DB, più veloce ma meno affidabile in quanto il DB potrebbe non essere aggiornato con gli ultimi file.\
`find` ricerca su FS, più lenta ma più affidabile e potente
