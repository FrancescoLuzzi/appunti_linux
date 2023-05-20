# 8.0 Gestione&InstallazionePacchetti

## 8.1 Intro

Inizialmente su linux l'unico modo per installare un programma era compilarlo in locale, prendendo il sorgente da **_SourceForge_** (oggi è più probabile **_Github_**).

Recuperato l'url per i sorgenti si possono scaricare con:

- `wget url -O out_file`
- `curl url -o out_file`

Spacchettizzarli con `tar` ed installarli seguendo le istruzioni nel progetto (`README.md`, `install.sh` o `setup.sh`)

## 8.2 Pacchetti precompilati

Se il provider del programma ha precompilato il suo programma per la tua distro, si può scaricare ed installare direttamente quelli.

Pacchetti precompilati variano di distro in distro:

- `.deb` su disro Debian based, questi si installano con `dpkg`
- `.rpm` su disro RedHat based, questi si installano con `rpm`

`dpkg` e `rpm` hanno una struttura/DB sui cui è salvato lo stato attuale dei pacchetti installati sulla macchina:

- `dpkg`, package manager per Distro Debian based:

  - `dpkg -i <file.deb>` update/installazione pacchetto
  - `dpkg -l <pattern>` list dei pacchetti che fanno match con `<pattern>`
  - `dpkg -L <pacchetto>` richiesta della lista di tutti i file istallati per `<pacchetto>`
  - `dpkg -r <pacchetto>` disinstalla pacchetto (di default mantiene i file di configurazione)
  - `dpkg -r --purge <pacchetto>` disinstalla pacchetto e cancella i file di configurazione
  - `dpkg -p <pacchetto>` legge i metadati del pacchetto

  `apt` è un package manager costruito **SOPRA** `dpkg`, studiato per risolvere, gestire e scaricare le dipendenze:

  - `apt -f install` serve ad installare le dipendenze mancanti di pacchetti installati con `dpkg`

- `rpm` package manager per Distro RedHat based:

  - `-v` verbose
  - `-h` display dello stato dell'installazione
  - `rpm -i <file.rpm>` installa pacchetto (default no output)
  - `rpm -u <file.rpm>` update/installazione pacchetto (default no output)
  - `rpm -e <pacchetto>` disinstalla pacchetto (default no output)
  - `rpm -u <pattern>` list dei pacchetti che fanno match con `<pattern>`
  - `rpm -q` per compiere query sui pacchetti:
    - `rpm -qi <pacchetto>` informazioni relative a `<pacchetto>`
    - `rpm -qc <pacchetto>` informazioni relative ai file di configurazione di `<pacchetto>`
    - `rpm -qa` informazioni relative a tutti i pacchetti installati nel sistema

  `yum` è un package manager costruito **SOPRA** `rpm`, studiato per risolvere, gestire e scaricare le dipendenze.

`apt`e `yum` basano la loro conscenza riguardo i pacchetti installabili ed i loro metadati su diversi `repository` di pacchetti precompilati.

- `apt`\
  La gestione della cache locale del repository è controllata manualmente

  - `apt update`, update della lista in locale dello stato della repository remota, è la conoscenza su cui si basta per fare `apt install`
  - `apt upgrade`, upgrade di pacchetti da aggiornare rispetto alla repository salvata il locale
  - `apt full-upgrade`, disinstallazione e reinstallazione dei pacchetti da aggiornare rispetto alla repository salvata il locale
  - `apt install <pacchetto>`, installazione di un pacchetto e delle sue dipendenze
  - `apt remove <pacchetto>`, disinstallazione di un pacchetto
  - `apt clean <pacchetto>` dinstalla i pacchetto e gli script di installazione
  - `apt purge <pacchetto>`, disinstallazione di un pacchetto e rimozione files di configurazione
  - `apt autoremove` disinstallazione dei pacchetti installati come dipendenze ma ora orfani, mantiene i file di congfigurazione
  - `apt autoremove --purge` disinstallazione dei pacchetti installati come dipendenze ma ora orfani, non mantiene nulla

  Il file `/etc/sources/apt.list` contiene i repository su cui si appoggia `apt`, se non si vuole modificare questo file si possono aggiungere dei file `.list` dentro la cartella `/etc/sources/apt.list.d/`.\
  Dopo aver aggiunto un repository, molto probabilmente dovrai aggiungere la chiave per validarlo con `apt-key add <key.gpg>`

- `yum`\
  La gestione della cache locale del repository è controllata automaticamente

  - `yum install <pacchetto>`, installazione di un pacchetto e delle sue dipendenze
  - `yum remove <pacchetto>`, disinstallazione di un pacchetto e dei suoi file di configurazione
  - `apt update`, aggiornamento dei programmi
  - `apt upgrade`, aggiornamento dei programmi e rimozione dei pacchetti obsoleti

  Per ogni repository è presente un file `.repo` all'interno della cartella `/etc/yum.repos.d/`, per configurare `yum` si può usare `/etc/yum.config`.\
  Il package manager che andrà a sostituire `yum` è `dnf`
