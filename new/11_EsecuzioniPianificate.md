# 11.0 EsecuzioniPianificate

## 11.1 Cron

Cron è il servizio che gestisce la pianificazione e ripetizione di script.

Per editare la `crontab` del proprio utente (`/var/spool/cron/crontabs/$USER`) basta lanciare il comando `crontab -e`:

```bash
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |   .---------- day of month (1 - 31)
# |  |   |   .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |   |   |   .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |   |   |   |        .---- use absolute paths to be sure
# m  h  dom mon dow   command
```

`crontab -l` stampa a video il crontab dell'utente.

Formato dei dati:

- `-` definisce un range di valori
  - 1-5 -> dall'1 al 5
- `,` separa diversi range di valori
  - 1,5 -> 1 o 5
  - 1-3,5 -> da 1 a 5 e 5
- `/` definisce uno step in un range
  - 1-59/2 -> every 2nd hr/min from 1 through 59 {solo dispari}
  - \_/n -> every `n` hrs/mins

Per fare esecuzioni pianificate notevoli (con i permessi di `root`⚠), si possono mettere gli script direttamente dentro una (o più) cartelle:

- `/etc/cron.daily`
- `/etc/cron.weekly`
- `/etc/cron.montly`

Esiste un'altra directory dove si possono definire dei cronjob, `/etc/cron.d/` il formato è leggermenete diverso, con l'aggiunta dell'utente con cui deve eseguire il comando:

```bash
# m  h  dom mon dow  username command
```

Per disabilitare il cronjob basta rinominarlo anteponendo un `.` (ES: `/etc/cron.d/mycron` -> `/etc/cron.d/.mycron`)

Per controllare l'esecuzione dei cronjob consulta `/etc/log/syslog` (`grep -i cron /etc/log/syslog`)

## 10.2 rsyslog

`rsyslog` è il servizio di logging di linux, il cui file di configurazione è in `/etc/rsyslog.conf`:

```bash
<etichetta> <destinazione>
```

- `<etichetta>`\
  Si possono definire più `<etichette>` per la stessa `<destination>` separandole con `;` (`<etichetta1>;<etichetta2>`)
  Ogni messaggio è etichettato con una coppia `<facility>.<priority>`
  - `<facility>`: auth, authpriv, cron, daemon, ftp, kern, lpr, mail, news, rsyslog, user, uucp, local0..local7\
    Possono essere specificate più `<facility>` separandole con `,`
  - `<priority` importanza in ordine decrescente: \*, emerg, alert, crit, err, warning, notice, info, debug, none\
    Una regola che specifica una priority fa match con tutti i messaggi di tale priority e superiori a meno che non sia preceduta da `=` (`=warning`)
- `<destinazione>`\
  Se `destinazione` è preceduto da `-` la scrittura viene bufferizzata per ridurre le scritture

  Le destinazioni possibili sono

  - File: identificato da path assoluto
  - STDIN di un processo: identificato da una pipe verso il programma da lanciare
  - Utenti collegati: username, o \* per tutti
  - Server `rsyslog` remoto:

    - `@indirizzo`
    - `@nomelogico`

    La comunicazione avviene di default su UDP, porta 514.\
    Per abilitarlo bisogna decommentare sul ricevente del log in `/etc/rsyslog.conf`:

    ```bash
      module(load="imudp")
      input(type="imudp" port="514")
    ```

    Se voglio usare TCP devo scrivere `@@indirizzo`

Per appicare le modifiche `systemctl restart rsyslog.service`

## 10.3 logrotate

Servizio di rotazione dei log è `logrotate`, il file di configurazione è `/etc/logrotate.conf`.\
Si possono specificare regole di rotation dei log rispetto a:

- dimensione del file
- età del file
- comando pianificato (es. ogni giorno a mezzanotte)

Si possono aggiungere nuove configurazioni di rotation scrivendo un nuovo file dentro `/etc/logrotate.d`:

```conf
/var/log/filename.log {
  {hourly|daily|weekly|monthly} # frequenza di esecuzione
  dateext # aggiunge la data al file ruotato
  maxsize 50{K|M|G} # dimensione file massima
  maxage 7 # età massima in giorni del file
  rotate 12 # si mantengono 12 file
  compress # compressione
  delaycompress
  missingok
  notifempty
  create 644 root root # permessi e owner dei file ruotati
  sharedscripts # esegue post script dopo la rotazione di tutti i file (non ad ogni file)
  postrotate
    # esecuzione di script o comandi
  endscript
}
```

`logrotate` utilizza `cron`, per testare una configurazione si può eseguire `logrotate /path/to/conf`
