# 3.0 FileSystem

## 3.1 Organizzazione FS

<!--https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html--->

```bash
  $ tree -L 1 /
  .
  ├── bin
  ├── boot
  ├── dev
  ├── Docker
  ├── etc
  ├── home
  ├── init
  ├── lib
  ├── lib64
  ├── lost+found
  ├── media
  ├── mnt
  ├── opt
  ├── proc
  ├── root
  ├── run
  ├── sbin
  ├── srv
  ├── sys
  ├── tmp
  ├── usr
  └── var
```

- `bin` contains commands that may be used by both the system administrator and by users, but which are required when no other filesystems are mounted (e.g. in single user mode). It may also contain commands which are used indirectly by scripts.
- `/boot` contains everything required for the boot process except configuration files not needed at boot time and the map installer. Thus `/boot` stores data that is used before the kernel begins executing user-mode programs. This may include saved master boot sectors and sector map files.\
  Programs necessary to arrange for the boot loader to be able to boot a file must be placed in `/sbin`. Configuration files for boot loaders that are not required at boot time must be placed in `/etc`.
- `/dev` directory is the location of special or device files.
- `/etc` hierarchy contains configuration files. A "configuration file" is a local file used to control the operation of a program; it must be static and cannot be an executable binary.\
  It is recommended that files be stored in subdirectories of `/etc` rather than directly in `/etc`.
  - Host-specific configuration files for add-on application software packages must be installed within the directory `/etc/opt/<subdir>`, where `<subdir>` is the name of the subtree in `/opt` where the static data from that package is stored.
- `/home` directory that contains the users home directories
- `/lib` directory contains those shared library images needed to boot the system and run the commands in the root filesystem, es. by binaries in /bin and /sbin.
- `/media` directory that contains subdirectories which are used as mount points for removable media such as floppy disks, cdroms and zip disks.
- `/tmp` this directory is provided so that the system administrator may temporarily mount a filesystem as needed. The content of this directory is a local issue and should not affect the manner in which any program is run.\
  This directory must not be used by installation programs: a suitable temporary directory not in use by the system must be used instead.
- `/opt` is reserved for the installation of add-on application software packages.\
  A package to be installed in `/opt` must locate its static files in a separate `/opt/<package>` or `/opt/<provider>` directory tree, where `<package>` is a name that describes the software package and `<provider>` is the provider's LANANA registered name.
- `/root` default home directory for the root user, this can be changed but is not recomended
- `/run` this directory contains system information data describing the system since it was booted. Files under this directory must be cleared (removed or truncated as appropriate) at the beginning of the boot process.\
  This directory one was `/var/run` and some programs still use it.
- `/sbin` Utilities used for system administration (and other root-only commands) are stored in `/sbin`, `/usr/sbin`, and `/usr/local/sbin`.\
  `/sbin` contains binaries essential for booting, restoring, recovering, and/or repairing the system in addition to the binaries in `/bin`.\
  Programs executed after `/usr` is known to be mounted (when there are no problems) are generally placed into `/usr/sbin`.\
  Locally-installed system administration programs should be placed into `/usr/local/sbin`.
- `/srv` contains site-specific data which is served by this system.
- `/tmp` directory must be made available for programs that require temporary files.\
  Programs must not assume that any files or directories in `/tmp` are preserved between invocations of the program.

## 3.2 Path Formatting

Percorso relativo alla cartella di lavoro corrente `./dir` o `dir`:

```bash
  $ cd
  $ cd dir
  $ pwd
  /home/user/dir
```

Percorso assoluto path che inizia con `/` indicando la root del FS:

```bash
  $ cd /home/user/dir
  $ pwd
  /home/user/dir
```

## 3.3 Permessi e file

Utilizzando il comando `ls -l` verranno scritte a video delle informazioni su file:

```bash
  $ ls -l
  -rwxr-xr-x 1 name group  223541 May  2 16:18 normal_file
  drwxr-xr-x 1 name group     512 May  2 16:09 normal_dir
```

Il formato dell'output è:

