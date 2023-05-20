# 1.0 Introduction

## 1.1 Caratteristiche e Distro

Kernel Linux segue le interfacce descritte da Unix ma le implementa in modo OpenSource.

Le Distro sono pacchetti costituiti da `Kernel + applicazioni` mantenute da un'azienda o dalla community.\
Le distro puntano ad ottimizzare il Kernel e le applicazioni del SO per due applicazioni principali:

- Desktop
- Server

Distro principali/cardine:

- Debian (completamente open source, nessun supporto tecnico):
  - Ubuntu, base Debian, segue una filosofia simile a RedHat
- RedHat, gestito dall'azienda stessa può essere a pagamento, supporto tecnico dato dall'azienda
  - CentOS, base RedHat, versione opensource di RedHats
  - Fedora, versione community di RedHat
- SUSE, utilizzata nel mondo enterprice

Informazioni principali riguardo le distro:

- Debian, mira a fornire un OS affidabile basato sulla filosofia "open software", di default non fornisce nessun software proprietario. Non ha date fisse di rilascio, solitamente ogni 2 anni. Supporta i pacchetti `.deb`. Ci sono 3 versioni principali:
  - stable
  - testing
  - unstable
- Red Hat, sviluppata da un'azienda, soluzione enterprice molto affidabile ed a volte a pagamento per licenze (codice still OpenSource)
- Ubuntu, studiata per avere un'esperienza Desktop più facile, punta a portare il software libero a tutti ed a ridurre il costo dei servizi professionali. Release ogni 6 mesi, ma esistono anche release LTS che hanno un supporto di 2 anni.
- Fedora, distro rivolta dal Desktop supporta i pacchetti `.rpm`, proposta più libera e con licenze meno stringenti rispetto a RedHat.
- CentOS, Fedora ma non supportata da RedHat.
- SUSE, sviluppata da un'azienda tedesca, famosa per lo strumento $XXX

Linux è molto potente ed utilizzato nei sistemi Embedded, le distro più usate sono:

- Android (sviluppato da Google)
- Raspbian (su raspberry)

## 1.2 Licenze

Le licenze disponibili sono:

- Licenza `GPL (General Public License)`, licenza base allo sviluppo di Linux e del codice Open Source.\
  Questa licenza ha 4 livelli di liberà:

  - **libertà 0**, esegui il programma come buoi
  - **libertà 1**, modifica e studia il software come vuoi (Open Source)
  - **libertà 2**, libertà di ridistribuire le copie del SO
  - **libertà 3**,

  Concetto di **copyleft**, se si sviluppa un software **SW_new** sfruttando o basandosi su altro software con licenza GPL **SW_base** allora il nuovo progetto **SW_new** deve adottare la licenza GPL usata da **SW_base**.

- `BSD` punta a sollevare lo sviluppatore di un software Open Source da responsabilità legali legate al software sviluppato.
- `FLOSS`
- `Creative Commons`(base FLOSS), punta a portare i principi dell'Open Source ad altre aree non tecniche (scrittura di documenti, musica, ecc...)

Desktop evìnviroment:

- KDE, basata su QT C++, offre ampia customizzazione all'utente
- GNOME, toolkit GTK scritto in C e cerca di seguire il principio KISS (Keep It Simple Stupid)
- xfce, leggero ma meno carino
- Mate (basato su GNOME2)
- Cinnamon (fork di GNOME3)
- LXDE, leggero ma meno carino
