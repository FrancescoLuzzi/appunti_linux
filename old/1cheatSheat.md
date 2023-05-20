# PRINCIPI DI SHELL SCRIPTING

Ci sono due aspetti importanti da tenere a mente:
-Gli elementi di base gestiti da bash sono file e processi
-Il linguaggio di bash è interpretato, non compilato

~shutdown [-h|-r] now
-h indica la richiesta di arrestare il sistema (altrimenti: comando ~halt),
-r indica la richiesta di riavviare il sistema (altrimenti: comando ~reboot).
now istante di tempoo in cui eseguire la funzione

~alias nome='comandi' {alias è una stringa che viene sostituita da un’altra, non persistente}(poi inizializzarle nel file ~/.bashrc)
Se una parola del comando è uguale all'alias non si ha l'espansione ricorsiva, ma si ha l'espansione di altri alias.
Se lasci uno spazio alla fine dell'alias si controlla se è un alias anche la parola sucessiva.

Cattegorie di man pages (ci sono più man pages con lo stesso nome)
Una installazione standard di unix mette a disposizione innumerevoli pagine di manuale raggruppate in sezioni:
(1) User commands
(2) Chiamate al sistema operativo
(3) Funzioni di libreria, ed in particolare
(4) File speciali (/dev/\*)
(5) Formati dei file, dei protocolli, e delle relative strutture C
(6) Giochi
(7) Varie: macro, header, filesystem, concetti generali
(8) Comandi di amministrazione riservati a root
(n) Comandi predefiniti del linguaggio Tcl/Tk

~man -a{tutte le sezioni} <sezione> -k{riporta le pagine con la keyword} PROGRAMMA DA CERCARE

~history mostra l'elenco di tutti i comandi eseguiti in un terminale

~/usr/bin/tty prints the filename of the terminal connected (tty>/dev/null allora lanciato da terminale)
~whoami -> indica il proprio username
~hostname -> ritorna l'hostname specificato in /etc/hostname
~id -> dà informazioni sull'identità e sul gruppo di appartenenza
~who -> indica chi e' attualmente collegato alla macchina
~pwd -> mostra la directory corrente di lavoro
~cd -> permette di spostarsi a un’altra directory
~touch -> creazione di un file
~stat --format="" NOMEFILE -> serve per estrarre e formattare i metadati di un file {man stat -> /format per i formati}

~ ls
•-l abbina al nome le informazioni associate al file
•-a non nasconde i nomi dei file che iniziano con .
•-A come -a ma esclude i file particolari . e ..
•-F pospone il carattere \* agli eseguibili e / ai direttori
•-d lista il nome delle directory senza listarne il contenuto
•-R percorre ricorsivamente la gerarchia
•-i indica gli i-number dei file oltre al loro nome
•-r inverte l'ordine dell'elenco
•-t lista i file in ordine di data/ora di modifica (dal più recente)

~rm [-f ignores non existing file] cancella un file o, meglio, rimuove il link
~cp copia un file o piu' file in una directory
~mv sposta un file o piu' file in una directory
~ln crea un link ad un file - symlink con l’opzione -s, nessuna limitazione
~mkdir crea una directory
~rmdir cancella una directory vuota
~rm -r cancella ricorsivamente

~seq FIRST LAST
~seq FIRST INCR LAST
ES for i in $(seq 1 9 );do...
oppure for i in $(seq 9 -1 1);do...

~visudo per modificare il file di configurazione /etc/sudoers
[userHost ALL(su qualsiasi Host)=(ALL:ALL)(a nome di qualsiasi utente o gruppo) ALL(qualsiasi comando)]
se userHost è preceduto da "%" si riferisce ad un gruppo (es. %sudo)
[Debian-snmp ALL=NOPASSWD:/usr/bin/ss]

Il file ⁓/.bashrc è il file di configurazione del tuo utente { puoi aggiungere PATHS alla variabile PATH aggiungere alias/funzioni}

