# 10.0 Dischi

## 10.1 Locazione dei dischi/partizioni

I file che rappresentano i dischi e le loro partizioni sono tutti nella cartella `/dev/`:

- caso disco nvme:
  - `nvme0, ..., nvme100, ...` per ogni nvme collegato
  - nvme0n1p1
- caso disco SCSI (ssd, hdd, usb)
  - `sda, sdb, ..., sdz, sdaa,...` per ogni block device collegato
  - `sda1, sda2, ...` partizioni create nel block device

## 10.2 Controllo stato filesystem

`df` mostra l’utilizzo dello spazio dei dischi

- `-h`, human readable file size non i byte

`du [<path_dir>]` permette di calcolare lo spazio occupato dai file sul disco in `<path_dir>`

- `<path_dir>` default `./`
- `--max-depth=<n>` massima ricorsione nelle sub-dir
- `-s` summary senza recursion

`mount <blk-device> <mount-point>`, comando per avere informazioni sui block device montati o per montarli

- senza parametri ritorna informazioni sui block device montati
- `<blk-device>`, block device che si vuole montare
- `<mount-point>`, dove si vuole montare il block device nel FS

`umount <mount-point>`, fa l'unmount del FS montato nel `<mount-point>`.\
Questo comando può andare in errore se uno dei file è in utilizzo o un quanche utente si trova in quel FS.

## 10.3 Mounting al boot

Il file che descrive come, dove e quali device vengono montati sul filesystem, è `/etc/fstab`, il cui formato è:

```bash
<file system> <mount point> <type> <options> <dump> <pass>
```

`<file system>` può essere:

- `/dev/<blk_device>` ma è sconsigliato in quantonon è deterministico, dipende dall'ordine in cui vengono rilevati i dischi dal SO, una soluzione migliore è usare `UUID=<uid_value>` (`<uid_value>` può essere letto dal comando `lsblk -fs` o `blkid`)
- `<ip|hostname>:/path/to/dir` per caricare una cartella remota e `<type>` settatao a `nfs`

Per testare la configurazione di `/etc/fstab` lancia:

- `mount -fav` per fare il test in modo fittizzio
- `mount -av` per fare il test reale

## 10.4 Partizionamento disco

Per partizionare un disco si usa il programma `fdisk /dev/<blk_device>`:

- `n` creazione nuova partizione, partirà una sessione interattiva per creare una partizione
  - tipo di partizione:
    - `p` primary
    - `e` extended
  - numero partizione, numero interno
  - dimensione della partizione:
    - in partizioni
    - con dimensione 2GB
    - premendo invio prende tutto lo spazio disponibile
  - `w` per applicare le modifiche al disco
- `d` cancelazione partizione

Per scriptare questo processo:

```bash
(
echo n
echo p
echo $partnumber
echo
echo
echo w
) | sudo fdisk /dev/sda

# oppure

printf "n\np\n$partnumber\n\n\nw\n" | sudo fdisk /dev/sda

# oppure

printf "n
p
$partnumber


w
" | sudo fdisk /dev/sda
```

## 10.5 Creazione filesystem

Per formattare un disco o una partizione si usa il comando `mkfs -t <type> /dev/<blk_device>`.

Ci sono dei comandi alias a seconda del FS che vogliamo creare:

- `mkfs.ext2`
- `mkfs.ext3`
- `mkfs.ext4`
- `mkfs.ntfs`
- `mkfs.fat`
- `mkfs.exfat`