- 10 caratteri che rappresentano i permessi e le info sul file:

  - primo carattere:
    - `-` file
    - `d` directory
    - `l` symlink
    - `c` char device (es. `/dev/tty`)
    - `b` block device (es. dischi fisici `/dev/sd?[[:digit:]]` o `/dev/nvme[[:digit:]]`)
    - `p` FIFO o pipe
    - `s` socket
  - tre triplette di caratteri che possono essere `r, w, x o -`:

    - `r` read enabled
    - `w` write enabled
    - `x` execute enabled
    - `-` option disabled

    Questi possono essere rappresentati con OneHotEncoding, `rwx = 111 = 7`, qualche esempio:

    - `rwxrwxrwx = 777`
    - `rwxr-xr-x = 755`

  A seconda del primo carattere le autorizzazioni del file cambiano:

  - `-`
    - `r` puoi leggere il file
    - `w` puoi scrivere nel file
    - `x` puoi eseguire il file
  - `d`
    - `r` puoi vedere il contenuto della directory con `ls`
    - `w` puoi modificare/creare/eliminare file nella directory
    - `x` puoi fare `cd` dentro la directory (senza non potresti)

- un numero che rappresenta in numero di link al file nell'inode
- `username` proprietario del file
- `gruppo` proprietario del file
- dimensione del file in byte (l'opzione -h rende human readable questa dimensione)
- Data e ora di ultima modifica
- nome del file/directory

I bit di protezione di un file sono 12:
`{SUID SGID STICKY U{rwx} G{rwx} O{rwx}}`

Dal 4 al 12 bit ci sono i bit di protezion UGO (User Group Other):

- `U` autorizzazioni `USER` del file
- `G` autorizzazioni `GROUP` del file
- `O` autorizzazioni `OTHER` (users) del file

Per modificare i permessi di un file si può usare `chmod`

## 3.4 Globbing

Pattern matching all'interno di bash:

- `*` qualsiasi stringa di qualsiasi lunghezza (anche vuota)
- `?` un carattere
- `[]`, classe di caratteri (si parla di caratteri/numeri singoli):
  - `prova[1-9]`, rappresenta il globbing di prova1, prova2, ..., prova9
  - classi di caratteri `[[:digit:]]`, `[[:alnum:]]`, `[[:alpha:]]`

## 3.5 inode

Struttura che identifica univocamente un singolo file nel filesystem, contiene tutte le informazioni che riguardano il file, tipo:

- la dimensione del file e la sua locazione fisica (se risiede su un dispositivo a blocchi, come ad es. un hard disk);
- il proprietario e il gruppo di appartenenza;
- le informazioni temporali di modifica (mtime), ultimo accesso (atime) e di cambio di stato (ctime);
- il numero di collegamenti fisici che referenziano l'inode;
- i permessi d'accesso;
- un puntatore allo spazio del disco che contiene i file veri e propri.

Il comando `ln` senza opzioni aggiunge un hard link all'inode del file

## 3.6 File editing

I CLI file editor molto spesso installati su linux by default sono:

- `nano`:\
  più user friendly e menu potente.\
  Shortcut di utilizzo:
  - `Ctrl+s` save
  - `Ctrl+x` exit
  - `Ctrl+k` cut
  - `Ctrl+u` paste
- `vim` (o `vi` con questo limitati al minimo):\
  meno user friendly ma molto potente.\
  La logica di utilizzo si divide in diverse modalità(per `normal mode` e `visual mode` c'è la possibilità di dare dei comandi):

  - `insert mode`, modalità per scrivere su file come un qualsiasi editor di testo, ci si accede da `normal mode` premendo:

    - `i`, posizione precedente al cursore
    - `I`, posizione all'inizio della riga
    - `a`, posizione successiva al cursore
    - `A`, posizione alla fine della stringa
    - `o`, crea una linea successiva alla positione del cursore
    - `O`, crea una linea precedente alla positione del cursore

    Una volta in `insert mode` si può accedere all'auto complete con `Ctrl+n`

  - `normal mode`, ci si accede premendo `Esc`, è la modalità per eseguire comandi (come salvare, uscire, ecc...) e modificare il file.\
    Ci si può muovere nel file con le frecce o con le così dette `vim motion`:

    - `h` left
    - `j` down
    - `k` up
    - `l` right

    Altre `vim motion` che possono essere utili sono:

    - `w` salta avanti di una parola
    - `W` salta avanti di un gruppo di caratteri contiguo
    - `b` salta indietro di una parola
    - `B` salta indietro di un gruppo di caratteri contiguo
    - `f+<char>` salta nella riga alla prima occorrenza di `<char>` (`;` next occurence, `,` previous occurrence)
    - `t+<char>` salta nella riga nella posizione precedente alla prima occorrenza di `<char>` (`;` next occurence, `,` previous occurrence)
    - `$` salta a fine riga
    - `^` salta ad inizio riga

    Un comando in vi/vim è formato in questo modo: `operator [number] motion`:

    `operator+motion` eseguibili in normal mode:

    - `d`|`c` delete/cut:
      - `dd` delete line
      - `dw` delete next word
      - `db` delete prev word
      - `df<char>` cancella fino alla prima occorrenza di `<char>` compresa
      - `dt<char>` cancella fino alla prima occorrenza di `<char>` esclusa
    - `y` copy:
      - `yy` copia line
      - `yw` copia next word
      - `yb` copia prev word
      - `yf<char>` copia fino alla prima occorrenza di `<char>` compresa
      - `yt<char>` copia fino alla prima occorrenza di `<char>` esclusa
    - `r` replace char
    - `~` toggle selected text case
    - `x` delete next char
    - `p` paste after cursor
    - `P` paste before cursor

    Gli operatori `y`,`d`,`c` e la `visual mode` supportano gli [object selection](https://vimhelp.org/motion.txt.html#object-select),
    permettendo motion molto utili (sono permutabilli, per cui sono validi `diw`,`yiw`,`viw`):

    - `dip`, delete inner paragraph
    - `yi"`, copy text surrounded by `"`
    - `da'`, delete text and surrounding `'`

    `number` è opzionale e serve a ripetere `operator+motion` più volte.

    Per mandare dei comandi in `normal mode` scrivi `:`, alcuni comandi utili sono:

    - `:<n>`, salta alla riga `<n>`
    - `:syntax on/off` per attivare o disattivare la colorazione del file
    - `:set number` fa vedere il numero di linea
    - `:q` exit
    - `:qa` exit all files
    - `:q!` exit without save
    - `:w` save
    - `:wq`,`:x` save and exit
    - `:split <nome_file>` split orizzontale ed apre il file
    - `:vsplit <nome_file>` split verticale ed apre il file
    - `:ter`, splitta orizzontalmente ed apre un terminale
    - `:vert ter`, splitta verticalmente ed apre un terminale
    - `<C-W><C-H|J|K|L>` cambia focus a seconda della `vim-motion`

    Per fare ricerce nel file la logica è la stessa di `man`:

    - `/string_to_search` ricerca la stringa nel manuale
      - `n` prossima occorrenza
      - `N` occorrenza precedente
      - `p` torna alla prima occorrenza

    Se invece vuoi fare delle sostituzioni nel file:

    - `:<scope>s/<string_from>/<string_to>/<number_of_occurrences>`
      - `<scope>` può essere:
        - `%` tutto il file
        - `<n>,$`,`0,<n>` un intervallo di righe
        - se stringa vuota si intende la riga che si sta editando
      - `<string_from>`, stringa da sostituire
      - `<string_to>`, stringa di sostituzione
      - `<number_of_occurrences>`, numero di occorrenze per ogni riga da sostituire
        - `<n>` numero di occorrenze
        - `g` tutte le occorrenze
    - `visual mode` ci sono diverse tipologie:
      - `visual block mode` vi si accede con `Ctrl+v`
      - `visual line mode` vi si accede con `Shift+v`
      - `visual mode`
