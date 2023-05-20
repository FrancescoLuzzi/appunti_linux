# 9.0 Processi

## 9.1 ps

Comando molto utile per controllare i processi in esecuzione sulla macchina

## 9.2 top/htop

Comando per vedere in modo interattivo lo stato dei processi e dell'utilizzo del pc.

Premendo `h` si apre la finestra dei suggerimenti

Si può creare il file `~/.toprc` per settare le configurazioni che si vogliono sempre avere.

Un altro comando, più carino e potente è `htop`

## 9.3 uptime

Comando per controllare il load avarage della macchina

## 9.4 kill

Si mandano segnali ai processi, nella lista di segnali (consultabile con `kill -l`) **SIGKILL** e **SIGSTOP** non possono essere intercettati e gestiti dal processo (`kill -<signal> <pid>`)

Esiste anche il comando `pkill <nome_programma>` per killare un processo dato il nome del programma eseguito

## 9.5 Processi in background

Per lanciare un programma in background basta aggiungere una `&` al termine del comando (`sleep 10 &`)

Con `jobs` vengono listati i processi in background.

```bash
$ sleep 10 &
[1] PID1
$ sleep 10 &
[2] PID2
$ jobs
[1]-  Running sleep 10 &
[2]+  Running sleep 10 &
```

Per poter far tornare sul terminale basta usare il comando `fg <job_id>`

## 9.6 Servizi

Processi in background eseguiti a prescindere.

Il comando per controllare e gestire i processi è `systemctl`:

- `status`
- `start`
- `stop`
- `restart`
- `reload`
- `enable`
- `disable`