DEVICE FILES DI USO COMUNE
/dev/zero -> stream di 0 infinito
/dev/null -> ogni READ->EOF ogni write->scartata {if [ tty > /dev/null ]; then; programma da terminale; fi;}
/dev/random -> produce byte casuali (può essere bloccante)
/dev/uramdom -> pseudocasuale illimitato
/dev/tty* -> terminali fisici del sistema
/dev/pts/* -> pseudo-terminali(dentro finestre del sistema grafico)
/dev/sd\* -> dischi e partizioni (sono device a blocchi se non a carattere)

LANCIO PROGRAMMI
Ogni programma viene lanciato come nuovo PROCESSO PESANTE [fork + exec della bash padre]
questo include anche per la piping e process subsitution

RIDIREZIONE(redirect)
L'ordine di ridirezione è importante
">" scrive lo stdout di ls nel file miofile [troncandolo], ">>" invece [append]
{2> ridireziona lo stderr}
{>&2 ridireziona sullo stderr}
"<" riversa il contenuto di miofile su stdin del programma
"<<StringaMarcatore" il programma legge fino a trovare StringaMarcatore [da input tty]
"<<<" manda un testo direttamento allo stdin del comando

"exec" ridirezione definitiva, PER QUESTA SHELL, si possono creare nuovi fd poi ereditabili
dai processi figli {exec 2> /dev/null ; exec 3> filein; exec 4<filein -> poi puoi fare `echo "string">&3` verrà ridirezionata dentro filein
e fare <&4 leggerà da filein}

CONFLUENZA E REDIRECT
L'ORDINE DI LETTURA DELLE RIDIREZIONI VA DA DX A SX, se voglio quindi ridirezionare stderr in stdin e poi ridirezionare stdin su un file devo:
comando >file.out 2>&1

SUBSHELL
( comando1; comando2 ) si crea una subshell che compie tutti i comandi NELLO STESSO PROCESSO BASH
{ comando1; comando2 } si crea una sequenza di funzioni senza aprire una subshell

FUNZIONI PRINCIPALI FILTRI

~cat leggi un file o più file [se il file è - o omesso si legge da stdin]:
-b (number non empty output lines)
-n (number all output lines)
-s (non repeting output lines)
-E (show ends of line with "$")

~tac è come cat ma ordine delle righe inverso (bloccante)

~less (utile per l'uso interattivo)

~rev (reverse ordine caratteri di ogni riga)

~head (legge le prime n righe)
-c NUM (produce i primi NUM CARATTERI)
[se usi -NUM produce tutto il file tranne gli ultimi NUM CARATTERI]
-n NUM (produce le prime NUM RIGHE)
[se usi -NUM produce tutto il file tranne gli ultimi NUM RIGHE]

~tail(legge le ultime n righe)
-c NUM (produce gli ultimi NUM CARATTERI)
[se usi +NUM produce tutto il file a partire dal NUM CARATTERE]
-n NUM (produce le ultime NUM RIGHE)
[se usi +NUM produce tutto il file a partire dalla NUM RIGA]
-f (tiene il )file sempre aperto e controlla sempre nuove aggiunte
--pid=PID (il processo muore quando anche il processo con PID muore)
-F Faccio -f aspettando di riuscire ad aprire il file se non esiste ancora

~cut
–d"CARATTERE_DELIMITATORE"
–f ELENCO_CAMPI(numero intero)
-s (se la riga non contiene "CARATTERE_DELIMITATORE" non viene riprodotta in output)

~sort
–u (elimina le line/entry multiple)
–r (reverse ordinamento decrescente)
–R (random permutazione casuale delle righe)
–m (merge di file già ordinato)
–c (controlla se il file è già ordinato)
-b (ignora gli spazi a inizio riga)
-d (considera solo i caratteri alfanumerici e gli spazi)
-f (ignora la differenza minuscole / maiuscole)
-n (interpreta le stringhe di numeri per il valore numerico)
-h (interpreta i numeri “leggibili” come 2K, 1G, ecc.)
-t SEP (imposta SEP come separatore tra campi)
-k KEY (chiave di ordinamento)
{ si può usare ~sort -t. -k2 -nr per ordinare numericamente stringhe in modo decrescente del tipo file.NUM.ext}

~uniq
-c (elimina line multiple e le conta) {COUNT LINE}

~wc(word count) è un filtro di conteggio
-c (conta i caratteri)
-l (conta le linee)
-w (conta le parole, stringhe separate da spazi)

~grep (Ricerca di parti in un testo)
-E usa le extended RE (come egrep senza parametri)
-F disattiva le RE e usa il parametro come stringa letterale
-w fa match solo con RE “whole word”
-x fa match solo con RE “whole line”
-i rende l’espressione insensibile a maiuscole e minuscole
-r cerca ricorsivamente in tutti i file di una cartella
-f FILE prende le RE da un FILE invece che come parametro
-o restituisce solo le sottostringhe che corrispondono alla RE invece della riga che le contiene, separatamente una per riga di output.
-v restituisce le linee che NON contengono l’espressione
-l utile passando a grep più file su cui cercare: restituisce solo i nomi dei file in cui l’espressione è stata trovata
-n restituisce anche il numero della riga contenente l’espressione
-c restituisce solo il conteggio delle righe che contengono la RE
--line-buffered (disattiva il buffering)
-q quiet, nessun output, serve come condizione ritorna 0 o 1 if [ grep -q "c*" <<< "ciao"];then TRUE

REGEX
(RE) -> RE= uno o più rami separati da | {es (sudo|las|[a-z]_)}
ramo = uno o più pezzi concatenati tra loro
pezzo = atomo eventualmente seguito da un moltiplicatore
atomo = uno di:
• (RE)
• [charset]
• ^ o $ o .
• backslash sequence
• Singolo carattere  
 Atomi speciali:
. indica UN qualsiasi carattere
^ indica l'inizio della linea
$ indica la fine della linea
Backslash sequence:
\< – \> la stringa vuota all’inizio – alla fine di una parola.
\b la stringa vuota al confine di una parola
\B la stringa vuota a condizione che non sia al confine di una parola
\w è sinonimo di “una qualsiasi lettera, numero o \_”
\W è un sinonimo “un qualsiasi carattere non compreso in \w”
Moltiplicatori:
{n,m} indica da n a m occorrenze dell’atomo che lo precede
? indica zero o una occorrenza dell’atomo che lo precede
_ indica zero o più occorrenze dell’atomo che lo precede + indica una o più occorrenze dell’atomo che lo precede
Charset:
[abc] indica UN qualsiasi carattere fra a, b o c
[a-z] indica UN qualsiasi carattere fra a e z compresi
[^dc] indica UN qualsiasi carattere che non sia né d né c
Charset basati su character class [:NOME_CLASSE:]
alnum digit punct alpha graph space
blank lower upper cntrl print xdigit

~sed 's/OLD_PATTERN/NEW_PATTERN/[modificatori]' [file, se omesso legge da stdin] -> pattern può essere [a-z] oppure [string,string2]
[modificatori]: i (Case sentitive)
g (global)
NUM (solo NUM-esima occorrenza)
-i[SUFFIX] edita il file dato(se SUFFIX è dato si crea un backup con estensione SUFFIX)
-u (UNBUFFERED)
-f prende il pattern da un file

~tr 'DA_SOSTITUIRE' 'SOSTITUZIONE' (sostituzione caratteri)
-c (usa il complemento di DA_SOSTITUIRE)
-d (cancella i caratteri DA_SOSTITUIRE)
-N.B. i set di caratteri si possono definire come in insieme di caratteri 'abc','a-z','a\*'
o come classi [:alnum:](tutti numeri e lettere),[:alpha:](tutte lettere),[:digit:]

~awk '{algoritmo di printing}'legge da stdin
-F 'DELIMITATORE' Default " "
-nell'argomento di printing si possono usare if ed else come in c

~xargs
-0 utilizza null, non lo spazio, come terminatore di argomento
-L MAX -> al più MAX linee di input per invocazione
-p chiede interattivamente conferma di lancio
-d char -> cambio del terminatore di argomento

~process subsitution
-cmd_consumer_da_file <(cmd_producer_su_stdout)
Il processo tra parentesi è lanciato concorrentemente all’altro e la shell
genera un nome di file (sarà una named pipe) da fornire al primo in cui ci sarà
l'output di cmd_producer_su_stdout
-cmd_producer_su_file >(cmd_consumer_da_stdin)
Il processo cmd_producer_su_file produce un file in output, che viene scritto
su stdin di (cmd_consumer_da_stdin)

~tee (comando utile per duplicare uno stream di output)
-utile utilizzarlo con process subsitution
ls | tee >(comandi1...) |tee >(comandi2...) |grep baz | wc > baz.count

    OUTPUT_LS->tee->tee->grep->wc
              /        \
    (comandi1...)      (comandi2...)

~shuf (permutazioni ramdom come sort -R)
-e (puoi passare gli argomenti di cui randomizzare l'ordine)
-i (poi passare un range di numeri min-max)
-r (ripetizione infinita)

~command substitution
-$(comando)==`comando` esegue il comando all'interno con una subshell e ritorna il suo risultato

~diff filesinistro filedestro
2d1 <-deleted file sinistro file destro
< riga due riga uno riga uno
4c3 <-changed riga due riga tre
< riga quattro riga tre riga4
--- riga quattro riga cinque

> riga 4 riga cinque riga 5bis
> 5a5 <-added
> riga 5bis

~paste (unisce “orizzontalmente” le righe di posizione omologa in vari file)

~join (Stesso principio di paste, ma unisce le righe se iniziano con la stessa “chiave”)
[file ORDINATI IN MODO IDENTICO SULLA CHIAVE SELEZIONATA]

PROGRAMMARE IN BASH
I 12 step della shell expansion:

1. Tokenizzazione
2. primo token = alias?
3. primo token = keyword?
4. Brace expansion [file{9..13..2}.c->file9.c file11.c file13.c] [{a..c}{1,3} -> a1 a3 b1 b3 c1 c3]
5. Tilde Expansion
6. Parameter expansion
7. command substitution $()
   1. arithmetic expansion (())
   2. process substitution <() o ()>
   3. word splitting (IFS)
   4. pathname expansion (si controllano {a,b,c},[SET],\*,?)-> [^SET][!SET] può essere negato con ! o ^, una classe egrep [[:alnum:]]. [a-z] [0-9] {1,2,3} {a,b,c}
   5. quote removal ed esecuzione [],!,?,\*,",',`,^,$,{},(),\,|,<,>

VARIABILI AMBIENTE (si possono controllare con ~set e ~env ed esportarle con ~export nomeVariabile)
Settate da bash:
– $BASHPID PID della shell corrente
– $$ PID della shell “capostipite”
– $PPID PID del parent process della shell “capostipite”
– $HOSTNAME nome dell’host
– $RANDOM un numero casuale tra 0 e 32767
– $UID id utente che esegue la shell
– $HOME home directory dell’utente

- $SSH_CLIENT {ip porta_from 22} info sulla macchina connessa via ssh

VARIABILI POSIZIONALI
$0 nome programma $1... variabili passate
$# numero vairabili passate
$? var uscita funzione precedente
$! pid processo mandato in background
"$*" espanso in  "$1 $2 ..."
"$@" espanso in "$1" "$2" ...

~shift N, per shiftare a sx le variabili ed eliminare le prime N

FILEDIR=${1:-"/tmp"}
usa il default /tmp se $1 è null o not set {$1 non è modificato}

cd ${HOME:="/tmp"}
se $HOME è null o not set, questa viene inizializzata al default /tmp

FILESRC=${2:?"Error. You must supply a source file."}
stampa l'errore ed esce se $2 è null o not set

~unset var -> toglie dalle variabili var

PARAMETER EXPANSION

${nomeMANIPOLAZIONE}
MANIPOLAZIONE
|
#name -> Return the length of the string
name#pattern -> Remove (shortest) front-anchored pattern
name##pattern -> Remove (longest) front-anchored paern
name%pattern -> Remove (shortest) rear-anchored paern
name%%pattern -> Remove (longest) rear-anchored paern
name/pattern/string -> Replace first occurrence
name//pattern/string -> Replace all occurrences

ACCESSO INDIRETTO

CHIAVE=PIPPO
PIPPO=VALORE
echo ${!CHIAVE}
VALORE
ritorna il nome della variabile che contiene

ARRAY CON INDICE NUMERICO
~declare -a MYVECTOR (opzionale)
– assegnamento A[0]="primo valore" oppure MYVECTOR=("elemento" "elemento2") oppure se ho separatori diversi
Il separatore di default è $IFS, per modificarlo basta cambiare il valore di IFS, IFS=\$'SEP' (si usa \$'' per fare escaping corretto di \\n, \\t, ecc...)
OLDIFS=$IFS IFS="SEPARATORE" MYVECTOR=($STRINGA) IFS=$OLDIFS
– accesso echo ${A[0]}
    -Per visualizzare tutti gli elementi dell’array si può usare l’indice * o @  "${name[@]}" o "${name[*]}" [comportamento è la stessa che c’è tra $* e $@]
-Per conoscere il set di indici corrispondenti ${!name[@]}
-Per conoscere il numero di celle assegnate si utilizza ${#name[*]}

ARRAY ASSOCIATIVI (mappa chiave valore)

~declare -A ASAR
ASAR[chiaveuno]=valoreuno
echo ${ASAR[chiaveuno]}
valoreuno
KEY=chiaveuno
echo ${ASAR[$KEY]}
valoreuno

BUILTIN

~read, l’input viene tokenizzato usando IFS (di default qualsiasi spaziatore)
-p PROMPT stampa PROMPT prima di accettare input
-u FD legge da FD invece che da stdin
-a ARRAY assegna i token a elementi di ARRAY
Problema "echo ciao | read A" non funziona bene, di deve usare una subshell "echo ciao | ( read A ; echo $A )"
tail -f FILE -n0 | (while IFS="SEP" read A B C;do
...
done)

MATEMATICA IN BASH

declare -i N
N="3 \* (2 + 5)"
echo $N
21
Usando il builtin ~let o l’equivalente comando composto (( )) -> il token $(( )) viene espanso col risultato dell’espressione

FUNZIONI
function NOME() { SEQUENZA ; }

utilizzabili come i parametri posizionali dello script $1, $2, ..., $0==NOME
– stesso spazio di memoria
– variabili “globali”
– possibilità di dichiarare variabili locali con local

TEST E VALUTAZIONI CONDIZIONALI

l’exit code di un processo si trova nella variabile speciale $? (0==true, altri valori==false)

esistono diversi builtin e comandi
– Builtin: test , [ ] , [[]]
– Comandi: test , [ ] {Tipicamente hanno sintassi identiche. Utile per portabilità.}

test e [] sono lo stesso builtin
{AND, OR, NOT sono rispettivamente -a , -o , !}
~su stringhe, ulteriori su "help test"
-z true se la stringa è vuota
-n true se string è non vuota

    ~su file
        -e true se file esiste
        -f true se è un file regolare
        -d true se è una directory
        -s true se file non è vuoto
        -r true se readable
        -x true se eseguibile
        -w true se writable

    ~confronto lessicale tra stringhe
        = , != , < , > !!!{proteggi la variabile con ""}!!!

    ~confronto numerico tra stringhe
        -eq , -ne equal, not equal
        -lt , -le less than , less or equal
        -gt , -ge greater than, greater or equal

    ~confronto tra file
        -nt newer than
        -ot older than

[[]] supporta le stesse funzioni di test/[] e inoltre: {gli operatori AND, OR, NOT sono rispettivamente && , || , ! e si possono fare raggruppamenti con le tonde}
– gli operatori binari == e != fanno match del parametro di sinistra con un pattern espresso dal parametro di destra
con la stessa sintassi della pathname expansion {[[ "ciao" == c?a[l-z]]]->true}
– l’operatore binario =~ fa match del parametro di sinistra con una REGEX {SENZA ""!!!}

~TEST LOGICI TRA PROCESSI

--cd "$MYDIR" && ls "$MYFILE" ->true se riesco a entrare in $MYDIR e riesco a elencare $MYFILE, se la prima funzione fallisce la seconda non parte

--cd "$MYDIR" || echo "$MYDIR inaccessibile" -> se il primo operando è sufficiente a determinare il risultato, il secondo non viene valutato

if [[]];then
comandi
elif [[]];then
comandi
else
comandi
fi

case "$variabile" in
nome1) echo vale nome1 ;;
nome?) echo vale nome2, nomea, nomez ;;
nome*) echo vale nome11, nome, nomepippo ;;
[1-9]nome) echo vale 1nome, 2nome, …, 9nome ;;
*) echo non cade in nessuna delle precedenti ;;
esac

for NAME [in WORDS ... ] ; do
COMMANDS
done

for (( i=0, j=0 ; i+j < 10 ; i++, j+=2 )) {c-like}

for BACKWARDSTENTHS in $(seq 1 -0.1 0)

while COMANDO -oppure- until COMANDO ->(WHILE->comando true UNTIL-> comando false)
do
LISTA
COMANDI
ITERATI
done

~break [N]
– esce da un ciclo for, while o until
– se specificato N, esce da N cicli annidati
~continue [N]
– salta alla successiva (possibile) iterazione di un ciclo for, while o until
– se specificato N, riparte risalendo di N cicli annidati

SEGNALI {mesaggi asincroni, generati dal kernel o da un processo}

Ricezione:
– il controllo dei segnali ricevuti avviene ogni volta che il processo rientra in userspace (es. dopo una syscall o quando schedulato sulla CPU)
– se tra un controllo e il successivo sono stati ricevuti più segnali diversi, vengono posti in uno stato “pending”
• l’ordine in cui verranno presi in considerazione non è specificato
• pending non è una coda: che ne arrivi uno o più (dello stesso tipo) il flag sarà semplicemente settato

KILL e STOP, che non possono essere bloccati,ignorati, o intercettati da un handler personalizzato.

Handler in bash

~trap [-l lista segnali] [[codice_da_eseguire] segnale …]
Solitamente fatta una funzione handler si chiama "trap NOME_FUN SIGNALS"
{trap "pkill -KILL -P $$ nomeprocesso" INT QUIT HUP}

~kill -sSIGNAL pid
~pkill -SIGNAL -P PPID nomeProcesso {un buon utilizzo come funzione per trap [~pkill -KILL -P $$ nomeProcesso]}
~fuser -k SIGNAME file -> killa tutti i processi che stanno usando quel file

BACKGROUND

Questo si ottiene postponendo il carattere "&" alla command line. "comando &"
Il PID del processo viene memorizzato nella variabile "$!", si puo usare anche il job_id con %job_id

Se si lancia una command line senza &, e si vuole rimediare, si può dare un segnale di STOP con Ctrl+Z.
Anche in questo caso si riceve un job id.
Con il comando ~bg %job_id, si invia un segnale CONT che riavvia il processo e contemporaneamente lo si mette in background.

~wait [%job_id] permette di bloccare l’esecuzione fino al completamento dei job in background {si possono passare come argomento job_id specifici}
!!Se durante l’attesa la shell riceve un segnale per il quale è definito un handler con trap, wait esce immediatamente con exit code > 128.

FOREGROUND
~fg %job_id

~jobs mostra l'elenco dei job, cioè di tutti i processi avviati dalla shell corrente, indicando il loro stato

Modificatori per processi in bg

~nohup <comando> evita che la shell, alla chiusura, invii il segnale SIGHUP al <comando> (il che normalmente ne causerebbe la terminazione)

~nice [-n INT in [-20,19]] <comando> lancia <comando> con una niceness diversa da zero,modificando la priorità del processo (valori regativi solo per root)

~disown [%job_id] [-h "immunità da hangup"]rimuove completamente un job dalla job table della shell, di default l'ultimo lanciato

Condividere variabili e altre definizioni
Il comando "source" può essere usato per eseguire uno script nel contesto di un altro.
"source common.sh" le variabili, funzioni e alias saranno definite anche nello script “chiamante”

~eval $stringa_comando -> interpretare una stringa come una riga di comando (OCCHIO ALL'ESPANSIONE DI $VAR->\$VAR)

CREAZIONE DI SCRIPT GETOPTS
~niceexec
Per costruire script che supportino la classica sintassi "-a -b cosa"

while getopts ':a:b:' OPTION ; do
case $OPTION in
a) aflag=1 ;;
b) bflag=1
bval="$OPTARG"
;;
?) printf "Usage: %s: [-a] [-b value] args\n" $(basename $0) >&2
exit 1
;;
esac
done
shift $(($OPTIND – 1)) # getopts cycles over $\*, doesn't shift it

Esecuzione di comandi con diverse identità
~su -c "COMANDO" – UTENTE

~sudo -u UTENTE COMANDO

~sudo COMANDO è sicuramente l’opzione da usare per eseguire comandi come root (Possibilimente NOPASSWD) Aggiungo con Visudo ad /etc/sudoers(Debian-snmp ALL=NOPASSWD:/usr/bin/program)

~time <comando> time è una semplice keyword che anteposta a un comando ne riporta la durata

~date +FORMAT permette di selezionare cosa e come visualizzare {date +"%Y/%m/%d %H:%M:%S"-> 2021/03/09 15:27:45}{date +"%A %e %B"->martedì 9 marzo}
-%s: il numero di secondi
-%n: il numero di nanosecondi

-d STRING diplay time of STRING not now

In questo modo si possono convertire i timestamp tra diversi formati, ad esempio:
N=$(date -d '2020-05-15 10:01' +%s) – ora di un evento interessante convertita in epoch ("%d/%m/%Y" 16/06/2021)
(( N+=1800 )) – aumentata di 1800 secondi (30min)
date -d "@$N" +"%b %e %a %Y, %H:%M:%S, %Z" – stampata in modo leggibile->ven 15 mag 2020, 10:31:00, CEST

File temporanei

~mktemp
-d crea una directory
-p DIR crea all’interno di DIR invece che in /tmp

MANIPOLAZIONE NOMI FILES

~basename include/stdio.h .h -> stdio
~basename include/stdio.h -> stdio.h

~dirname /usr/bin->/usr  
~dirname data.txt-> .

~find
~path=`find / -iname "${0#./}" 2>/dev/null` #serve a cercare il file $0 togliendo il "./" iniziale

~printf [-v var] "format" [arguments] {format %d,%s,%.2f}{arguments= "arg1" "arg2"...}
-v var assegna il risultato della formattazione alla variabile invece che produrlo su STDOUT
– format è una stringa di formato
– arguments sono gli argomenti a cui applicare la stringa di formato

~watch esegue un comando periodicamente mostrando l’output sul terminale, non è da considerare uno strumento di automazione, ma di monitoraggio “umano” interattivo
-d evidenzia le differenze apparse dall’ultimo aggiornamento
-n <intervallo> imposta l’attesa tra un’esecuzione e la successiva
-p interpreta il valore passato con -n come periodo di aggiornamento

ESECUZIONI PIANIFICATE
Compito di crond
-ogni utente ha la propria cron table (crontab), /var/spool/cron/USERNAME
-tipicamente preconfigurato per l'esecuzione di script a periodicità di uso comune /etc/cron.hourly, /etc/cron.daily, /etc/cron.weekly, /etc/cron.monthly

/etc/crontab si può editare direttamente, per le tabelle utente meglio usare
~crontab [-e Editor Utente] [-u username] [-l lista elementi in crontab] filename

-Eliminare un proramma da crontab in script
~crontab -l | grep -v "$ProgrammaDaEliminare" | crontab -

-aggiungere programma a ~crontab file (sostituzione crontab)
tmp=mktemp
crontab -l | grep -v "$PathProgramma">$tmp
echo "\* \* \* \* \* $PathProgramma">>$tmp
crontab $tmp
rm -f "$tmp"

[MINUTO ORA G.MESE MESE G.SETTIMANA] {1-5(dall'1 al 5) oppure 1,5(or) oppure
1-59/2(every 2nd minute from 1 through 59 {solo dispari}), _/n (every n Hrs/mins)}]
SETUP di cron
-Esegui un job ogni 30 secondi
{_ \* \* \* _ /scripts/script.sh; sleep 30
_ \* \* \* _ sleep 30; /scripts/script.sh }
-Esegui un job ogni 10 minuti
{_/10 \* \* \* _ /scripts/monitor.sh}
-prima domenica di ogni mese alle 2 di notte
{0 2 _ \* sun [ $(date +%d) -le 07 ] && /script/script.sh}
-@yearly
-@monthly
-@weekly
-@daily
-@hourly
-@reboot

ESECUZIONE POSTICIPATA
atd è un demone che gestisce code di compiti da svolgere

~at [-V] [-q queue] [-f file] [-mldbv] TIME ->pianifica un comando al tempo TIME
~atq [-V] [-q queue] [-v] ->elenca i comandi in coda
~atrm [-V] job [job...] ->rimuove comandi dalla coda {si usa l'id che da in output atq}
~batch [-V] [-q queue] [-f file] [-mv] [TIME] ->esecuzione condizionata al carico

Se non viene specificato un file comandi per at o batch:
echo 'wall "sveglia"' | at 08:00
echo "$HOME/bin/pulisci" | at now + 2 weeks

#per prendere il job id e poter revocare l'esecuzione
echo "$HOME/bin/auguri" | at midnight 31.12.2021 2>$1 | awk '{ print $2 }'

LOG DI SISTEMA ~rsyslog

Per loggare si usa:
~logger -p <facility>.<priority> -t tag (-f FILE | "messaggio") -n ip_to_write_to
/etc/rsyslog.conf contiene le direttive di configurazione generale e le regole minime di smistamento dei messaggi

/etc/rsyslog.d/ contiene i file di configurazione personalizzate di smistamento dei messaggi, basta creare un file .conf

<etichetta di interesse> <destinazione>

<etichetta>
Ogni messaggio è etichettato con una coppia
<facility>.<priority>
– Facility = argomento: auth, authpriv, cron, daemon, ftp, kern, lpr, mail, news, rsyslog, user, uucp, local0..local7
– Priority = importanza in ordine decrescente: emerg, alert, crit, err, warning, notice, info, debug
    una regola che specifica una priority fa match con tutti i messaggi di tale priority e superiori a meno che non sia preceduta da “=”

<destinazione>
Le destinazioni possibili sono
– File: identificato da path assoluto
– STDIN di un processo: identificato da una pipe verso il programma da lanciare
– Utenti collegati: username, o * per tutti
– Server rsyslog remoto: @indirizzo o @nomelogico
    • La comunicazione avviene di default su UDP, porta 514
    {bisogna decommentare sul ricevente del log in /etc/rsyslog.conf: module(load="imudp") e input(type="imudp" port="514")}
    • se voglio usare TCP devo scrivere @@indirizzo

es: local1.=info /path/file/log (logga solo ~logger -p local1.info "suca")
local1.info /path/file/log (logga ~logger -p local1.{emerg, alert, crit, err, warning, notice, info} "suca")
local5.=info @ip /path/file/log

ES /etc/rsyslog.d/canale.conf
{basta echo "setup">/etc/rsyslog.d/canale.conf
systemctl restart rsyslog.service}
/etc/rsyslog.d/file.conf se oltre a configurare il canale vuoi abilitare il server UDP:

---

    module(load="imudp")
    input(type="imudp" port="514")
    local1.=info: /var/log/nfs.log

---

Dopo aver modificato /etc/rsyslog.conf, o ho aggiunto un file di configuazione in /etc/rsyslog.d/file.conf --> systemctl restart rsyslog.service

MONITORAGGIO PARAMETRI SISTEMA

La maggior parte sono interfacce verso il filesystem /proc.
/proc è uno pseudo-filesystem che mostra come file i parametri di
funzionamento del sistema. Non risiede su disco ed è una “apparizione” generata dal sistema
operativo attraverso il meccanismo dei virtual filesystem.

Esplorandola si mostrano file e cartelle che corrispondono alle strutture dati del kernel.
Andando a leggere i file si mostrano i dati nella struttura dati del kernel.
Si può anche scrivere su alcuni file provocando una riconfigurazione instantanea del kernel.

Parti principali
– directory con nomi numerici corrispondenti ai PID dei processi attivi
– directory che rappresentano alcuni macro-sistemi hardware •acpi, bus, driver, irq, tty
– directory che rappresentano parametri o funzioni del sistema operativo •fs, sys, sysvipc
– file con informazioni (principalmente statistiche di uso) globali del sistema

~ps PID{controllo solo il processo con PID}
-a vedo tutti i processi di sistema
-x elenca anche i processi avviati all’avvio come daemon
-u vedo l'user di ogni processo
-h (no headers)
-o pid,uname,cmd,cputimes[seconds], {formatting output}
--sort{+[crescente]-[decrescente] FLAGS}

FLAGS per --sort
c cmd simple name of executable
C pcpu cpu utilization
f flags flags as in long format F field
g pgrp process group ID
G tpgid controlling tty process group ID
j cutime cumulative user time
J cstime cumulative system time
k utime user time
m min_flt number of minor page faults
M maj_flt number of major page faults
n cmin_flt cumulative minor page faults
N cmaj_flt cumulative major page faults
o session session ID
p pid process ID
P ppid parent process ID
r rss resident set size
R resident resident pages
s size memory size in kilobytes
S share amount of shared pages
t tty the device number of the controlling tty
T start_time time process was started
U uid user ID number
u user user name
v vsize total VM size in KiB
y priority kernel scheduling priority

Riporta il carico del sistema:
Ad ogni invocazione dello scheduler viene registrato il numero totale di processi in stato R (runnable) o D (uninterruptable sleep)
I campioni vengono accumulati e mediati su tre scale temporali diverse per ottenere un’indicazione del trend nel tempo
~uptime -> {OUTPUT} -> [ora] up [tempo trascorso dal boot], [n. utenti connessi] users, load avarage: [1 min], [5 min], [15 min]

[Inforamazioni sulla RAM]
~free -> OUTPUT -> total used free shared buff/cache available
Mem: 237040 121248 9596 1464 106196 98720
Swap: 1045500 29572 1015928
[Total: ]
{used swap > 0 significa solo che in qualche momento è servita} N.B. available =~ free + buff/cache
-h display dei byte come M,G {MegaByte, GigaByte}
-t nuova riga con il totale delle caselle superiori

~top riassume ps, uptime, free + uso dettagliato cpu (comando di monitoraggio interattivo)
Un carico elevato può essere dovuto a molte cause diverse ed esaminare l’uso di memoria e CPU può dare un’indicazione
Es.
– CPU sostanzialmente scarica
• molti processi D? -> un dispositivo non risponde?
– CPU usata principalmente in userspace
• sistema CPU-bound
– CPU usata principalmente in iowait
• sistema I/O bound
• possono essere periferiche lente ma anche sovraccaricate per altri motivi
– swap molto usata? -> disco bombardato di swapout-swapin
– sistema memory-bounds

Indagini più approfondite si possono svolgere con vmstat e iostat

~vmstat SECONDS – uso di memoria, paging, I/O, trap
– utile invocarlo col periodo (in secondi) da monitorare

~iostat /dev/device- statistiche su uso CPU e I/O
– soprattutto per valutare l'uso dei dispositivi di I/O

SPAZIO DISCO

~df mostra l’utilizzo dello spazio dei dischi
SONO DIVERSI, MOLTO!!!
~du path/dir [-s summary senza subdir] permette di calcolare lo spazio occupato dai file sul disco (in una directory)

USO DEI FILE

Quali file sta usando un processo: {2208 è il pid del processo}
~ls –l /proc/2208/fd/

Quali processi stanno usando un file:
~fuser /etc/man.config
~fuser -k SIGNAME file -> killa tutti i processi che stanno usando quel file

O un filesystem
~fuser -m /var {c current directory.
e executable being run.
f open file. f is omitted in default display mode.
r root directory.
m mapped file or shared library.}

USO GLOBALE DEI FILE
~lsof – list open files
Osservazione: un file cancellato (unlink) dopo l'apertura sarà irreperibile sul filesystem,
dal processo e quindi visibile a lsof
