# 6.0 Backup&Sync

## 6.1 Creazione di archivi

Per creare degli archivi si usa il comando `tar`.

`tar` mantiene la struttura delle cartelle ⚠

Se voglio fare il backup della mia home: `tar -cvf home_backup.tar $HOME`\
Per poi ripristinarla: `tar -xvf home_backup.tar`

## 6.1 Backup Hardcore

Si può usare `tar`, ma nel caso in cui la mole di dati da sincronizzare/backuppare la soluzione migliore è `rsync`

`rsync` è un programma per fare backup incrementali

`rsync -av $HOME /var/backup/home-sync`\
`rsync -av $HOME user@ip:/var/backup/home-sync`, sotto usa [ssh](./07_Networking.md#72-ssh)
