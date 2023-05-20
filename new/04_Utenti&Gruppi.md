# 4.0 Utenti&Gruppi

## 4.1 Gruppi

Per controllare i propri gruppi esegui `groups`, se vuoi invece controllare i gruppi di un altro utente `groups username`

All'interno di `/etc/group` sono presenti tutti i gruppi e gli utenti che sono stati aggiunti:
`user:x:1000:user`\
`groupName:password:GID:utentiAggiunti`

Se `password`==`x` allora la password è scritta in `/etc/gshadow`

Nel file `/etc/gshadow` sono presenti le password criptate dei gruppi e la configurazione di amministrazione degli gruppi, sono presenti multiple righe del tipo:

`user:!::`\
`username:encryptedPassword:groupAdmins:members`

## 4.2 Utenti

Dentro il file `/etc/passwd` è presente la configurazione di sicurezza/shell degli utenti, è un file di testo in cui sono presenti multiple righe del tipo:

`user:x:500:500:UserName:/home/user:/bin/bash`\
`username:password:UID:GID:Nome/Cognome:HomeDIR:DefaultShell`

Se `password`==`x` allora la password è scritta in `/etc/shadow`

Nel file `/etc/shadow` sono presenti le password criptate degli utenti la configurazione di sicurezza/shell degli utenti, sono presenti multiple righe del tipo:

`user:aJIEGFOW2r239Ysa23jii923huIQWfa$$:::::::`\
`username:encryptedPassword:lastPasswordChange:minPasswordChange:maxPasswordChange:warningPeriod:inactivityPeriod:expirationDate:unused`

## 4.3 Modalità shell

Quando un utente si logga (vedi `su -`) o ci si collega tramite una sessione ssh, vengono caricati ed eseguiti diversi script, in ordine:

- `/etc/profile`
- `$HOME/.bash_profile`
- `$HOME/.bash_login`
- `$HOME/.profile`

Shell non di login, esempio quando si apre un terminale (di default oggi vengono caricati sempre):

- `/etc/bash.bashrc`
- `$HOME/.bashrc`
- `$HOME/.bash_aliases` (optional)

## 4.4 Bash CMD History

Quando si utilizza bash, viene creato un file `$HOME/.bash_history`, questo ti da la possibilità di controllare i comandi che hai dato in precedenza.\
Per consultarla lancia il comando `history`.\
Per rilanciare un comando della history:

- `!<cmd-number>`, per lanciare il comando `<cmd-number>`
- `!!` per lanciare il comando precedente
- `Ctrl+r` reverse search

Il file `.bash_history` viene aggiornato (in append) una volta che una shell bash viene chiusa correttamente (comando `exit`)

Per configurare la dimensione del file `.bash_history` si possono cambiare ENV variable nel `.bashrc`:

- `HISTFILE`, posizione della history file (default `$HOME/.bash_history`)
- `HISTCONTROL`, di default ha il valore `ignoredups` per ignorare comandi uguali
- `HISTSIZE`, quantità massima di comandi salvati
- `HISTFILESIZE`, dimensione massima in byte del file

## 4.5 Gestione Utenti connessi alla macchina

Il comando `who` scrive tutte le sessioni attive degli utenti collegati alla macchina.

## 4.6 File /etc/sudoers

File di configurazione dei permessi di `sudo`, il formato delle configurazioni possono essere:

- `userHost ALL(su qualsiasi Host)=(ALL:ALL)(a nome di qualsiasi utente:gruppo) ALL(qualsiasi comando)`
- `%groupName ALL(su qualsiasi Host)=(ALL:ALL)(a nome di qualsiasi utente:gruppo) ALL(qualsiasi comando)` (esempio utile `%sudo ALL=(ALL:ALL)ALL`)

**Note**:

- nella configurazione i comandi eseguibili possono essere preceduti da un `Runas_Spec` che modifica il comportamento di `sudo` una volta chiamato:

  - **LOG_OUTPUT**
  - **NOLOG_OUTPUT**
  - **MAIL**
  - **NOMAIL**
  - **PASSWD**
  - **NOPASSWD**
  - **SETENV**
  - **NOSETENV**

  Esempio `%group_no_pwd ALL=NOPASSWD:/path/to/executable,/path/to/script` utenti nel gruppo `group_no_pwd` possono eseguire `/path/to/executable` e `/path/to/script` con sudo senza bisogno di usare la password.

Per modificare il file `/etc/sudoers` si usa il comando `visudo`.

Per lanciare un comando impersonando un altro utente/gruppo si può usare:

- `sudo -u <uname>` per impersonare un utente
- `sudo -g <gname>` per impersonare un gruppo

## 4.7 Gestione Utenti

`useradd`:

- `<username>`, cambio password di un utente (default utente corrente)
- `-m` crea la home dell'utente, usa come template i files dentro il folder `/etc/skel`
- `-d <home_path>` sposta la home dell'utente in `<home_path>`
- `-s <shell_path>` assegna la shell all’utente, le possibili shell sono indicate dentro il file `/etc/shells`, altrimenti prende il default `/bin/sh`
- `-U` crea un gruppo con lo stesso nome dell’utente
- `-K <mask_name>=<value>` con questo parametro è possibile specificare una maschera riguardante `<mask_name>` (ESEMPIO: UMASK=077 tutti i file che verranno creati avranno protection bits 077)
- `-p` dopo questo parametro è possibile inserire la password utente **MA È SCONSIGLIATO** in quanto il valore della password verrà salvata in `~/.bash_history`, usare `passwd` separatamente
- `-G` alla creazione posso assegnare l’utente ad un gruppo supplementare (ESEMPIO: sudo)
- `-D` vengono stampati a video i default, per modificarli `/etc/default/useradd`
- `-u <UID>` setta il valore UID dell'utente (deve essere univoco)

Esiste uno script analogo in perl: `adduser`, che aggiunge comportamenti di default ed interattivi a `useradd` (`adduser <username>`)

`passwd`:

- `<username>`, questo argomento si può passare solo con i privilegi di root

`chsh`, cambia shell di default di un utente, ha comportamenti interattivi per richiedere la password (usa `sudo` per evitare)

- `<username>` nome utente da modificare
- `-s <shell_path>` nuova shell dell'utente

`usermod` modifica impostazioni di un utente esistente

- `<username>`
- `-G <group1>[,<group2>]` modifica la lista dei gruppi secondari dell'utente
- `-aG <group1>[,<group2>]` aggiungi in append alla lista dei gruppi secondari dell'utente
- `-g <group>`, cambia il gruppo di default dell'utente (modifcando il gruppo dei file nella `$HOME`)
- `-s <shell_path>`, cambia shell di default
- `-md <home_path>`, genera o sposta home utente in `<home_pathe>` e la setta come di default

`userdel` eliminare un utente

- `<username>`
- `-r` cancella home utente
- `-f` forza l'esecuzione anche se l'utente è loggato

## 4.8 Gestione Gruppi

`groupadd` aggiungi un gruppo

- `-g <GID>` setta il GID del gruppo (deve essere univoco)

Esiste uno script analogo in perl: `addgroup`, che aggiunge comportamenti di default ed interattivi a `groupadd` (`addgroup <username>`)

`gpasswd`
`groupnew`
`groupdel`
